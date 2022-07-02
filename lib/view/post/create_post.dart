// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CreatePost extends StatefulWidget {
//   CreatePost({Key? key}) : super(key: key);

//   @override
//   State<CreatePost> createState() => _CreatePostState();
// }

// class _CreatePostState extends State<CreatePost> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(  
//       appBar: AppBar(title: Text('Upload Image')),
//       body: Column(  
//         children: <Widget>[
//           ElevatedButton(  
//             child: Text('Upload Image'),
//             onPressed: () => uploadImage(),
//           )
//         ],
//       ),
//     );
//   }

//   uploadImage() async {
//     final _storage = FirebaseStorage.instance;
//     final _picker = ImagePicker();
//     List<XFile>? images;

//     //Check Permissions
//     await Permission.photos.request();

//     var permissionStatus = await Permission.photos.status;

//     if (permissionStatus.isGranted) {
//       //Select Image
//       images = await _picker.pickMultiImage();

//       if (images != null) {
//         //Upload to Firebase
//         images.forEach((element) async {
//           var file = File(element.path);
//           var snapshot =
//               await _storage.ref().child('folderName/imageName').putFile(file);
//           var downloadUrl = await snapshot.ref.getDownloadURL();
//         });

//       } else {
//         print('No Path Received');
//       }
//     } else {
//       print('Grant Permissions and try again');
//     }
//   }
// }
