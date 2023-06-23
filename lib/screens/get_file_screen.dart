import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

Future<void> convertTextToSpeech(String text) async {
  final FlutterTts flutterTts = FlutterTts();
  final Directory directorya = await getApplicationDocumentsDirectory();
  final String filePath = '${directorya.path}/speech.mp3';

  await flutterTts.setLanguage('en-US');
  await flutterTts.setSpeechRate(1.0);
  await flutterTts.setPitch(1.0);

  await flutterTts.synthesizeToFile(text, filePath);
}
