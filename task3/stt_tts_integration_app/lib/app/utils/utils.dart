import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<bool> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    return status.isGranted;
  }

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
