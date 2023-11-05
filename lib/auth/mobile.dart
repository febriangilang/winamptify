import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import '../pages/mobile/mobileHome.dart';
import 'package:logger/logger.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({Key? key}) : super(key: key);

  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  bool rememberMe = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/windows_potrait.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center),
          Positioned(
            top: 220,
            left: 40,
            right: 40,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.235,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF555569), width: 2.0),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  colors: [
                    Color(0xFF212132),
                    Color(0XFF353454),
                    Color(0xFF474766),
                  ],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Column(
                  children: [
                    Row(
                        children: [
                          Container(
                            color: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.22,
                                  color: Colors.yellow,
                                  height: 5,
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.034),
                                const Text(
                                  "WINAMPTIFY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Pixer',
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03428),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.22,
                                  color: Colors.yellow,
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ]
                    ),
                    Row(
                        children: [
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.77,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.1,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF555569), width: 2.0),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                colors: [
                                  Color(0xFF212132),
                                  Color(0XFF353454),
                                  Color(0xFF474766),
                                ],
                                tileMode: TileMode.repeated,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF555569), width: 2.0),
                                color: Colors.black,
                              ),
                              child: Transform.translate(
                                offset: Offset(0, -30),

                              ),
                            ),
                          ),
                        ]
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences pref =await SharedPreferences.getInstance();
                        pref.setString("status", "active");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                          return MobileHome();
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        padding: const EdgeInsets.all(8),
                      ),
                      child: SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.4,
                        child: Image.asset(
                            'assets/Spotify_Logo.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            top: 265,
            left: 50,
            right: 50,
            child: Text(
              'Stream millions of tracks with a classic retro twist, all for free on WinampTify!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF04E406),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

}