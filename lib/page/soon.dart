import 'package:epustakakotamedan_v2/components/menubar.dart';
import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:epustakakotamedan_v2/components/appbar.dart';

class SoonPage extends StatelessWidget {
  const SoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BayuAppBar(title: 'Coming Soon'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 15,
              right: 15,
            ),
            child: Container(
                height: 96,
                decoration: BoxDecoration(
                    color: blue1,
                    borderRadius: BorderRadiusDirectional.circular(15)),
                child: MenuBarWidget()),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 100.0,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'We are working hard to bring you this feature!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Stay tuned for updates and thank you for your patience.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
