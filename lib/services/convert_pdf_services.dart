import 'package:path_provider/path_provider.dart';

class ConvertPdf{

 /* Future<void> _convertToPDF() async {
    final pdf = pw.Document();

    for (final imagePath in imagePaths) {
      final image = pw.MemoryImage(File(imagePath).readAsBytesSync());

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Image(image);
          },
        ),
      );
    }

    directory = await getExternalStorageDirectory();
    final String pdfPath = '${directory!.path}/converted.pdf';
    final File file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());
    print("Directory $directory");
  }*/
}