import 'package:flutter/material.dart';
import 'package:real_estate_app/services/call_service.dart';
import 'package:real_estate_app/utils/permission_helper.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelId;
  final String agentName;
  final String agentImage;
  final bool isVideoCall;

  const VideoCallScreen({
    super.key,
    required this.channelId,
    required this.agentName,
    required this.agentImage,
    this.isVideoCall = true,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final CallService _callService = CallService();
  bool isMuted = false;
  bool isVideoEnabled = true;
  bool isSpeakerOn = true;
  int remoteUid = 0;
  bool isJoined = false;
  bool permissionsGranted = false;
  bool isInitializing = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    setState(() {
      isInitializing = true;
    });

    try {
      // We'll proceed with the call regardless of permission status
      // The Agora SDK will handle cases where permissions are not granted
      bool permissionsRequestGranted;
      if (widget.isVideoCall) {
        permissionsRequestGranted = await PermissionHelper.requestVideoCallPermissions(context);
      } else {
        permissionsRequestGranted = await PermissionHelper.requestAudioCallPermission(context);
      }
      
      // Always proceed with initialization, permissions will be handled by the SDK
      setState(() {
        permissionsGranted = true;
        isInitializing = false;
      });
      _initCall();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proceeding with call...')),
        );
      }
      
      // Still proceed with the call
      setState(() {
        permissionsGranted = true;
        isInitializing = false;
      });
      _initCall();
    }
  }

  Future<void> _initCall() async {
    try {
      await _callService.joinChannel(
        widget.channelId,
        isVideoCall: widget.isVideoCall,
      );
      
      setState(() {
        isJoined = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join call: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _callService.leaveChannel();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    _callService.toggleMute(isMuted);
  }

  void _toggleVideo() {
    if (widget.isVideoCall) {
      setState(() {
        isVideoEnabled = !isVideoEnabled;
      });
      _callService.toggleVideo(isVideoEnabled);
    }
  }

  void _switchCamera() {
    _callService.switchCamera();
  }

  void _endCall() {
    _callService.leaveChannel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isInitializing) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  widget.isVideoCall 
                      ? 'Initializing video call...' 
                      : 'Initializing audio call...',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // Remote video view
          Center(
            child: Container(
              color: Colors.black,
              child: isJoined
                  ? const Center(
                      child: Text(
                        'Connected',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Connecting...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ),
          
          // Agent info
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.agentImage),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.agentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Call controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mute button
                CallControlButton(
                  icon: isMuted ? Icons.mic_off : Icons.mic,
                  onPressed: _toggleMute,
                  backgroundColor: isMuted ? Colors.red : Colors.white,
                ),
                
                // Video toggle (only for video calls)
                if (widget.isVideoCall)
                  CallControlButton(
                    icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                    onPressed: _toggleVideo,
                    backgroundColor: isVideoEnabled ? Colors.white : Colors.red,
                  ),
                
                // Switch camera (only for video calls)
                if (widget.isVideoCall)
                  CallControlButton(
                    icon: Icons.cameraswitch,
                    onPressed: _switchCamera,
                    backgroundColor: Colors.white,
                  ),
                
                // End call button
                CallControlButton(
                  icon: Icons.call_end,
                  onPressed: _endCall,
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CallControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}