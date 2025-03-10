import 'package:flutter/material.dart';

// Colors
Color green1 = Color.fromARGB(255, 33, 128, 152),
    green2 = Color.fromARGB(255, 0, 113, 136);

Color dark1 = const Color(0xFF1C1C1C);
Color dark2 = const Color(0xFF4A4A4A);
Color dark3 = const Color(0xFF999798);
Color dark4 = const Color(0xFFEDEDED);

Color blue1 = const Color(0xFF0281A0);
Color blue2 = const Color.fromARGB(255, 179, 241, 255);
Color blue3 = const Color(0xFF38BBDA);

Color red = const Color(0xFFED2739);
Color purple = const Color(0xFF87027B);

// Typography
TextStyle regular12_5 =
    const TextStyle(fontFamily: 'SF-Pro-Display', fontSize: 12.5);
TextStyle regular14 = regular12_5.copyWith(fontSize: 14);

TextStyle semibold12_5 = regular12_5.copyWith(fontWeight: FontWeight.w600);
TextStyle semibold14 = semibold12_5.copyWith(fontSize: 14, letterSpacing: 0.1);

TextStyle bold16 = regular12_5.copyWith(
    fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.1);
TextStyle bold18 = bold16.copyWith(fontSize: 18, letterSpacing: -0.5);
