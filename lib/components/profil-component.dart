import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epustakakotamedan_v2/components/menubar.dart';
import 'package:epustakakotamedan_v2/components/themes.dart';
import 'package:epustakakotamedan_v2/controller/login-controller.dart';
import 'package:epustakakotamedan_v2/controller/permission-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilComponent extends StatelessWidget {
  const ProfilComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();

    // Fetch user profile when widget is built
    loginController.fetchUserProfile();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
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
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            if (loginController.userProfile.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            final user = loginController.userProfile;
            final fotoUrl = user['fotoUrl'] ??
                'https://picsum.photos/id/237/200/300'; // Default image URL
            // URL gambar default jika tidak ada
            // print(fotoUrl);
            return Column(
              children: [
                CachedNetworkImage(
                  imageUrl: fotoUrl,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 70,
                    backgroundImage: imageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                itemProfile(
                    'Name', user['name'] ?? 'N/A', CupertinoIcons.person),
                const SizedBox(height: 10),
                itemProfile('NIP', user['nip'] ?? 'N/A', CupertinoIcons.number),
                const SizedBox(height: 10),
                itemProfile(
                    'Bidang', user['bidang'] ?? 'N/A', CupertinoIcons.location),
                const SizedBox(height: 10),
                itemProfile(
                    'Email', user['email'] ?? 'N/A', CupertinoIcons.mail),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showEditProfileDialog(context, loginController);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.green.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}

void _showEditProfileDialog(
    BuildContext context, LoginController loginController) {
  final _nameController =
      TextEditingController(text: loginController.userProfile['name']);
  final _nipController =
      TextEditingController(text: loginController.userProfile['nip']);
  final _bidangController =
      TextEditingController(text: loginController.userProfile['bidang']);
  final _emailController =
      TextEditingController(text: loginController.userProfile['email']);

  File? _selectedImage; // Store selected image file
  final ImagePicker _picker = ImagePicker();
  final PermissionController _permissionController = PermissionController();

  Future<void> _pickImage() async {
    var status = await _permissionController.checkStoragePermission();

    if (!status) {
      status = await _permissionController.requestStoragePermission();
    }

    if (status) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        loginController.selectedImage.value = File(image.path);
      }
    } else {
      Get.snackbar('Permission Denied',
          'Storage permission is required to pick an image.');
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Profile'),
        content: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    await _pickImage(); // Pick image when tapped
                    // Update UI after image selection
                  },
                  child: Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundImage: loginController.selectedImage.value !=
                                null
                            ? FileImage(loginController.selectedImage.value!)
                            : CachedNetworkImageProvider(
                                loginController.userProfile['fotoUrl'] ??
                                    'https://picsum.photos/id/237/200/300'),
                        // Display current profile picture
                        child: const Icon(Icons.edit, color: Colors.white),
                      )),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _nipController,
                  decoration: const InputDecoration(labelText: 'NIP'),
                ),
                TextField(
                  controller: _bidangController,
                  decoration: const InputDecoration(labelText: 'Bidang'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_nameController.text.isEmpty ||
                  _nipController.text.isEmpty ||
                  _emailController.text.isEmpty) {
                Get.snackbar('Error', 'All fields must be filled!');
                return;
              }

              // Update the profile with the selected image
              await loginController.updateProfileWithImage(
                name: _nameController.text,
                nip: _nipController.text,
                bidang: _bidangController.text,
                email: _emailController.text,
                image: loginController.selectedImage.value,
                // Use selected image
              );

              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
