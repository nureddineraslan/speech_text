import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:path/path.dart' as path;
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerScreen extends StatefulWidget {

  String? source;
    AudioPlayerScreen({super.key, this.source});
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    getMusicFiles();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  List<Source> musicFiles = [];



  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }
  var files;
  var directory;
  String newFilesName="";
List<String> yeniListe=[];
List<Source> newMusic=[];
  Future<void> getMusicFiles() async {
    final directory = await getExternalStorageDirectory();
    final files = await directory!.list().toList();

    String directoryPath = '/storage/emulated/0/Android/data/com.example.speech_text/files/';
    String fileName = path.basename(directoryPath);

    Directory directorya = Directory(directoryPath);
    List<String> fileNames = directorya.listSync().map((file) {
      return path.basename(file.path);
    }).toList();

    yeniListe.clear(); // Yeni liste temizleniyor

    for (var eleman in fileNames) {
      yeniListe.add(eleman);
    }

    musicFiles.clear(); // Müzik dosyaları listesi temizleniyor

    for (var file in files) {
      if (file.path.endsWith('.mp3')) {
        musicFiles.add(DeviceFileSource('/storage/emulated/0/Android/data/com.example.speech_text/files/${widget.source}'));
      }
    }

    newMusic.clear(); // Yeni müzik listesi temizleniyor

    for (var file in fileNames) {
      newMusic.add(DeviceFileSource(file));
    }

    setState(() {});
  }
var filenameIndex;

  void deleteFile(String filePath) {
    File file = File(filePath);
    file.deleteSync();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Container(
          child: Text(tr("delete_succes")),

    )));
    getMusicFiles();
  }
  @override
  Widget build(BuildContext context) {
    return   SingleChildScrollView(
      child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(50),
                   image:const  DecorationImage(
                     image: AssetImage("assets/plak.png"),
                     fit: BoxFit.cover
                   )
                 ),
                 height: 95,width: 95,
                 ),
              slider(),
              controlButtons(),
              Container(
               height: 350,
                child: ListView.builder(
                  itemCount:  yeniListe.length,
                  itemBuilder: (context, index) {
                    String directoryPath = '/storage/emulated/0/Android/data/com.example.speech_text/files/';
                    Directory directorya = Directory(directoryPath);
                    List<String> fileNames = directorya.listSync().map((file) {
                      return path.basename(file.path);
                    }).toList();
                    filenameIndex=fileNames[index];

                    return ListTile(
                        title:   Text(yeniListe[index].toString()),
                        trailing: IconButton(
                            icon: Icon(Icons.clear), onPressed: () {
                         setState(() {
                           deleteFile("/storage/emulated/0/Android/data/com.example.speech_text/files/${fileNames[index]}");
                         });

                        }),
                        onTap: () {
                         print("Fİlenmase index : ${fileNames[index]}");
                          _audioPlayer.play(DeviceFileSource('/storage/emulated/0/Android/data/com.example.speech_text/files/${fileNames[index]}')  ,);

                        },
                      );


                  },
                ),
              ),
            ],
          ),
        ),
    );

  }

  Widget slider() {
    return Slider(
      value: _position.inSeconds.toDouble(),
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      },
    );
  }

  Widget controlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.play_circle_fill),
            onPressed: () {
              _audioPlayer.play(DeviceFileSource('/storage/emulated/0/Android/data/com.example.speech_text/files/${filenameIndex}'));
              setState(() {
                isPlaying = true;
              });
            }),
        IconButton(
            icon: Icon(Icons.pause_circle_filled),
            onPressed: () {
              _audioPlayer.pause();
              setState(() {
                isPlaying = false;
              });
            }),
        IconButton(
            icon: Icon(Icons.stop_circle),
            onPressed: () {
              _audioPlayer.stop();
              setState(() {
                isPlaying = false;
              });
            }),
      ],
    );
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }
}
