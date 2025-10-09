# Chat Audio/Video Call Features Documentation

## Overview

This document describes the newly implemented audio and video call features in the BrickSpace real estate application. These features allow users to communicate directly with property agents through voice and video calls without leaving the app.

## Features

### 1. Audio Calling
- One-to-one voice calls between users and agents
- Mute/unmute functionality
- Speakerphone toggle
- Call end functionality

### 2. Video Calling
- One-to-one video calls between users and agents
- Mute/unmute microphone
- Enable/disable camera
- Camera switch (front/rear)
- Call end functionality

## Implementation Details

### File Structure
```
lib/
├── services/
│   └── call_service.dart          # Call management service
├── screens/
│   ├── chat/
│   │   ├── chat_screen.dart       # Updated with call buttons
│   │   ├── chat_history_screen.dart # Updated with call options
│   │   └── video_call_screen.dart  # New call interface
├── AUDIO_VIDEO_CALL_SETUP.md      # Setup guide
└── CHAT_CALL_FEATURES.md          # This document
```

### Key Components

#### CallService
Handles the core functionality for audio/video calls using the Agora SDK:
- Initializes the Agora RTC engine
- Manages permissions
- Handles joining/leaving channels
- Controls audio/video states

#### VideoCallScreen
Provides the user interface for both audio and video calls:
- Displays remote participant
- Shows local video preview (for video calls)
- Provides call controls (mute, camera, end call)
- Handles call lifecycle

#### Updated Chat Screens
Both chat screens have been enhanced with call functionality:
- ChatScreen: Added call buttons in app bar and quick actions
- ChatHistoryScreen: Added global call buttons and per-contact call options

## User Flow

### Starting a Call from Chat
1. User opens a chat conversation
2. User taps the phone icon (audio) or video camera icon (video) in the app bar
3. App generates a unique channel ID and navigates to the call screen
4. Call connects automatically

### Starting a Call from Chat History
1. User opens the chat history screen
2. User can either:
   - Tap "Audio Call" or "Video Call" in the quick actions section
   - Tap the phone or video camera icon next to any contact
3. App generates a unique channel ID and navigates to the call screen
4. Call connects automatically

## UI Components

### Call Control Button
A reusable widget for call controls with customizable icons and actions.

### Quick Action Buttons
Added to both chat screens for easy access to calling features.

## Integration Points

### Dependencies
- agora_rtc_engine: ^6.2.2
- permission_handler: ^11.0.1

### Permissions Required
- Microphone access
- Camera access (for video calls)

## Customization

### UI Customization
The call interface can be customized by modifying `video_call_screen.dart`:
- Button styles and positions
- Color schemes
- Additional controls

### Functionality Extensions
The call service can be extended to support:
- Group calling
- Call recording
- Screen sharing
- Call statistics

## Testing

### Manual Testing
1. Verify call buttons appear in correct locations
2. Test audio call functionality
3. Test video call functionality
4. Verify call controls work properly
5. Test call end functionality

### Edge Cases
1. Network interruptions
2. Permission denials
3. Multiple simultaneous calls
4. App lifecycle during calls

## Known Limitations

1. Currently uses temporary tokens for Agora (not suitable for production)
2. No call history tracking
3. No incoming call notifications
4. Basic UI with minimal customization

## Future Enhancements

1. Implement token server for production use
2. Add call history tracking
3. Implement push notifications for incoming calls
4. Add contact synchronization
5. Enhance UI with animations and transitions
6. Add call quality indicators
7. Implement call recording functionality

## Setup Instructions

See `AUDIO_VIDEO_CALL_SETUP.md` for detailed setup instructions.