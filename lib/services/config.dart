import 'package:dio/dio.dart';

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
      'baseUrl': 'http://perpustakaan.medan.go.id:82/back-end/api',
      'baseUrlFoto': 'http://perpustakaan.medan.go.id:82/back-end',
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
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 10)
      ..options.sendTimeout = const Duration(seconds: 10)
      ..options.validateStatus = (status) {
        return status! < 500;
      };

    return dio;
  }
}
