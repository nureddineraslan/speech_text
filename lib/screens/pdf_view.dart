import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(MaterialApp(
    home: PdfViewScreen(),
  ));
}

class PdfViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Picker"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

            if(result != null) {
              File file = File(result.files.single.path!);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFScreen(file.path)),
              );
            } else {
              // User canceled the picker
            }
          },
          child: Text("Pick a PDF file"),
        ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen(this.path);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF'),
      ),
      body: PDFView(
        filePath: widget.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
    );
  }
}
