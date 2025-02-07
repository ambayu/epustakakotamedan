import 'package:dio/dio.dart' as dio;
import 'package:epustakakotamedan_v2/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LaporanRekapController extends GetxController {
  // Observables for state management
  var isLoading = false.obs;
  var hasMore = true.obs;
  var books = <Map<String, dynamic>>[].obs;
  var subbooks = <Map<String, dynamic>>[].obs;
  var totalData = 0.obs;
  var totalPages = 0.obs;
  var currentPage = 1.obs;
  final storage = FlutterSecureStorage();
  final dioInstance = DioConfig.createDio();
  final int _itemsPerPage = 12;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  Rx<String?> searchQuery = Rx<String?>(null); // New search query observable
  Rx<String?> selectedValue = Rx<String?>('1');

  // Retrieve token from secure storage
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Format DateTime to 'Y-m-d'
  String? formatDateToYMD(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Fetch books with optional pagination and filters
  Future<void> fetchBooks({bool isNext = true}) async {
    if (isLoading.value) return;
    if (isNext && !hasMore.value) return;
    if (!isNext && currentPage.value <= 1) return;

    isLoading.value = true;

    if (isNext) {
      currentPage.value++;
    } else {
      currentPage.value--;
    }

    books.clear(); // Clear previous data

    String? token = await getToken();

    String endpoint;

    if (selectedValue == '1') {
      endpoint = '/baca-ditempat';
    } else if (selectedValue == '2') {
      endpoint = '/pencatatan-manual-instansi';
    } else {
      endpoint = '/baca-ditempat'; // Tambahkan endpoint default jika diperlukan
    }

    try {
      // Format dates for API request
      String? formattedStartDate = formatDateToYMD(startDate.value);
      String? formattedEndDate = formatDateToYMD(endDate.value);

      final response = await dioInstance.get(
        endpoint,
        queryParameters: {
          'page': currentPage.value,
          'per_page': _itemsPerPage,
          if (formattedStartDate != null) 'tanggal_awal': formattedStartDate,
          if (formattedEndDate != null) 'tanggal_akhir': formattedEndDate,
          if (searchQuery.value != null) 'search': searchQuery.value,
        },
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data['success'] == true) {
        final List data = response.data['data']['data'];
        totalData.value = response.data['data']['total'];
        totalPages.value = (totalData.value / _itemsPerPage).ceil();
        books.addAll(data.map((e) => e as Map<String, dynamic>).toList());
        hasMore.value = currentPage.value < totalPages.value;
        print(books);
      } else {
        showError('Failed to load data: ${response.data}');
      }
    } catch (e) {
      showError('Error fetching data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Show error messages
  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Reset filters and refetch data
  void resetAndRefetch() {
    books.clear();
    currentPage.value = 0;
    hasMore.value = true;
    fetchBooks();
  }

  // Update date range and refetch data
  void updateDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    currentPage.value = 1; // Reset the page to 1
    resetAndRefetch();
  }

  // Update search query and refetch data
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 1; // Reset page number
    resetAndRefetch(); // Refetch data with the new search query
  }

  // Delete a book by ID
  Future<void> deleteBook(String id) async {
    try {
      String? token = await getToken();

      final response = await dioInstance.delete(
        '/baca-ditempat/laporan-masuk/destroy/$id',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data['success'] == true) {
        Get.snackbar(
          'Success',
          'Data berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        resetAndRefetch(); // Refresh the data after deletion
      } else {
        showError('Failed to delete data: ${response.data}');
      }
    } catch (e) {
      showError('Error deleting data: ${e.toString()}');
    }
  }
}
