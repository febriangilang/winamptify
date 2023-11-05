import 'package:flutter/material.dart';

class MobileMiniInfoWidget extends StatelessWidget {

  final String trackName;

  MobileMiniInfoWidget(this.trackName);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.1,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: const BoxDecoration(
        color: Color(0xFF040405),
        border: Border(
          right: BorderSide(width: 2, color: Color(0xFF555569)),
          bottom: BorderSide(width: 2, color: Color(0xFF555569)),
        ),
        image: DecorationImage(
            image: AssetImage('assets/gridtexture.png'),
            fit: BoxFit.fill,
            repeat: ImageRepeat.repeat),
      ),
      child: Text(
        this.trackName,
        textAlign: TextAlign.right,
        style: const TextStyle(
            fontFamily: 'Pixer', fontSize: 16, color: Color(0XFF04E406)),
      ),
    );
  }
}
