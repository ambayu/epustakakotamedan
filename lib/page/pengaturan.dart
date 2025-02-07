import 'package:epustakakotamedan_v2/components/appbar.dart';
import 'package:epustakakotamedan_v2/components/menubar.dart';
import 'package:epustakakotamedan_v2/components/profil-component.dart';
import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:epustakakotamedan_v2/controller/login-controller.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class PengaturanPage extends StatefulWidget {
  static const nameRoute = '/profil-page';

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BayuAppBar(title: 'Profil Page'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
              ),
              child: Container(
                  height: 96,
                  decoration: BoxDecoration(
                      color: blue1,
                      borderRadius: BorderRadiusDirectional.circular(15)),
                  child: MenuBarWidget()),
            ),
            SizedBox(
              height: 10,
            ),
            itemPengaturan('Logout', '', CupertinoIcons.power),
            itemPengaturan('Ubah Password', '', CupertinoIcons.lock),
          ],
        ),
      ),
    );
  }

  Widget itemPengaturan(String title, String subtitle, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // Menghapus padding
        ),
        onPressed: () {
          if (title == 'Logout') {
            final loginController = Get.find<LoginController>();
            loginController.logout();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                color: Colors.green.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(iconData),
            trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
            tileColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
