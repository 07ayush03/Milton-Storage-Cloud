import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileManagementScreen extends StatefulWidget {
  const FileManagementScreen({super.key});

  @override
  FileManagementScreenState createState() => FileManagementScreenState();
}

class FileManagementScreenState extends State<FileManagementScreen> {
  File? _file;
  UploadTask? _uploadTask;
  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

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
      await _loadFiles();  // Refresh the file list after upload
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _loadFiles() async {
    final ref = FirebaseStorage.instance.ref().child('files');
    final ListResult result = await ref.listAll();

    final urls = await Future.wait(result.items.map((ref) => ref.getDownloadURL()).toList());
    final names = result.items.map((ref) => ref.name).toList();

    setState(() {
      files = List.generate(names.length, (index) => {'name': names[index], 'url': urls[index]});
    });
  }

  void _previewFile(String url, String name) async {
    final file = await _downloadFile(url, name);
    if (file != null) {
      if (name.endsWith('.pdf')) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PDFViewerScreen(file: file)),
        );
      } else {
        OpenFile.open(file.path);
      }
    }
  }

  Future<File?> _downloadFile(String url, String name) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final bytes = await consolidateHttpClientResponseBytes(await response.close());
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Management')),
      body: RefreshIndicator(
        onRefresh: _loadFiles,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
            Divider(),
            ...files.map((file) => ListTile(
              title: Text(file['name']),
              onTap: () => _previewFile(file['url'], file['name']),
            )).toList(),
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

class PDFViewerScreen extends StatelessWidget {
  final File file;

  PDFViewerScreen({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
