import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController {
  // Untuk menangani status permintaan izin saat ini
  bool _isRequestingPermission = false;

  // Meminta izin untuk kamera
  Future<bool> requestCameraPermission() async {
    if (_isRequestingPermission) {
      return false; // Jangan buat permintaan baru jika sudah ada permintaan yang sedang berlangsung
    }

    _isRequestingPermission = true;
    final status = await Permission.camera.request();
    _isRequestingPermission = false;
    return status.isGranted;
  }

  // Meminta izin untuk penyimpanan
  Future<bool> requestStoragePermission() async {
    if (_isRequestingPermission) {
      return false; // Jangan buat permintaan baru jika sudah ada permintaan yang sedang berlangsung
    }

    _isRequestingPermission = true;
    final status = await Permission.storage.request();
    _isRequestingPermission = false;
    return status.isGranted;
  }

  // Cek izin kamera
  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  // Cek izin penyimpanan
  Future<bool> checkStoragePermission() async {
    bool permissionStatus;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus = await Permission.photos.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }
    return permissionStatus;
  }

  // Meminta izin untuk akses penuh ke penyimpanan (untuk Android 11 dan lebih tinggi)
  Future<bool> requestManageExternalStoragePermission() async {
    if (_isRequestingPermission) {
      return false; // Jangan buat permintaan baru jika sudah ada permintaan yang sedang berlangsung
    }

    _isRequestingPermission = true;
    final status = await Permission.manageExternalStorage.request();
    _isRequestingPermission = false;
    return status.isGranted;
  }

  // Cek izin untuk akses penuh ke penyimpanan
  Future<bool> checkManageExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }
}
