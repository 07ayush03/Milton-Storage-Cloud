import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Document extends StatefulWidget {
  const Document({super.key});

  @override
  State<Document> createState() => DocumentState();
}

class DocumentState extends State<Document> {
  bool isLoading = true;
  File? file;
  UploadTask? uploadTask;
  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    loadFiles().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path!.endsWith('pdf')) {
      setState(() {
        file = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadFile() async {
    if (file == null) return;

    final fileName = file!.path.split('/').last;
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      uploadTask = ref.putFile(file!);

      setState(() {});

      await uploadTask!.whenComplete(() => {});
      await loadFiles(); // Refresh the file list after upload
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> loadFiles() async {
    final ref = FirebaseStorage.instance.ref().child('files');
    final ListResult result = await ref.listAll();

    final urls = await Future.wait(
        result.items.map((ref) => ref.getDownloadURL()).toList());
    final names = result.items.map((ref) => ref.name).toList();

    setState(() {
      files = List.generate(
          names.length, (index) => {'name': names[index], 'url': urls[index]});
    });
  }

  void previewFile(String url, String name) async {
    final file = await downloadFile(url, name);
    if (file != null) {
      if (name.endsWith('.pdf')) {
        Future.delayed(Duration.zero).whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PDFViewerScreen(file: file)),
          );
        });
      } else {
        OpenFile.open(file.path);
      }
    }
  }

  Future<File?> downloadFile(String url, String name) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final bytes =
          await consolidateHttpClientResponseBytes(await response.close());
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  Future<void> delete(String name) async {
    final ref = FirebaseStorage.instance.ref().child('files').child(name);
    await ref.delete().whenComplete(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Done')));
    });
    await loadFiles(); // Refresh the file list after deletion
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        "Upload Documents only",
                        style: TextStyle(
                          color: Colors.green[900],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                RefreshIndicator(
                  onRefresh: loadFiles,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            file != null
                                ? Text('Selected File: ${file!.path}')
                                : const Text('No File Selected'),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: pickFile,
                              child: const Text('Select File'),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: uploadFile,
                              child: const Text('Upload File'),
                            ),
                            const SizedBox(height: 20),
                            uploadTask != null
                                ? buildUploadStatus(uploadTask!)
                                : Container(),
                          ],
                        ),
                      ),
                      const Divider(),
                      ...files.map((file) => ListTile(
                          title: Text(file['name']),
                          onTap: () => previewFile(file['url'], file['name']),
                          onLongPress: () => delete(file['name']))),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final File file;

  const PDFViewerScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
