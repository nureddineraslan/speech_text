import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:speech_text/providers/my_provider.dart';
import 'package:speech_text/screens/get_file_screen.dart';
import 'package:speech_text/screens/pdf_convert.dart';
import 'package:speech_text/screens/pdf_view.dart';
import 'package:speech_text/screens/scanner_documet.dart';
import 'package:speech_text/screens/sync_fusion.dart';

void main() async {
  const SystemUiOverlayStyle(statusBarColor: Colors.white);
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
        Locale('fr'),
        Locale('de', 'DE'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: ChangeNotifierProvider<MyProvider>(
        create: (context) => MyProvider(), // Provider'ı oluşturun
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Material App',
      home: Scaffold(
        body: Consumer<MyProvider>( // Provider'ı tüketin
          builder: (context, provider, child) {
            return PDFConverter();
          },
        ),
      ),
    );
  }
}