import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionHelper {
  /// Request microphone permission for audio calls
  static Future<bool> requestAudioCallPermission(BuildContext context) async {
    final status = await Permission.microphone.request();
    
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        // For denied permissions, we should still allow the user to proceed
        // as they might want to use the feature without granting permission
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission denied. Call may have limited functionality.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        // Still return true to allow proceeding with the call
        return true;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final shouldOpenSettings = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Permission Required'),
                content: const Text('Microphone permission is required for audio calls. Would you like to open app settings to enable it?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Settings'),
                  ),
                ],
              );
            },
          );
          
          if (shouldOpenSettings == true) {
            await openAppSettings();
          }
        }
        // Return true to allow proceeding with the call even without permission
        return true;
      default:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to request microphone permission. Proceeding with call...'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return true;
    }
  }

  /// Request camera and microphone permissions for video calls
  static Future<bool> requestVideoCallPermissions(BuildContext context) async {
    // Request microphone permission first
    final micStatus = await Permission.microphone.request();
    
    bool micGranted = false;
    switch (micStatus) {
      case PermissionStatus.granted:
        micGranted = true;
        break;
      case PermissionStatus.denied:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission denied. Audio will be disabled in video call.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        micGranted = true; // Still allow proceeding
        break;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final shouldOpenSettings = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Permission Required'),
                content: const Text('Microphone permission is required for video calls. Would you like to open app settings to enable it?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Settings'),
                  ),
                ],
              );
            },
          );
          
          if (shouldOpenSettings == true) {
            await openAppSettings();
          }
        }
        micGranted = true; // Still allow proceeding
        break;
      default:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to request microphone permission. Proceeding with call...'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        micGranted = true; // Still allow proceeding
    }
    
    // Request camera permission
    final cameraStatus = await Permission.camera.request();
    
    bool cameraGranted = false;
    switch (cameraStatus) {
      case PermissionStatus.granted:
        cameraGranted = true;
        break;
      case PermissionStatus.denied:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission denied. Video will be disabled in call.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        cameraGranted = true; // Still allow proceeding
        break;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final shouldOpenSettings = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Permission Required'),
                content: const Text('Camera permission is required for video calls. Would you like to open app settings to enable it?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Settings'),
                  ),
                ],
              );
            },
          );
          
          if (shouldOpenSettings == true) {
            await openAppSettings();
          }
        }
        cameraGranted = true; // Still allow proceeding
        break;
      default:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to request camera permission. Proceeding with call...'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        cameraGranted = true; // Still allow proceeding
    }
    
    return micGranted && cameraGranted;
  }

  /// Check if audio call permissions are granted
  static Future<bool> hasAudioCallPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Check if video call permissions are granted
  static Future<bool> hasVideoCallPermissions() async {
    final micStatus = await Permission.microphone.status;
    final cameraStatus = await Permission.camera.status;
    return micStatus.isGranted && cameraStatus.isGranted;
  }
}