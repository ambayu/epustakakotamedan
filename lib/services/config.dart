import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class Config {
  static const String environment =
      'server'; // Change to 'server' for server environment

  static const Map<String, Map<String, String>> environments = {
    'local': {
      'baseUrl': 'http://192.168.0.22:8000/api',
      'baseUrlFoto': 'http://192.168.0.22:8000',
    },
    'mnc': {
      'baseUrl': 'http://192.168.1.4:8000/api',
      'baseUrlFoto': 'http://192.168.1.4:8000',
    },
    'server': {
      'baseUrl': 'https://disperpustakaanarsip.medan.go.id/backend/api',
      'baseUrlFoto': 'https://disperpustakaanarsip.medan.go.id/backend',
    },
  };

  // Retrieve the configuration for the current environment
  static Map<String, String> getConfig() {
    return environments[environment] ?? {};
  }

  // Retrieve baseUrlFoto specifically
  static String getBaseUrlFoto() {
    final config = getConfig();
    return config['baseUrlFoto'] ?? '';
  }
}

class DioConfig {
  static Dio createDio() {
    final config = Config.getConfig();
    final dio = Dio()
      ..options.baseUrl = config['baseUrl'] ?? ''
      ..options.headers['accept'] = 'application/json'
      ..options.connectTimeout =
          const Duration(seconds: 30) // Ubah ke 30 detik jika perlu
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.sendTimeout = const Duration(seconds: 30)
      ..options.validateStatus = (status) {
        return status! < 500;
      };

    // Abaikan SSL certificate (Hanya untuk debugging, jangan di produksi!)
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }
}
