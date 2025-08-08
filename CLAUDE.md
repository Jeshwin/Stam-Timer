# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "Stam Focus" - a skeumorphic Pomodoro timer Flutter application. The project is currently in its initial state with the standard Flutter template code and needs to be developed into a functional Pomodoro timer.

## Development Commands

### Core Flutter Commands
- **Run the app**: `flutter run`
- **Build for release**: `flutter build apk` (Android) or `flutter build ios` (iOS)
  - ***DO NOT RUN BUILD***
- **Run tests**: `flutter test`
- **Analyze code**: `flutter analyze`
- **Format code**: `dart format lib/ test/`
- **Clean build**: `flutter clean`
- **Get dependencies**: `flutter pub get`

### Testing
- **Run all tests**: `flutter test`
- **Run tests with coverage**: `flutter test --coverage`
- **Run specific test file**: `flutter test test/widget_test.dart`

## Project Structure

```
lib/
  main.dart           # Entry point - currently contains template counter app
test/
  widget_test.dart    # Widget tests - currently tests the counter functionality
android/              # Android-specific configuration
ios/                  # iOS-specific configuration  
```

## Current State

The application currently contains only the default Flutter template code:
- `lib/main.dart` contains a basic counter app with MaterialApp, MyApp, and MyHomePage widgets
- The app needs to be completely rewritten to implement Pomodoro timer functionality
- The design should follow skeumorphic principles as specified in the project description

## Development Notes

- Uses Flutter SDK ^3.8.1
- Includes flutter_lints for code quality
- Uses Material Design with cupertino_icons
- Currently has minimal dependencies - additional packages will likely be needed for timer functionality, state management, and skeumorphic UI components
- Analysis options are configured with standard flutter_lints rules