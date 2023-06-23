import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File? _image;
  final pdf = pw.Document();

  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        final image = pw.MemoryImage(_image!.readAsBytesSync());
        pdf.addPage(pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        )
        );
      } else {
        print('No image selected.');
      }
    });
  }

  Future savePdf() async {
    Directory? documentDirectory = await getExternalStorageDirectory();

    String documentPath = documentDirectory!.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image to PDF example'),
        ),
        body: Center(
          child: _image == null
              ? Text('No image selected.')
              : Image.file(_image!),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Pick Image',
              child: Icon(Icons.add_a_photo),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: savePdf,
              child: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}

 
