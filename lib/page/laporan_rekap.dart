import 'package:epustakakotamedan_v2/components/appbar.dart';
import 'package:epustakakotamedan_v2/components/menubar.dart';
import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:epustakakotamedan_v2/controller/laporan-rekap-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LaporanRekap extends StatefulWidget {
  @override
  State<LaporanRekap> createState() => _LaporanRekapState();
}

class _LaporanRekapState extends State<LaporanRekap> {
  final LaporanRekapController controller = Get.find();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  Map<String, bool> _visibilityMap = {};
  bool _isFilterVisible = false; // State to control filter visibility

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetAndRefetch();
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? controller.startDate.value ?? DateTime.now()
          : controller.endDate.value ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (isStartDate) {
        _startDateController.text = formatDate(picked);
        controller.updateDateRange(picked, controller.endDate.value);
      } else {
        _endDateController.text = formatDate(picked);
        controller.updateDateRange(controller.startDate.value, picked);
      }
    }
  }

  Future<void> _confirmDelete(String id) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      controller.deleteBook(id);
    }
  }

  void _handleSearch() {
    controller.searchQuery.value = _searchController.text;
    controller.currentPage.value = 1; // Reset to the first page
    controller.resetAndRefetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BayuAppBar(title: 'Laporan Buku yang di Baca di Tempat'),
      body: Obx(() {
        if (controller.isLoading.value && controller.books.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            if (!_isFilterVisible)
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Container(
                  height: 96,
                  decoration: BoxDecoration(
                      color: blue1,
                      borderRadius: BorderRadiusDirectional.circular(15)),
                  child: MenuBarWidget(),
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFilterVisible =
                        !_isFilterVisible; // Toggle filter visibility
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: green1,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Filter',
                                style: bold16.copyWith(color: Colors.white)),
                            IconButton(
                              icon: Icon(
                                _isFilterVisible
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFilterVisible =
                                      !_isFilterVisible; // Toggle filter visibility
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Obx(() => Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10), // Mengatur padding
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey), // Border
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: controller.selectedValue.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Laporan buku'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '2',
                                    child: Text(
                                        'Laporan Pencatatan Manual Instansi'),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  controller.selectedValue.value = newValue;
                                  controller.resetAndRefetch();
                                },
                                isExpanded:
                                    true, // Makes the dropdown take up the full width
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            // Filter section wrapped in a Visibility widget
            Visibility(
              visible: _isFilterVisible,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40, // Set a fixed height to reduce size
                            child: TextField(
                              controller: _startDateController,
                              decoration: InputDecoration(
                                labelText: 'Tanggal Awal',
                                labelStyle: TextStyle(
                                    fontSize: 14), // Reduce label font size
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.clear,
                                          size: 18), // Reduce icon size
                                      onPressed: () {
                                        _startDateController.clear();
                                        controller.startDate.value = null;
                                        controller.resetAndRefetch();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.calendar_today,
                                          size: 18), // Reduce icon size
                                      onPressed: () =>
                                          _selectDate(context, true),
                                    ),
                                  ],
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 14), // Reduce input font size
                              readOnly: true,
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Adjust spacing
                        Expanded(
                          child: SizedBox(
                            height: 40, // Set a fixed height to reduce size
                            child: TextField(
                              controller: _endDateController,
                              decoration: InputDecoration(
                                labelText: 'Tanggal Akhir',
                                labelStyle: TextStyle(
                                    fontSize: 14), // Reduce label font size
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.clear,
                                          size: 18), // Reduce icon size
                                      onPressed: () {
                                        _endDateController.clear();
                                        controller.endDate.value = null;
                                        controller.resetAndRefetch();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.calendar_today,
                                          size: 18), // Reduce icon size
                                      onPressed: () =>
                                          _selectDate(context, false),
                                    ),
                                  ],
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 14), // Reduce input font size
                              readOnly: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: SizedBox(
                      height: 40, // Set a fixed height to reduce size
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Cari',
                          labelStyle:
                              TextStyle(fontSize: 14), // Reduce label font size
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search,
                                size: 18), // Reduce icon size
                            onPressed: _handleSearch,
                          ),
                        ),
                        style:
                            TextStyle(fontSize: 14), // Reduce input font size
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total Data: ${controller.totalData.value}'),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(5),
                itemCount: controller.books.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.books.length) {
                    return controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }

                  final book = controller.books[index];
                  return Column(
                    children: [
                      if (book['nama_instansi_full'] != null)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(book['nama_instansi_full'] ??
                                'Judul tidak ada'),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                                'Total Buku: ${book['total_books'] ?? '0'}'),
                          ),
                          onTap: () {
                            setState(() {
                              // Toggle visibilitas hanya untuk instansi ini
                              _visibilityMap[book['nama_instansi_full']] =
                                  !(_visibilityMap[
                                          book['nama_instansi_full']] ??
                                      false);
                            });
                          },
                        ),
                      Divider(
                          height: 1, thickness: 1, color: Colors.grey.shade300),
                      //
                      if (_visibilityMap[book['nama_instansi_full']] ?? false)
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: ListView.builder(
                            padding:
                                EdgeInsets.zero, // No padding for the ListView
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: book['books'] != null
                                ? book['books'].length
                                : 0,
                            itemBuilder: (context, bookIndex) {
                              // Accessing the book object which includes both title and author
                              final nestedBook = book['books'][bookIndex];
                              final nestedBookTitle =
                                  nestedBook['judul']; // Access title
                              final nestedBookAuthor =
                                  nestedBook['author']; // Access author

                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets
                                        .zero, // No padding for the ListTile
                                    title: Text(nestedBookTitle),
                                    subtitle: Text(
                                        nestedBookAuthor), // Display author as subtitle
                                  ),
                                  // Divider added after each ListTile
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                      //
                      if (book['nama_instansi_full'] == null)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(book['judul'] ?? 'Judul tidak ada'),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                                'Author: ${book['author'] ?? 'Author tidak ada'}'),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text('Total Buku: ${book['total'] ?? '0'}'),
                          ),
                        ),
                      Divider(
                          height: 1, thickness: 1, color: Colors.grey.shade300),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (controller.currentPage.value > 1) {
                      controller.fetchBooks(isNext: false);
                    }
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Obx(() => Text(
                    'Page ${controller.currentPage} / ${controller.totalPages}')),
                IconButton(
                  onPressed: () {
                    if (controller.hasMore.value) {
                      controller.fetchBooks(isNext: true);
                    }
                  },
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
