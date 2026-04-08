# Repository

This project is hosted at: [https://github.com/pauline12ish34/lab6-messaging.git](https://github.com/pauline12ish34/lab6-messaging.git)
# Flutter FCM Push Notifications Demo

This project demonstrates how to receive and display push notifications in a Flutter app using Firebase Cloud Messaging (FCM). It includes notification permission handling, device token retrieval, persistent notification history (using Hive), and UI popups for received messages.

## Features
- Receive push notifications from Firebase Cloud Messaging
- Request notification permissions on startup
- Display device token for testing
- Show received notifications in a list (persisted with Hive)
- Show a popup dialog when a notification is received
- Works in foreground, background, and terminated states

## Getting Started

### 1. Clone the Repository
```
git clone https://github.com/pauline12ish34/lab6-messaging.git
cd flutter_application_lab6
```

### 2. Firebase Setup
- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
- Add an Android app to your Firebase project
- Download `google-services.json` and place it in `android/app/`
- Run `flutterfire configure` to generate `firebase_options.dart`

### 3. Install Dependencies
```
flutter pub get
```

### 4. Run Code Generation for Hive
```
flutter packages pub run build_runner build
```

### 5. Run the App
```
flutter run
```

## Usage
- The device token is displayed on the home screen for easy copy-paste into the Firebase Console.
- Send a test notification from the Firebase Console (Cloud Messaging) using the device token.
- Received notifications are shown in a list and as a popup dialog.
- Notification history is saved locally and persists across app restarts.

## Project Structure
```
lib/
	main.dart                # App entry point, initializes Firebase & Hive
	home_screen.dart         # Main UI, notification handlers, Hive integration
	models/
		notification_model.dart      # Hive model for notifications
		notification_model.g.dart    # Generated Hive adapter
	services/
		notification_service.dart    # Notification logic abstraction
```

## Key Steps
1. Create Flutter app
2. Set up Firebase project and add Android app
3. Add FCM and Hive dependencies
4. Configure Android for Firebase
5. Initialize Firebase, FCM, and Hive
6. Handle notification permissions and device token
7. Display and persist notifications
8. Test with Firebase Console

## Observations & Notes
- Hive is used for persistent notification history.
- Device token is required for targeted testing from Firebase Console.
- App handles notifications in all states (foreground, background, terminated).
- Popups and notification list provide clear user feedback.

## Submission
- Source code (this repository)
- PDF with screenshots and summary (see assignment instructions)

---

**Author:** Pauline
# flutter_application_lab6

