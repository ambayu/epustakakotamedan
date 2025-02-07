import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:epustakakotamedan_v2/datas/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MenuBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 2,
                height: 8,
                decoration: BoxDecoration(
                    color: Color(0xFFBBBBBB),
                    borderRadius: BorderRadius.circular(1)),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: 2,
                height: 8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1)),
              ),
            ],
          ),
        ),

        //gojeck icon atas
        ...perpusIcons.map((icon) => Flexible(
              fit: FlexFit.tight,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: (currentRoute == icon.slug
                            ? blue2
                            : Colors.white), //color

                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('${icon.slug}');
                        },
                        child: SvgPicture.asset(
                          'assets/icons/${icon.icon}.svg',
                          color: blue1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      icon.title,
                      style: semibold14.copyWith(color: Colors.white),
                    )
                  ]),
            )),
      ],
    );
  }
}
