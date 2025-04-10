import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class StoragePermissionHelper {
  /// Check if storage permission is granted
  static Future<bool> get isGranted async {
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }

  /// Request storage permission (without UI)
  static Future<PermissionStatus> request() async {
    try {
      if (await isGranted) return PermissionStatus.granted;
      return await Permission.manageExternalStorage.request();
    } catch (e) {
      debugPrint("Permission error: $e");
      return PermissionStatus.denied;
    }
  }

  /// Open app settings for manual permission enabling
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
