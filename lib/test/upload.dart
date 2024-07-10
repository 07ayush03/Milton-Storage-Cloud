import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  FileUploadScreenState createState() => FileUploadScreenState();
}

class FileUploadScreenState extends State<FileUploadScreen> {
  File? _file;
  UploadTask? _uploadTask;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_file == null) return;

    final fileName = _file!.path.split('/').last;
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      _uploadTask = ref.putFile(_file!);

      setState(() {});

      await _uploadTask!.whenComplete(() => {});
      final urlDownload = await ref.getDownloadURL();

      print('Download-Link: $urlDownload');
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload File')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _file != null
                ? Text('Selected File: ${_file!.path}')
                : Text('No File Selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Select File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
            SizedBox(height: 20),
            _uploadTask != null ? buildUploadStatus(_uploadTask!) : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}
