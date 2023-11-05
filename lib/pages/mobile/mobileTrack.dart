import 'package:flutter/material.dart';

class MobileTrackWidget extends StatelessWidget {
  final String minutes;
  final String seconds;
  final bool playing;

  MobileTrackWidget({required this.minutes, required this.seconds, required this.playing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.36,
      height: MediaQuery.of(context).size.width * 0.28,
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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MusicTimer(
                  minutes: this.minutes,
                  seconds: this.seconds,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.34,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: playing
                          ? AssetImage("assets/music_meter.gif")
                          : AssetImage('assets/music_meter.png'),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MusicTimer extends StatelessWidget {
  final String minutes;
  final String seconds;

  MusicTimer({required this.minutes, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "▶- ",
            style: TextStyle(
                fontFamily: 'Pixer', fontSize: 28, color: Color(0XFF04E406)),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Text(
            "${this.minutes}:${this.seconds}",
            style: const TextStyle(
                fontFamily: 'Pixer', fontSize: 34, color: Color(0XFF04E406)),
          ),
        ],
      ),
    );
  }
}
