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

void main() {
  Get.put(LaporanController());
  Get.put(LaporanRekapController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginPage(),
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
