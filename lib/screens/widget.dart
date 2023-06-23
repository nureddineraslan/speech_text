import 'package:flutter/material.dart';

class MyAudioWidget extends StatefulWidget {
  MyAudioWidget({Key? key, required this.onTap,this.isTap=false}) : super(key: key);
VoidCallback? onTap;
  bool? isTap;
  @override
  State<MyAudioWidget> createState() => _MyAudioWidgetState();
}

class _MyAudioWidgetState extends State<MyAudioWidget> {


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: widget.onTap,

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 180, width: 180,
            child: Center(child: Icon(widget.isTap==false? Icons.play_arrow:Icons.stop,size: 180,)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              boxShadow: [],
              color: Colors.red


            )
            ,
        ),
      ),
    );
  }
}
