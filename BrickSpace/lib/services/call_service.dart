import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class CallService {
  static const String appId = 'YOUR_AGORA_APP_ID'; // Replace with your Agora App ID
  static const String token = 'YOUR_TEMP_TOKEN'; // Replace with your temp token or implement token server
  
  RtcEngine? _engine;
  bool isInitialized = false;
  
  // Singleton instance
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();
  
  Future<void> initialize() async {
    if (isInitialized) return;
    
    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('Join channel success: ${connection.channelId}');
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint('Remote user joined: $remoteUid');
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint('Remote user offline: $remoteUid');
          },
        ),
      );
      
      isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing Agora engine: $e');
    }
  }
  
  Future<bool> checkPermissions(bool isVideoCall) async {
    if (defaultTargetPlatform == TargetPlatform.android || 
        defaultTargetPlatform == TargetPlatform.iOS) {
      final micStatus = await Permission.microphone.request();
      
      if (isVideoCall) {
        final cameraStatus = await Permission.camera.request();
        return micStatus == PermissionStatus.granted && 
               cameraStatus == PermissionStatus.granted;
      }
      
      return micStatus == PermissionStatus.granted;
    }
    return true;
  }
  
  Future<void> joinChannel(String channelId, {bool isVideoCall = true}) async {
    // Check permissions first
    final permissionsGranted = await checkPermissions(isVideoCall);
    if (!permissionsGranted) {
      throw Exception('Permissions not granted');
    }
    
    if (!isInitialized) {
      await initialize();
    }
    
    if (isVideoCall) {
      await _engine?.enableVideo();
      await _engine?.startPreview();
    } else {
      await _engine?.disableVideo();
    }
    
    await _engine?.joinChannel(
      token: token,
      channelId: channelId,
      uid: 0,
      options: ChannelMediaOptions(),
    );
  }
  
  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
  }
  
  Future<void> toggleMute(bool isMuted) async {
    await _engine?.muteLocalAudioStream(isMuted);
  }
  
  Future<void> toggleVideo(bool isVideoEnabled) async {
    await _engine?.muteLocalVideoStream(!isVideoEnabled);
  }
  
  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }
  
  void dispose() {
    _engine?.release();
    isInitialized = false;
  }
}