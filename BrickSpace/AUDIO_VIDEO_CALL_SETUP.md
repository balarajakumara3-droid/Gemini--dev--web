# Audio/Video Call Setup Guide

This guide explains how to set up and use the audio/video call functionality in the BrickSpace real estate app.

## Prerequisites

1. **Agora Account**: You need to create an account at [Agora.io](https://www.agora.io/en/) and obtain:
   - App ID
   - Temporary token (for testing) or set up a token server

2. **Dependencies**: The following packages have been added to `pubspec.yaml`:
   - `agora_rtc_engine: ^6.2.2`
   - `permission_handler: ^11.0.1`

## Setup Instructions

### 1. Update Agora Credentials

Open `lib/services/call_service.dart` and replace the placeholder values:

```dart
static const String appId = 'YOUR_AGORA_APP_ID'; // Replace with your Agora App ID
static const String token = 'YOUR_TEMP_TOKEN'; // Replace with your temp token
```

### 2. Install Dependencies

Run the following command to install the new dependencies:

```bash
flutter pub get
```

### 3. iOS Specific Setup

Add the following permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video calling</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for audio calling</string>
```

### 4. Android Specific Setup

Add the following permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## Features Implemented

### Audio Calling
- Mute/unmute microphone
- Speaker on/off
- End call

### Video Calling
- Mute/unmute microphone
- Enable/disable camera
- Switch between front and rear cameras
- End call

## Usage

### Starting a Call from Chat Screen
1. Open any chat conversation
2. Tap the phone icon for audio call or video camera icon for video call in the app bar
3. Alternatively, use the quick action buttons at the bottom of the chat screen

### Starting a Call from Chat History
1. Go to the chat history screen
2. Use the quick action buttons at the top for general calls
3. Or tap the phone/video camera icons next to any chat contact

## Testing

For testing purposes, you can use Agora's temporary tokens or implement a token server. For production, always use a secure token server.

## Customization

You can customize the call UI by modifying `lib/screens/chat/video_call_screen.dart`:
- Change button styles
- Add new call features
- Modify layout and positioning

## Troubleshooting

1. **Permissions**: Ensure all required permissions are granted
2. **Network**: Check internet connectivity
3. **App ID**: Verify Agora App ID is correct
4. **Token**: Ensure token is valid (if using token-based authentication)

## Next Steps

For production use, consider implementing:
1. Push notifications for incoming calls
2. Call history tracking
3. Contact synchronization
4. Advanced features like screen sharing