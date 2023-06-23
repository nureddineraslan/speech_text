import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_text/screens/audio_player.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:speech_text/services/admob_services.dart';

import '../providers/my_provider.dart';

class PDFConverter extends StatefulWidget {
  @override
  _PDFConverterState createState() => _PDFConverterState();
}

class _PDFConverterState extends State<PDFConverter> {
  final TextEditingController _text = TextEditingController();
  TextEditingController _dosyaAdiController = TextEditingController();
  bool isLoading = true;
  List<String> imagePaths = [];

  Future<void> _pickImages() async {
    final List<XFile>? images = await ImagePicker().pickMultiImage();
    if (images != null) {
      setState(() {
        imagePaths = images.map((image) => image.path).toList();
      });
    }
  }

  late final Directory? directory;

  FlutterTts flutterTts = FlutterTts();

  bool? isYuklendi;
  bool isTap = false;
  bool isFinished = false;

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> resume() async {
    await flutterTts.pause();
  }

  final AdmobService admobService = AdmobService();
  SharedPreferences? _prefs;
  String filePath = "";
  Source? auidoFile;

  Future<void> onylSpeak() async {
    print("onyl Speak");
    setState(() {
      isYuklendi = false;
    });
    Locale? currentLocale = context.locale;

    String languageCode = currentLocale.languageCode ??
        ''; // Kullanıcının seçtiği dil kodunu alır

// Seslendirme dilini kullanıcının seçtiği dile göre ayarlar

    final Directory? directory = await getExternalStorageDirectory();
    final text = _text.text;
    final words = text.split(' ');
    String firstWord;
    if (words.isNotEmpty) {
      firstWord = words[0];
    } else {
      firstWord = '';
    }
    filePath = '${firstWord}.mp3';

    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1);
    await flutterTts.setLanguage(languageCode);
    print(languageCode);
    await flutterTts.speak(_text.text);

    setState(() {
      isYuklendi = true; // 'speak' bittiğinde 'isYuklendi' false olacak
    });
  }

  Future<void> stopTTS() async {
    await flutterTts.stop();
  }

  Future<void> speak() async {
    Locale? currentLocale = context.locale;

    String languageCode = currentLocale.languageCode ?? '';
    print("Burası çalıştı");
    setState(() {
      isYuklendi = false;
    });

    final text = _text.text;
    final words = text.split(' ');
    String firstWord;
    if (words.isNotEmpty) {
      firstWord = words[0];
    } else {
      firstWord = '';
    }
    print(" İlk kelime$firstWord");
    filePath = '${firstWord}.mp3';
    await flutterTts.setVolume(0);
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setSpeechRate(0.5);

    await flutterTts.synthesizeToFile(_text.text, filePath);

    await flutterTts.setPitch(1);
    final Directory? directory = await getExternalStorageDirectory();
    // await flutterTts.speak(_text.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(child: Text(directory.toString())),
      ),
    );
    setState(() {
      isYuklendi = true; // 'speak' bittiğinde 'isYuklendi' false olacak
    });

    print('Speech file is saved at: $filePath');
  }


  NativeAd? knativeAd;
   NativeAd? nativeAd=NativeAd(
       adUnitId: 'ca-app-pub-3940256099942544/2247696110',
       listener: NativeAdListener(
         onAdLoaded: (ad) {
           debugPrint('$NativeAd loaded.');

         },
         onAdFailedToLoad: (ad, error) {
           // Dispose the ad here to free resources.
           debugPrint('$NativeAd failed to load: $error');
           ad.dispose();
         },
       ),
       request: const AdRequest(),
       // Styling
       nativeTemplateStyle: NativeTemplateStyle(
         // Required: Choose a template.
           templateType: TemplateType.medium,
           // Optional: Customize the ad's style.
           mainBackgroundColor: Colors.purple,
           cornerRadius: 10.0,
           callToActionTextStyle: NativeTemplateTextStyle(
               textColor: Colors.cyan,
               backgroundColor: Colors.red,
               style: NativeTemplateFontStyle.monospace,
               size: 16.0),
           primaryTextStyle: NativeTemplateTextStyle(
               textColor: Colors.red,
               backgroundColor: Colors.cyan,
               style: NativeTemplateFontStyle.italic,
               size: 16.0),
           secondaryTextStyle: NativeTemplateTextStyle(
               textColor: Colors.green,
               backgroundColor: Colors.black,
               style: NativeTemplateFontStyle.bold,
               size: 16.0),
           tertiaryTextStyle: NativeTemplateTextStyle(
               textColor: Colors.brown,
               backgroundColor: Colors.amber,
               style: NativeTemplateFontStyle.normal,
               size: 16.0)))..load();
  bool nativeAdIsLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  /// Loads a native ad.
  void loadAd() {
     knativeAd = NativeAd(
        adUnitId: _adUnitId,

        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
          mainBackgroundColor: Colors.white,

            cornerRadius: 10.0,


        )
     )
      ..load();
  }



  Uint8List? scannedDocument;
  Future? sure;
  bool showFile = true;

  @override
  void initState() {
    super.initState();
    admobService.loadRewardedAd();
    loadAd();

  }


  @override
  Widget build(BuildContext context) {
    var point = Provider.of<MyProvider>(context).puan;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("text_to_speech"),
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              admobService.showRewardedAd(context);
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/coin.png"),
                      )),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 15,
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(" $point",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(blurRadius: 1)],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: 3,
                          maxLength: 5000,
                          decoration: InputDecoration(
                            hintText: tr('enter_text'),
                            border: InputBorder.none,
                          ),
                          controller: _text,
                        ),
                      ),
                    ),

                    Container(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          TextButton(
                            child: Text(tr('save')),
                            onPressed: () async {
                             if(point==0){
                               showDialog<void>(
                                 context: context,
                                 builder: (BuildContext dialogContext) {
                                   return AlertDialog(
                                     title: Text('Bakiye Sıfır'),
                                     content: Text('Cüzdan Sıfır.Devam Edebilmek için Bakiye Yükleyin.\n (Bakiyenizi Reklam İzleyerek Arttırabilirsiniz) '),
                                     actions: <Widget>[
                                       TextButton(onPressed: (){
                                         Navigator.pop(context);
                                       }, child: Text("Tamam"),),
                                       TextButton(
                                           onPressed: () {
                                             admobService.showRewardedAd(context);
                                           },
                                           child: Text("Bakiye Arttır")),
                                     ],
                                   );
                                 },
                               );
                             }
                             else{
                               if (_text.text.isEmpty) {
                                 ScaffoldMessenger.of(context)
                                     .showSnackBar(SnackBar(
                                   content: Container(
                                     child: Text(tr("enter_text_error")),
                                   ),
                                   backgroundColor: Colors.red,
                                 ));
                               } else {
                                 speak();
                                 setState(() {
                                   isLoading = true;
                                 });
                               }
                             }
                            },
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextButton(
                              child: Text(
                                tr('play'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {

                                if(point==0){
                                  showDialog<void>(
                                    context: context,


                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('Bakiye Sıfır'),
                                        content: Text('Cüzdan Sıfır.Devam Edebilmek için Bakiye Yükleyin.\n (Bakiyenizi Reklam İzleyerek Arttırabilirsiniz) '),
                                        actions: <Widget>[
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text("Tamam"),)
                                        ],
                                      );
                                    },
                                  );
                                }
                                else{
                                  if (_text.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Container(
                                        child: Text(tr("enter_text_error")),
                                      ),
                                      backgroundColor: Colors.red,
                                    )

                                    );
                                  } else {
                                    onylSpeak();
                                    setState(() {
                                      isLoading = true;
                                      showFile=false;
                                    });
                                    Provider.of<MyProvider>(context,listen: false).decrementPuan();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                alignment: Alignment.center,
                child: AdWidget(ad: knativeAd!,),
                width: double.infinity,
                height: 375,
              ),
              isYuklendi == false
                  ? CircularProgressIndicator()
                  : (isLoading == false
                      ? SizedBox()
                      : AudioPlayerScreen(
                          source: filePath,
                        )
                  /*MyAudioWidget(
                          onTap: () {
                            setState(() {
                              isTap = !isTap;
                            });
                            if (isTap == false) {
                              onylSpeak();
                            }
                            if (isTap != false) {
                              resume();
                            }
                          },
                          isTap: isTap,
                        )*/

                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 85,
        color: Colors.black
        child:Container(

          child: AdWidget(
            ad: admobService.createBannerAd()..load(),
          ),
        ),
      ),
    );
  }

  void onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (exception) {
      // Handle exception here
    }
  }

  List<String> _pictures = [];
}
