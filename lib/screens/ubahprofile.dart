// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pemmob2/db/db.dart';
// import 'dart:io';

// class UbahProfile extends StatefulWidget {
//   final String name;
//   final String email;
//   final String username;
//   final String address;
//   final String phoneNumber;

//   const UbahProfile({
//     Key? key,
//     required this.name,
//     required this.email,
//     required this.username,
//     required this.address,
//     required this.phoneNumber,
//   }) : super(key: key);

//   @override
//   _UbahProfileState createState() => _UbahProfileState();
// }

// class _UbahProfileState extends State<UbahProfile> {
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _addressController;
//   late TextEditingController _phoneController;
//   File? _imageFile;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.name);
//     _emailController = TextEditingController(text: widget.email);
//     _addressController = TextEditingController(text: widget.address);
//     _phoneController = TextEditingController(text: widget.phoneNumber);
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _saveChanges() async {
//     await DatabaseHelper.instance.updateUserProfile(
//       widget.username,
//       _nameController.text,
//       _emailController.text,
//       _addressController.text,
//       _phoneController.text,
//       _imageFile?.path, // Simpan path foto jika ada
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Perubahan disimpan!")),
//     );

//     Navigator.pop(context, 'updated');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pengaturan Profil'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: _imageFile != null
//                     ? FileImage(_imageFile!)
//                     : const AssetImage('assets/default_avatar.jpeg')
//                         as ImageProvider,
//                 backgroundColor: Colors.grey[300],
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Nama',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _addressController,
//               decoration: const InputDecoration(
//                 labelText: 'Alamat',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'No. Telepon',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveChanges,
//               child: const Text('Simpan Perubahan'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
