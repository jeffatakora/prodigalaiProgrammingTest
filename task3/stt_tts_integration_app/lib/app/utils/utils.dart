import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Utility class containing app-wide helper functions.
class Utils {
  /// Requests microphone permission for speech-to-text features.
  static Future<bool> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Displays an error dialog with a given title and message.
  static void showErrorDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
