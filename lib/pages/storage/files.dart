// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
//
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
//
// class Files extends StatefulWidget {
//   const Files({super.key});
//
//   @override
//   FilesState createState() => FilesState();
// }
//
// class FilesState extends State<Files> {
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFiles();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('File Management')),
//       body: RefreshIndicator(
//         onRefresh: _loadFiles,
//         child: ListView(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   _file != null
//                       ? Text('Selected File: ${_file!.path}')
//                       : Text('No File Selected'),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _pickFile,
//                     child: Text('Select File'),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _uploadFile,
//                     child: Text('Upload File'),
//                   ),
//                   SizedBox(height: 20),
//                   _uploadTask != null
//                       ? buildUploadStatus(_uploadTask!)
//                       : Container(),
//                 ],
//               ),
//             ),
//             Divider(),
//             ...files
//                 .map((file) => ListTile(
//                       title: Text(file['name']),
//                       onTap: () => _previewFile(file['url'], file['name']),
//                     ))
//                 .toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//         stream: task.snapshotEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!;
//             final progress = snap.bytesTransferred / snap.totalBytes;
//             final percentage = (progress * 100).toStringAsFixed(2);
//
//             return Text(
//               '$percentage %',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             );
//           } else {
//             return Container();
//           }
//         },
//       );
// }
//
