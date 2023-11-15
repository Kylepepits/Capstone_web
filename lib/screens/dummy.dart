// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class FirestoreImageDisplay extends StatefulWidget {
//   const FirestoreImageDisplay({super.key});

//   @override
//   State<FirestoreImageDisplay> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<FirestoreImageDisplay> {
//   late String imageUrl;
//   final storage = FirebaseStorage.instance;
//   @override
//   void initState() {
//     super.initState();
//     // Set the initial value of imageUrl to an empty string
//     imageUrl = '';
//     //Retrieve the imge grom Firebase Storage
//     getImageUrl();
//   }

//   Future<void> getImageUrl() async {
//     // Get the reference to the image file in Firebase Storage
//     final ref = storage.ref().child(
//         'images_piOJYoYMLuafMrTL4kqG50JurI33_CIT_ray-hennessy-mpw37yXc_WQ-unsplash.jpg');
//     // Get teh imageUrl to download URL
//     final url = await ref.getDownloadURL();
//     setState(() {
//       imageUrl = url;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Display image from fiebase "),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//               height: 300,
//               child: Image(
//                 image: NetworkImage(imageUrl),
//                 fit: BoxFit.cover,
//               )),
//         ],
//       ),
//     );
//   }
// }
