import 'dart:math';

import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:epustakakotamedan_v2/models/parpus_icon.dart';
import 'package:flutter/material.dart';

List<perpusIcon> perpusIcons = [
  perpusIcon(icon: 'camera', title: 'Scan', slug: '/scan'),
  perpusIcon(icon: 'topup', title: 'Data', slug: '/laporan-buku'),
  perpusIcon(icon: 'explore', title: 'Rekap', slug: '/laporan-rekap'),
  perpusIcon(icon: 'camera', title: 'I Scan', slug: '/scan-instansi')
];

List<perpusIcon> menuIcons = [
  perpusIcon(
      icon: 'goride', title: 'GoRide', color: green2, slug: '/scan-page'),
  perpusIcon(icon: 'gocar', title: 'GoCar', color: green2, slug: '/scan-page'),
  perpusIcon(icon: 'gofood', title: 'GoFood', color: red, slug: '/scan-page'),
  perpusIcon(
      icon: 'gosend', title: 'GoSend', color: green2, slug: '/scan-page'),
  perpusIcon(icon: 'gomart', title: 'GoMart', color: red, slug: '/scan-page'),
  perpusIcon(
      icon: 'gopulsa', title: 'GoPulsa', color: blue2, slug: '/scan-page'),
  perpusIcon(
      icon: 'goclub', title: 'GoClub', color: purple, slug: '/scan-page'),
  perpusIcon(icon: 'other', title: 'Lainnya', color: dark4, slug: '/scan-page'),
];

final List<Widget> myData = [
  Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      decoration: BoxDecoration(
        color: green2,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.2), // Warna bayangan dengan opacity
            spreadRadius: 2, // Radius penyebaran bayangan
            blurRadius: 5, // Radius blur bayangan
            offset: Offset(0, 4), // Offset bayangan (x, y)
          ),
        ],
      ),
      width: 500,
      child: Column(children: [
        Expanded(
          flex: 2,
          // Mengatur proporsi tinggi bagian atas
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/baner3.png'), // Ganti dengan path gambar Anda
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1, // Mengatur proporsi tinggi bagian atas
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Center(
                  child: const Text(
                    'JAM LAYANAN PERPUSTAKAAN KOTA MEDAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  'Perpustakaan Kota Medan buka dari Senin hingga Jumat, pukul 08.30 - 16.15 WIB, dan hingga 16.45 WIB pada hari Jumat. Ayo, eksplor koleksi menarik kami!',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 3, // Menentukan jumlah baris maksimum
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ]),
    ),
  ),
  Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      decoration: BoxDecoration(
        color: green2,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.2), // Warna bayangan dengan opacity
            spreadRadius: 2, // Radius penyebaran bayangan
            blurRadius: 5, // Radius blur bayangan
            offset: Offset(0, 4), // Offset bayangan (x, y)
          ),
        ],
      ),
      height: 200,
      width: 500,
      child: Column(children: [
        Expanded(
          flex: 2, // Mengatur proporsi tinggi bagian atas
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/baner2.png'), // Ganti dengan path gambar Anda
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1, // Mengatur proporsi tinggi bagian atas
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Center(
                  child: const Text(
                    'SURVEI KEPUASAN MASYARAKAT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  'Bantu tingkatkan layanan Perpustakaan Kota Medan dengan isi survei! Klik gambar di atas dan beri pendapatmu. Yuk, suarakan sekarang!',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 3, // Menentukan jumlah baris maksimum
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ]),
    ),
  ),
  Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      decoration: BoxDecoration(
        color: green2,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.2), // Warna bayangan dengan opacity
            spreadRadius: 2, // Radius penyebaran bayangan
            blurRadius: 5, // Radius blur bayangan
            offset: Offset(0, 4), // Offset bayangan (x, y)
          ),
        ],
      ),
      height: 200,
      width: 500,
      child: Column(children: [
        Expanded(
          flex: 2, // Mengatur proporsi tinggi bagian atas
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/baner1.png'), // Ganti dengan path gambar Anda
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1, // Mengatur proporsi tinggi bagian atas
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Center(
                  child: const Text(
                    'SYARAT - SYARAT PENDAFTARAN ANGGOTA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Jadi anggota Perpustakaan Kota Medan untuk akses ke koleksi buku dan layanan! Cek syarat di gambar dan bergabunglah sekarang!',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 3, // Menentukan jumlah baris maksimum
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ]),
    ),
  ),
];
