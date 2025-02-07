import 'package:epustakakotamedan_v2/components/appbar.dart';
import 'package:epustakakotamedan_v2/components/profil-component.dart';

import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class ProfilPage extends StatefulWidget {
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BayuAppBar(title: 'Profil Page'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            //page lain
            ProfilComponent()
          ],
        ),
      ),
    );
  }
}
