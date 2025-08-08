import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'timer_interface.dart';

class BackgroundTimerService {
  static const String _backgroundTimerActiveKey = 'background_timer_active';
  static const String _backgroundStartTimeKey = 'background_start_time';
  static const String _backgroundRemainingTimeKey = 'background_remaining_time';
  static const String _backgroundTimerIndexKey = 'background_timer_index';
  
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = 
    FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    print('🔧 INITIALIZING BACKGROUND TIMER SERVICE...');
    
    try {
      tz.initializeTimeZones();
      print('✅ Timezone initialized');
    } catch (e) {
      print('❌ Timezone initialization failed: $e');
    }
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      final initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );
      print('✅ Notification plugin initialized: $initialized');
    } catch (e) {
      print('❌ Notification initialization failed: $e');
      rethrow;
    }

    // Check and request permissions
    try {
      final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final granted = await androidImpl.requestNotificationsPermission();
        print('📱 Android notification permission granted: $granted');
      }
    } catch (e) {
      print('⚠️ Permission request failed: $e');
    }

    print('🔧 Background timer service initialization complete');
  }

  static Future<void> _onNotificationTap(NotificationResponse response) async {
    print('🔔 NOTIFICATION TAPPED!');
    print('   Response ID: ${response.id}');
    print('   Payload: ${response.payload}');
    print('   Action ID: ${response.actionId}');
    
    if (response.payload != null) {
      final int finishedTimerIndex = int.parse(response.payload!);
      print('   Finished Timer Index: $finishedTimerIndex');
      await _handleNotificationTap(finishedTimerIndex);
    } else {
      print('❌ No payload in notification response');
    }
  }

  static Future<void> _handleNotificationTap(int finishedTimerIndex) async {
    print('🔄 HANDLING NOTIFICATION TAP: Timer $finishedTimerIndex finished');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_tapped_timer_index', finishedTimerIndex);
    print('✅ Saved tapped timer index to SharedPreferences');
    // The app will check this key when it opens
  }

  static Future<void> saveBackgroundTimer({
    required int remainingTimeSeconds,
    required int currentTimerIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    
    print('🔄 SAVING BACKGROUND TIMER:');
    print('   Timer Index: $currentTimerIndex');
    print('   Remaining Time: ${remainingTimeSeconds}s (${(remainingTimeSeconds/60).toStringAsFixed(1)} min)');
    print('   Current Time: ${DateTime.now()}');
    print('   Timestamp: $currentTime');
    
    await prefs.setBool(_backgroundTimerActiveKey, true);
    await prefs.setInt(_backgroundStartTimeKey, currentTime);
    await prefs.setInt(_backgroundRemainingTimeKey, remainingTimeSeconds);
    await prefs.setInt(_backgroundTimerIndexKey, currentTimerIndex);
    
    print('✅ Background timer saved to SharedPreferences');
  }

  static Future<void> scheduleNotification({
    required int remainingTimeSeconds,
    required TimerType timerType,
    required int currentTimerIndex,
  }) async {
    final scheduledTime = DateTime.now().add(Duration(seconds: remainingTimeSeconds));
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    
    String title;
    String body;
    
    switch (timerType) {
      case TimerType.work:
        title = "Work Timer Complete!";
        body = "Work time over, time to take a break!";
        break;
      case TimerType.shortBreak:
        title = "Short Break Complete!";
        body = "Break time over, time to focus!";
        break;
      case TimerType.longBreak:
        title = "Long Break Complete!";
        body = "Break time over, time to focus!";
        break;
    }

    print('📅 SCHEDULING NOTIFICATION:');
    print('   Timer Type: $timerType');
    print('   Title: $title');
    print('   Body: $body');
    print('   Current Time: ${DateTime.now()}');
    print('   Scheduled for: $scheduledTime');
    print('   TZ Scheduled: $tzScheduledTime');
    print('   Remaining: ${remainingTimeSeconds}s (${(remainingTimeSeconds/60).toStringAsFixed(1)} min)');
    print('   Timer Index: $currentTimerIndex');
    print('   Payload: $currentTimerIndex');

    const androidDetails = AndroidNotificationDetails(
      'timer_channel',
      'Timer Notifications',
      channelDescription: 'Notifications for timer completion',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        0, // notification id
        title,
        body,
        tzScheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: currentTimerIndex.toString(),
      );
      print('✅ Notification scheduled successfully!');
    } catch (e) {
      print('❌ Failed to schedule notification: $e');
      rethrow;
    }
  }

  static Future<BackgroundTimerResult?> checkBackgroundTimer() async {
    print('🔍 CHECKING BACKGROUND TIMER...');
    final prefs = await SharedPreferences.getInstance();
    
    final isActive = prefs.getBool(_backgroundTimerActiveKey) ?? false;
    final startTime = prefs.getInt(_backgroundStartTimeKey);
    final originalRemainingTime = prefs.getInt(_backgroundRemainingTimeKey);
    final timerIndex = prefs.getInt(_backgroundTimerIndexKey);

    print('   Is Active: $isActive');
    print('   Start Time: $startTime');
    print('   Original Remaining: $originalRemainingTime');
    print('   Timer Index: $timerIndex');

    if (!isActive) {
      print('❌ No background timer active');
      return null;
    }

    if (startTime == null || originalRemainingTime == null || timerIndex == null) {
      print('❌ Missing background timer data');
      return null;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final elapsedSeconds = ((currentTime - startTime) / 1000).round();
    final newRemainingTime = originalRemainingTime - elapsedSeconds;

    print('   Current Time: ${DateTime.now()}');
    print('   Start Time: ${DateTime.fromMillisecondsSinceEpoch(startTime)}');
    print('   Elapsed: ${elapsedSeconds}s');
    print('   New Remaining: ${newRemainingTime}s');
    print('   Was Completed: ${newRemainingTime <= 0}');

    return BackgroundTimerResult(
      remainingTime: newRemainingTime,
      timerIndex: timerIndex,
      wasCompleted: newRemainingTime <= 0,
    );
  }

  static Future<int?> checkNotificationTapped() async {
    final prefs = await SharedPreferences.getInstance();
    final tappedIndex = prefs.getInt('notification_tapped_timer_index');
    if (tappedIndex != null) {
      await prefs.remove('notification_tapped_timer_index');
      return tappedIndex;
    }
    return null;
  }

  static Future<void> clearBackgroundTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_backgroundTimerActiveKey);
    await prefs.remove(_backgroundStartTimeKey);
    await prefs.remove(_backgroundRemainingTimeKey);
    await prefs.remove(_backgroundTimerIndexKey);
    
    // Cancel any pending notifications
    await _notificationsPlugin.cancel(0);
  }
}

class BackgroundTimerResult {
  final int remainingTime;
  final int timerIndex;
  final bool wasCompleted;

  BackgroundTimerResult({
    required this.remainingTime,
    required this.timerIndex,
    required this.wasCompleted,
  });
}