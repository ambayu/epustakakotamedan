import 'package:epustakakotamedan_v2/components/appbar.dart';
import 'package:epustakakotamedan_v2/components/menubar.dart';
import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:epustakakotamedan_v2/controller/barcode-controller.dart';

class ScanPage extends StatelessWidget {
  final BarcodeController barcodeController = Get.put(BarcodeController());
  final MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BayuAppBar(
        title: 'Barcode Scanner',
      ),
      body: Obx(() {
        if (barcodeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            // Bagian kamera di setengah layar atas
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (barcodeCapture) {
                      final List<Barcode> barcodes = barcodeCapture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          final String code = barcode.rawValue!;
                          barcodeController
                              .handleBarcodeScan(code); // Handle barcode scan
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            // Panel yang bisa digeser ke atas dan ke bawah
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.5,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title for the draggable sheet
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: green2,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        height: 50,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 3.0),
                              width: 40,
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: const Color.fromARGB(255, 211, 209, 209),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 3.0, bottom: 5),
                              width: 40,
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: const Color.fromARGB(255, 211, 209, 209),
                              ),
                            ),
                            Center(
                              child: Text(
                                ' Scan untuk Baca ditempat',
                                style: bold18.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Container(
                          height: 96,
                          decoration: BoxDecoration(
                              color: blue1,
                              borderRadius:
                                  BorderRadiusDirectional.circular(15)),
                          child: MenuBarWidget(),
                        ),
                      ),

                      Expanded(
                        child: Obx(() {
                          // Use Obx to observe changes in scanResults
                          return ListView.builder(
                            padding: EdgeInsets.all(5),
                            controller: scrollController,
                            itemCount: barcodeController.scanResults.length,
                            itemBuilder: (context, index) {
                              final result =
                                  barcodeController.scanResults[index];
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.zero, // Remove padding
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text('Title: ${result['Title']}'),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                          Text('Author: ${result['Author']}'),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.save,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            barcodeController
                                                .SaveToLaporanMasuk(
                                                    result['ID'].toString(),
                                                    result['Title'].toString(),
                                                    result['Author'].toString(),
                                                    index);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            barcodeController
                                                .removeScanResult(index);
                                          },
                                        ),
                                      ],
                                    ),
                                    // Make ListTile wider
                                    tileColor: Colors.white,
                                    visualDensity:
                                        VisualDensity.compact, // Reduce padding
                                  ),
                                  Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey.shade300),
                                ],
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
