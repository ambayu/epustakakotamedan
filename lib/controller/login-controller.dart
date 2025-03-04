import 'dart:convert'; // For jsonDecode
import 'dart:io';
import 'package:dio/dio.dart' as dio; // Alias for dio
import 'package:epustakakotamedan_v2/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  var errorMessage = ''.obs;
  var userProfile = {}.obs; // Rx untuk menyimpan profil pengguna

  // Base URL for API calls
  final storage = FlutterSecureStorage();

  final dioInstance = DioConfig.createDio(); // Use DioConfig
  String baseUrlFoto = Config.getBaseUrlFoto();

  Future<void> login(String username, String password) async {
    isLoading.value = true;

    try {
      var loginData = {
        'username': username,
        'password': password,
      };

      var response = await dioInstance.post('/login', data: loginData);

      if (response.data['success'] == true) {
        isLoggedIn.value = true;
        errorMessage.value = '';

        await storage.write(key: 'token', value: response.data['token']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(response.data['user']));

        String fotoUrl = baseUrlFoto +
            '/assets/img/profiles/' +
            response.data['user']['foto'];

        await prefs.setString('user_foto', fotoUrl);

        userProfile.value = {
          ...response.data['user'],
          'fotoUrl': fotoUrl,
        };

        print(response.data['user']);

        Get.offAllNamed('/dashboard');
      } else {
        errorMessage.value = response.data['message'] ?? 'Login failed';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print(errorMessage.value);
      print("ulululu");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk mengambil token
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> fetchUserProfile({bool forceUpdate = false}) async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    String? fotoUrl = prefs.getString('user_foto');

    if (userJson != null && !forceUpdate) {
      // Memperbarui userProfile di memori
      userProfile.value = {
        ...jsonDecode(userJson),
        'fotoUrl': fotoUrl,
      };
    } else {
      // Jika tidak ada data di SharedPreferences, ambil dari API
      await fetchUserProfileFromApi();
    }
  }

  Future<void> fetchUserProfileFromApi() async {
    String? token = await getToken();

    try {
      final response = await dioInstance.get(
        '/user',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        String fotoUrl = baseUrlFoto +
                '/assets/img/profiles/' +
                response.data['user']['foto'] ??
            '';

        // Memperbarui userProfile di memori
        userProfile.value = {
          ...response.data['user'],
          'fotoUrl': fotoUrl,
        };

        // Menyimpan data ke SharedPreferences untuk persisten penyimpanan
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(response.data['user']));
        await prefs.setString('user_foto', fotoUrl);
      } else {
        Get.snackbar('Error', 'Failed to fetch profile');
      }
    } on dio.DioError catch (e) {
      Get.snackbar('Error', 'Error fetching profile: ${e.message}');
    }
  }

  Future<void> updateProfileWithImage({
    required String name,
    required String nip,
    required String bidang,
    required String email,
    File? image,
  }) async {
    String? token = await getToken();

    final formData = dio.FormData.fromMap({
      'name': name,
      'nip': nip,
      'bidang': bidang,
      'email': email,
      if (image != null) 'foto': await dio.MultipartFile.fromFile(image.path),
    });

    try {
      final response = await dioInstance.post(
        '/profil/update',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token', // Correct token format
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 5, 70, 9),
          colorText: Colors.white,
        );
        await fetchUserProfile(forceUpdate: true);
        // userProfile.value = response.data['user'];
      } else {
        // Handle error messages from the response
        String message;
        if (response.data['errors'] != null) {
          var errors = response.data['errors'] as Map<String, dynamic>;
          message = errors.values
              .expand((e) => (e as List).cast<String>())
              .join(', ');
        } else {
          message = response.data['message'] ?? 'Failed to update profile';
        }
        Get.snackbar(
          'Error',
          message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 70, 10, 5),
          colorText: Colors.white,
        );
      }
    } on dio.DioError catch (e) {
      Get.snackbar('Error', 'Error updating profile: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      // Hapus token dari secure storage
      await storage.delete(key: 'token');

      // Hapus data pengguna dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('user_foto');

      // Update state isLoggedIn
      isLoggedIn.value = false;

      // Arahkan pengguna kembali ke halaman login
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: ${e.toString()}');
    }
  }
}
