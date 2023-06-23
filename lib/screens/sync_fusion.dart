import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

 

/// Represents SyncFusion for Navigation
class SyncFusion extends StatefulWidget {
  @override
  _SyncFusion createState() => _SyncFusion();
}

class _SyncFusion extends State<SyncFusion> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }
  FilePickerResult? result;
  Future getPath()async{
   result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  }
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

              if(result != null) {
                  file = File(result.files.single.path!);

              } else {
                // User canceled the picker
              }
            },
            child: Text("Pick a PDF file"),
          ),
        ],
      ),
      body: SfPdfViewer.file(file!)
    );
  }
}