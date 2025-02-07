import 'package:epustakakotamedan_v2/components/appbar.dart';
import 'package:epustakakotamedan_v2/components/menubar.dart';
import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:epustakakotamedan_v2/controller/permission-controller.dart';
import 'package:epustakakotamedan_v2/datas/data.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PermissionController _permissionController = PermissionController();

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  // Mendapatkan nama rute saat ini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BayuAppBar(title: 'Home Page'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Container(
                  height: 96,
                  decoration: BoxDecoration(
                      color: blue1,
                      borderRadius: BorderRadiusDirectional.circular(15)),
                  child: MenuBarWidget()),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              // height: 300, // Specify the height for the CarouselSlider
              child: CarouselSlider(
                items: myData,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: true,
                    height: 310,
                    enlargeCenterPage: true,
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset('assets/images/tampilan-depan.png')
          ],
        ),
      ),
    );
  }
}
