import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:epustakakotamedan_v2/models/model.dart';
import 'package:epustakakotamedan_v2/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeController extends GetxController {
  var selectedInstansiId = 0.obs;
  var isLoading = false.obs;

  RxList<Map<String, dynamic>> scanResults =
      <Map<String, dynamic>>[].obs; // Use RxList for reactivity
  Timer? cooldownTimer;
  DateTime? lastScanTime;
  final cooldownDuration = Duration(seconds: 3);
  final storage = FlutterSecureStorage();
  var userProfile = {}.obs;
  final dioInstance = DioConfig.createDio(); // Use DioConfig

  final isInstansiLocked = false.obs;
  final instansiName = ''.obs;
  var instansiList = <Instansi>[].obs;
  var selectedInstansi = Rxn<Instansi>();

  @override
  void onInit() {
    loadInstansi();
    super.onInit();
  }

  Future<void> loadInstansi() async {
    try {
      isLoading.value = true;
      final response = await dio.Dio().get(
          'http://157.15.116.164/bkd-presensi/api/mobile?req=list_instansi');

      // Menampilkan response di console
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        instansiList.value =
            (response.data as List).map((e) => Instansi.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data instansi');
      print('Error: $e'); // Menampilkan error di console
    } finally {
      isLoading.value = false;
    }
  }

  void lockInstansi() {
    if (selectedInstansi.value != null) {
      isInstansiLocked.value = true;
      instansiName.value = selectedInstansi.value!.name;
    } else {
      Get.snackbar('Error', 'Pilih instansi terlebih dahulu');
    }
  }

  void unlockInstansi() {
    isInstansiLocked.value = false;
  }

  Future<void> handleBarcodeScan(String code) async {
    if (lastScanTime != null &&
        DateTime.now().difference(lastScanTime!) < cooldownDuration) {
      print('Scan ignored due to cooldown period');
      return;
    }

    lastScanTime = DateTime.now();
    cooldownTimer?.cancel();
    cooldownTimer = Timer(cooldownDuration, () {
      lastScanTime = null;
    });

    isLoading.value = true;

    try {
      final response = await dio.Dio().get(
        'http://perpustakaan.medan.go.id/login_api/',
        queryParameters: {
          'category': 'cari_barcode',
          'barcode': code,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        if (data.isNotEmpty) {
          final result = data[0];
          final scanResult = {
            'ID': result['ID'],
            'Title': result['Title'],
            'Author': result['Author'],
          };
          scanResults.add(scanResult);
        } else {
          Get.snackbar('Not Found', 'Barcode not found');
        }
      } else {
        Get.snackbar(
          'Error',
          'Barcode tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 129, 130, 129),
          colorText: const Color.fromARGB(255, 0, 0, 0),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error fetching data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 129, 130, 129),
        colorText: const Color.fromARGB(255, 0, 0, 0),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void removeScanResult(int index) {
    if (index >= 0 && index < scanResults.length) {
      scanResults.removeAt(index);
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    // Jika userJson tidak null, dekode JSON menjadi Map
    if (userJson != null) {
      return json.decode(userJson); // Mengembalikan Map yang didekode
    }

    return null; // Mengembalikan null jika tidak ada data
  }

  Future<void> SaveToLaporanMasuk(
      String catalog_id, String title, String author, int index) async {
    isLoading.value = true;
    String? token = await getToken();
    Map<String, dynamic>? user = await getUser();

    try {
      var Formdata = {
        'catalog_id': catalog_id,
        'author': author,
        'judul': title,
        'user_id': user!['id'],
      };

      var response = await dioInstance.post(
        '/baca-ditempat/laporan-masuk',
        data: Formdata,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data['success'] == true) {
        Get.snackbar(
          'Success',
          'Data Berhasil disimpan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 45, 137, 45),
          colorText: const Color.fromARGB(255, 237, 237, 237),
        );
        removeScanResult(index);
      } else {
        Get.snackbar(
          'Error',
          'Terjadi Kesalahan' + response.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 129, 130, 129),
          colorText: const Color.fromARGB(255, 0, 0, 0),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error fetching data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 129, 130, 129),
        colorText: const Color.fromARGB(255, 0, 0, 0),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> SaveToLaporanMasukInstansi(String catalog_id, String title,
      String author, String instansi, int index) async {
    isLoading.value = true;
    String? token = await getToken();
    Map<String, dynamic>? user = await getUser();
    // Menampilkan isi parameter menggunakan Snackbar

    try {
      var Formdata = {
        'catalog_id': catalog_id,
        'author': author,
        'judul': title,
        'user_id': user!['id'],
        'id_instansi': selectedInstansi.value?.id,
      };

      var response = await dioInstance.post(
        '/pencatatan-manual-instansi/laporan-masuk',
        data: Formdata,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data['success'] == true) {
        Get.snackbar(
          'Success',
          'Data Berhasil disimpan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 45, 137, 45),
          colorText: const Color.fromARGB(255, 237, 237, 237),
        );
        removeScanResult(index);
      } else {
        Get.snackbar(
          'Error',
          'Terjadi Kesalahan' + response.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 129, 130, 129),
          colorText: const Color.fromARGB(255, 0, 0, 0),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error fetching data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 129, 130, 129),
        colorText: const Color.fromARGB(255, 0, 0, 0),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
