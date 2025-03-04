import 'package:epustakakotamedan_v2/controller/laporan-controller.dart';
import 'package:epustakakotamedan_v2/controller/laporan-rekap-controller.dart';
import 'package:epustakakotamedan_v2/page/dashboard.dart';
import 'package:epustakakotamedan_v2/page/laporan_buku.dart';
import 'package:epustakakotamedan_v2/page/laporan_rekap.dart';
import 'package:epustakakotamedan_v2/page/login.dart';
import 'package:epustakakotamedan_v2/page/pengaturan.dart';
import 'package:epustakakotamedan_v2/page/profil.dart';
import 'package:epustakakotamedan_v2/page/scan-instansi.dart';
import 'package:epustakakotamedan_v2/page/scan.dart';
import 'package:epustakakotamedan_v2/page/soon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'services/config.dart';

void main() {
  Get.put(LaporanController());
  Get.put(LaporanRekapController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: VersionCheckWrapper(),
      getPages: [
        GetPage(
            name: '/login',
            page: () => LoginPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/dashboard',
            page: () => DashboardPage(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: '/scan',
            page: () => ScanPage(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: '/profil',
            page: () => ProfilPage(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: '/laporan-buku',
            page: () => LaporanBuku(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: '/laporan-rekap',
            page: () => LaporanRekap(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: '/pengaturan',
            page: () => PengaturanPage(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: '/scan-instansi',
            page: () => ScanInstansiPage(),
            transition: Transition.cupertinoDialog)
      ],
    );
  }
}

class VersionCheckWrapper extends StatefulWidget {
  @override
  _VersionCheckWrapperState createState() => _VersionCheckWrapperState();
}

class _VersionCheckWrapperState extends State<VersionCheckWrapper> {
  bool _isCheckingVersion = true;

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    Dio dio = DioConfig.createDio();
    try {
      final response = await dio.get('/check-version');
      if (response.statusCode == 200) {
        final data = response.data;
        String latestVersion = data['latest_version'];
        String downloadLink = data['download_link'];
        print('respon = ' + response.toString());
        if (currentVersion != latestVersion) {
          _showUpdateDialog(currentVersion, latestVersion, downloadLink);
        } else {
          setState(() {
            _isCheckingVersion = false;
          });
        }
      } else {
        setState(() {
          _isCheckingVersion = false;
        });
      }
    } catch (e) {
      setState(() {
        _isCheckingVersion = false;
      });
    }
  }

  void _showUpdateDialog(
      String currentVersion, String latestVersion, String downloadLink) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Tersedia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Versi aplikasi Anda: $currentVersion'),
              Text('Versi terbaru yang tersedia: $latestVersion'),
              SizedBox(height: 10),
              Text(
                  'Silakan update aplikasi Anda untuk mendapatkan fitur terbaru.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isCheckingVersion = false;
                });
              },
              child: Text('Nanti'),
            ),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse(downloadLink);
                try {
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                    webViewConfiguration: WebViewConfiguration(
                      enableJavaScript: true,
                      enableDomStorage: true,
                    ),
                  )) {
                    throw Exception('Could not launch $url');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Tidak dapat membuka link download. Error: ${e.toString()}'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Update Sekarang'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingVersion) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return LoginPage();
    }
  }
}
