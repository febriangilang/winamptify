import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import '../../auth/login.dart';
import '../../widgets/icon_button.dart';
import 'retroButton.dart';
import 'mobileInfo.dart';
import 'mobileMiniInfo.dart';
import 'mobileTime.dart';
import 'mobileTrack.dart';
import 'textControlButton.dart';

bool mono = false;
double seekTime = 0;
String currentTrack = "No Track Selected";
String trackMin = "00";
String trackSec = "00";

int trackMinint = 0;
int trackSecint = 0;

bool paused = true;
bool initial = true;

class MobileHome extends StatefulWidget {
  const MobileHome({Key? key}) : super(key: key);

  @override
  MobileHomeState createState() => MobileHomeState();
}

class MobileHomeState extends State<MobileHome> {
  bool _loading = false;
  bool _connected = false;
  bool _play = false;
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


  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 3, seconds: 23);

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void initState() {
    setState(() {
      mono = false;
      seekTime = 0;
      currentTrack = "No Track Selected";
      trackMin = "00";
      trackSec = "00";
      trackMinint = 0;
      trackSecint = 0;
      connectToSpotifyRemote();
    });
    super.initState();
  }

  void playStart() {
    setState(() {
      _play = true;
    });
  }

  void playStop() {
    setState(() {
      _play = false;
    });
  }

  CrossfadeState? crossfadeState;
  late ImageUri? currentTrackImageUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
            body: _winampTheme(context),
          );
        },
      ),
    );
  }

  Widget _winampTheme (BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            const SizedBox(height: 35),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 36,
                  decoration: const BoxDecoration(
                      color: Colors.black87,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/winamps.png',
                        ),
                        fit: BoxFit.fitHeight,
                      )),
                ),
                Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2028,
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
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03428),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2028,
                        color: Colors.yellow,
                        height: 5,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      pref.remove("status");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                      return Login();}
                      )
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 36,
                    decoration: const BoxDecoration(
                        color: Colors.black87,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/xlose.png',
                          ),
                          fit: BoxFit.fitHeight,
                        )),
                  ),
                )
              ]
          ),
          Row(
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 1,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.25,
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
                      _connected
                          ? _buildPlayerStateWidget()
                          : const Center(
                        child: Text('Not connected'),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ),
          Row(
              children: [
                Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1933,
                        color: Colors.yellow,
                        height: 5,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.034),
                      const Text(
                        "WINAMPTIFY PLAYLIST",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Pixer',
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03428),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1933,
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
                      .width * 1,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.62,
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
                      child: SongList(),
                    ),
                    ),
                  ),
              ]
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;
        currentTrackImageUri = track?.imageUri;
        var playerState = snapshot.data;

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
      }
        String strDigits(int n) => n.toString().padLeft(2, '0');
        final minutes = strDigits(myDuration.inMinutes.remainder(60));
        final seconds = strDigits(myDuration.inSeconds.remainder(60));

        return Column(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MobileTrackWidget(minutes: minutes, seconds: seconds, playing: _play,),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MobileInfoWidget('${track.name} by ${track.artist.name} from the album ${track.album.name}'),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MobileMiniInfoWidget("256"),
                              const Text("Kbps",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Pixer',
                                  fontSize: 14,
                                ),),
                              const SizedBox(width: 4),
                              MobileMiniInfoWidget("44"),
                              const Text("Khz",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Pixer',
                                  fontSize: 14,
                                ),),
                              const SizedBox(width: 4),
                              const Text("mono",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Pixer',
                                  fontSize: 14,
                                ),),
                              const SizedBox(width: 4),
                              const Text("stereo",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontFamily: 'Pixer',
                                  fontSize: 14,
                                ),),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MobileTimeBar(min: 0, max: 10, value: 8, length: 100),
                                MobileTimeBar(min: 0, max: 10, value: 7, length: 100),
                              ]
                          )
                        ],
                      ),
                    ],
                  ),
                  MobileTimeBar(min: 0, max: 10, value: 2, length: MediaQuery.of(context).size.width * 0.97),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      RetroButton(
                          width: 30,
                          height: 25,
                          onPress: skipPrevious,
                          icon: Icons.fast_rewind
                      ),

                      RetroButton(
                          width: 30,
                          height: 25,
                          onPress: resume,
                          icon: Icons.play_arrow
                      ),
                      RetroButton(
                          width: 30,
                          height: 25,
                          onPress: pause,
                          icon: Icons.pause
                      ),
                      RetroButton(
                          width: 30,
                          height: 25,
                          onPress: playStop,
                          icon: Icons.stop
                      ),
                      RetroButton(
                          width: 30,
                          height: 25,
                          onPress: skipNext,
                          icon: Icons.fast_forward
                      ),
                      const SizedBox(width: 15),
                      RetroButton(
                          width: 30,
                          height: 25,
                          onPress: startTimer,
                          icon: Icons.eject
                      ),
                      const SizedBox(width: 15),
                      Transform.scale(
                        scale: 1,
                        child: TextControlButton(
                          text: "Shuffle", light: Colors.red, width: 65, ico: Icons.shuffle,),
                      ),
                      RetroButton(
                          width: 30,
                          height: 25,
                          onPress: () => null,
                          icon: Icons.repeat
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: 25,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/winamps.png',
                              ),
                              fit: BoxFit.fitHeight,
                            )),
                      ),
                    ],
                  )
                ]
            ),
          ],
        );
      },
    );
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString());
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
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

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future getPlayerLibrary() async {
    try {
      return await SpotifySdk.getLibraryState(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setPlaybackSpeed(
      PodcastPlaybackSpeed podcastPlaybackSpeed) async {
    try {
      await SpotifySdk.setPodcastPlaybackSpeed(
          podcastPlaybackSpeed: podcastPlaybackSpeed);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    playStop();
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    playStart();
    startTimer();
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    playStart();
    startTimer();
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> switchToLocalDevice() async {
    try {
      await SpotifySdk.switchToLocalDevice();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> checkIfAppIsActive(BuildContext context) async {
    try {
      await SpotifySdk.isSpotifyAppActive.then((isActive) {
        final snackBar = SnackBar(
            content: Text(isActive
                ? 'Spotify app connection is active (currently playing)'
                : 'Spotify app connection is not active (currently not playing)'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

}

class MobileNav extends StatelessWidget {
  const MobileNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            color: Colors.yellow,
            height: 5,
          ),
          SizedBox(width: 5),
          Text(
            "WINAMP",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Pixer',
              fontSize: 18,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            color: Colors.yellow,
            height: 5,
          ),
        ],
      ),
    );
  }
}

class WinLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        // color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'assets/logo.png',
            ),
            fit: BoxFit.cover,
          )),
    );
  }
}

class CloseLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        // color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'assets/winamp_logo.png',
            ),
            fit: BoxFit.cover,
          )),
    );
  }
}


class SongList extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'title': '1. Go the Distance - Hercules', 'times': '3:12'},
    {'title': '2. Circle of Life - The Lion King', 'times': '2:55'},
    {'title': '3. When You Wish Upon a Star - Pinocchio', 'times': '3:23'},
    {'title': '4. A Whole New World - Aladdin', 'times': '3:18'},
    {'title': '5. Can You Feel the Love Tonight - The Lion King', 'times': '3:04'},
    {'title': '6. Colours of the Wind - Pocahontas', 'times': '3:10'},
    {'title': '7. You have Got a Friend in Me - Toy Story', 'times': '2:49'},
    {'title': '8. You Will Be In My Heart - Tarzan', 'times': '3:56'},
    {'title': '9. I Wanna Be Like You - The Jungle Book', 'times': '3:21'},
    {'title': '10. Let It Go - Frozen', 'times': '3:44'},
    {'title': '11. Part of Your World - The Little Mermaid', 'times': '2:59'},
    {'title': '12. Be Our Guest - Beauty and the Beast', 'times': '3:17'},
    {'title': '13. A Dream is a Wish Your Heart Makes - Cinderella', 'times': '4:02'},
    {'title': '14. Reflection - Mulan', 'times': '3:30'},
    {'title': '15. Remember Me - Coco', 'times': '3:27'},
    {'title': '16. Hakuna Matata - The Lion King', 'times': '3:41'},
    {'title': '17. Under the Sea - The Little Mermaid', 'times': '3:11'},
    {'title': '18. Almost There - The Princess and the Frog', 'times': '3:09'},
    {'title': '19. Oo de Lally - Robin Hood', 'times': '2:48'},
    {'title': '20. Friend Like Me - Aladdin', 'times': '3:19'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(color: Color(0XFF04E406)),
                ),
                Text(
                  item['times'],
                  style: TextStyle(color: Color(0XFF04E406)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}