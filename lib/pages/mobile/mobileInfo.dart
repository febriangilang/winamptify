import 'package:flutter/material.dart';
import 'package:ticker_text/ticker_text.dart';

class MobileInfoWidget extends StatelessWidget {

  final String trackName;

  MobileInfoWidget(this.trackName);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.609,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
      child:TickerText(
        scrollDirection: Axis.horizontal,
        speed: 20,
        startPauseDuration: const Duration(seconds: 10),
        endPauseDuration: const Duration(seconds: 1),
        returnDuration: const Duration(milliseconds: 300),
        primaryCurve: Curves.linear,
        returnCurve: Curves.easeOut,
        child: Text(
          this.trackName,
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontFamily: 'Pixer', fontSize: 18, color: Color(0XFF04E406)),
        ),
      )
    );
  }
}
