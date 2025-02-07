import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BayuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  BayuAppBar({required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = Get.currentRoute;

    return AppBar(
      backgroundColor: green2,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 69,
      title: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: green1,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTab('Beranda', '/dashboard', currentRoute),
            _buildTab('Profil', '/profil', currentRoute),
            _buildTab('Pengaturan', '/pengaturan', currentRoute),
          ],
        ),
      ),
      actions: actions,
    );
  }

  Widget _buildTab(String title, String route, String currentRoute) {
    bool isActive = currentRoute == route;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isActive) {
            Get.offAllNamed(route);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isActive ? green1 : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: semibold14.copyWith(
                color: isActive ? green1 : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(71);
}
