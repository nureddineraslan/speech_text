import 'dart:io';

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:speech_text/screens/pdf_view.dart';

class DocumentScannerPage extends StatefulWidget {
  @override
  _DocumentScannerPageState createState() => _DocumentScannerPageState();
}

class _DocumentScannerPageState extends State<DocumentScannerPage> {
  String? scannedDocumentPath;

  void startDocumentScanning() async {
    final String? result = (await DocumentScannerFlutter.launch(context,source: ScannerFileSource.CAMERA)) as String?;
    setState(() {
      scannedDocumentPath = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: startDocumentScanning,
            child: Text('Start Scanning'),
          ),
          if (scannedDocumentPath != null)
            Expanded(
              child: Image.file(
                File(scannedDocumentPath!),
                fit: BoxFit.cover,
              ),
            ),
          ElevatedButton(
              child: Text("RaisedButton"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewScreen()));


              }),
        ],
      ),
    );
  }
}
