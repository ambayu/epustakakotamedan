import 'package:epustakakotamedan_v2/components/appbar.dart';
import 'package:epustakakotamedan_v2/components/menubar.dart';
import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:epustakakotamedan_v2/models/model.dart';
import 'package:flutter/material.dart' show SearchDelegate;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:epustakakotamedan_v2/controller/barcode-controller.dart';

class ScanInstansiPage extends StatelessWidget {
  final BarcodeController barcodeController = Get.put(BarcodeController());
  final MobileScannerController cameraController = MobileScannerController();
  final TextEditingController instansiController = TextEditingController();

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
            Column(
              children: [
                // Bagian pilihan instansi

// Widget utama
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: barcodeController.isInstansiLocked.value
                              ? Text(
                                  'Instansi: ${barcodeController.instansiName.value}',
                                  style: TextStyle(fontSize: 16),
                                )
                              : Obx(() => TextButton(
                                    onPressed: () async {
                                      final result = await showSearch(
                                        context: context,
                                        delegate: InstansiSearchDelegate(
                                            barcodeController.instansiList),
                                      );
                                      if (result != null) {
                                        barcodeController
                                            .selectedInstansi.value = result;
                                      }
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        barcodeController
                                                .selectedInstansi.value?.name ??
                                            'Pilih Instansi',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: barcodeController
                                                      .selectedInstansi.value ==
                                                  null
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (barcodeController.isInstansiLocked.value) {
                            barcodeController.isInstansiLocked.value = false;
                          } else {
                            barcodeController.lockInstansi();
                          }
                        },
                        child: Text(barcodeController.isInstansiLocked.value
                            ? 'Edit'
                            : 'Lock'),
                      ),
                    ],
                  ),
                ),

                // Display locked institution name

                // Scanner Barcode
                Expanded(
                  flex: 1,
                  child: barcodeController.isInstansiLocked.value
                      ? MobileScanner(
                          controller: cameraController,
                          onDetect: (barcodeCapture) {
                            final List<Barcode> barcodes =
                                barcodeCapture.barcodes;
                            for (final barcode in barcodes) {
                              if (barcode.rawValue != null) {
                                final String code = barcode.rawValue!;
                                barcodeController.handleBarcodeScan(code);
                              }
                            }
                          },
                        )
                      : Center(
                          child:
                              Text('Lock nama instansi untuk mulai memindai')),
                ),
              ],
            ),
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
                      // Panel judul
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
                                'Scan Pencatatan untuk Instansi',
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
                            borderRadius: BorderRadiusDirectional.circular(15),
                          ),
                          child: MenuBarWidget(),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
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
                                    contentPadding: EdgeInsets.zero,
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
                                                .SaveToLaporanMasukInstansi(
                                              result['ID'].toString(),
                                              result['Title'].toString(),
                                              result['Author'].toString(),
                                              barcodeController
                                                  .isInstansiLocked.value
                                                  .toString(),
                                              index,
                                            );
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
                                    tileColor: Colors.white,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.grey.shade300,
                                  ),
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

// Tambahkan class SearchDelegate di file yang sama
class InstansiSearchDelegate extends SearchDelegate<Instansi?> {
  final RxList<Instansi> instansiList;

  InstansiSearchDelegate(this.instansiList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredList = instansiList.where((instansi) {
      return instansi.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final instansi = filteredList[index];
        return ListTile(
          title: Text(instansi.name),
          onTap: () {
            close(context, instansi);
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
