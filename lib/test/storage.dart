import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FilePreviewScreen extends StatefulWidget {
  const FilePreviewScreen({super.key});

  @override
  _FilePreviewScreenState createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Preview')),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(files[index]['name']),
            onTap: () {
              _previewFile(files[index]['url']);
            },
          );
        },
      ),
    );
  }

  void _previewFile(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FileViewer(url: url)),
    );
  }
}

class FileViewer extends StatelessWidget {
  final String url;

  FileViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Viewer')),
      body: Center(
        child: Image.network(url),
      ),
    );
  }
}
