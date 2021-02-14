import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/PicturePageComponents/Pop.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/Pictures.dart';
import 'package:gtisma/components/AudioGlassMorph.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_timer/simple_timer.dart';
import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:sprung/sprung.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:video_player/video_player.dart';


class AudioListHelper extends StatefulWidget {
  final String fileUrl;
  AudioListHelper({Key key, this.fileUrl}): super(key:key);

  @override
  _AudioListHelperState createState() => _AudioListHelperState();
}

class _AudioListHelperState extends State<AudioListHelper> {
  int audioDuration = 0;
  double expandAnimation = 0.0;
  double audioExpandDistance = 0.0;
  bool absorbFAB = false;
  bool absorbPlayer = false;
  var currentAudioPos;
  IconData iconValue = Icons.play_arrow;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  String audioPlayerCurrent = 'default';
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget getPlayerAnim() {
    return Padding(
      padding: const EdgeInsets.only(top: 160.0, left: 19.5, right: 19.5),
      child: Container(
        height: 75.0,
        width: 450.0,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.all(8.0),
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: SizedBox(
                  height: 5.0,
                  width: 5.0,
                  child: Image.asset(
                    'assets/images/earphone.png',
                    fit: BoxFit.contain,
                    height: 40,
                    width: 40,
                  )),
            ),
            getPlayerInterface(),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2.0,
                    top: 4,
                  ),
                  child: Container(
                    height: 5.0,
                    width: 195.0,
                    color: Color.fromRGBO(120, 78, 125, 0.2),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: expandAnimation.toInt()),
                      width: audioExpandDistance,
                      height: 5.0,
                      color: Color.fromRGBO(120, 78, 125, 1.0),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: expandAnimation.toInt()),
                      margin: EdgeInsets.only(left: audioExpandDistance),
                      height: 13.0,
                      width: 13.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getPlayerInterface() {
    return Visibility(
      visible: true,
      child: GestureDetector(
        child: Icon(iconValue,
            size: 40.0, color: Color.fromRGBO(120, 78, 125, 1.0)),
        onTap: () async {
          print('Chinedu==> ' + _currentStatus.toString());
          if (_currentStatus == RecordingStatus.Stopped &&
              audioPlayerCurrent == 'default') {
            print('Called here 1');
            setState(() {
              audioPlayerCurrent = 'play';
              iconValue = Icons.stop;
              expandAnimation = audioDuration.toDouble();
              audioExpandDistance =
              190.0; //the width of the animated container
              absorbFAB = true;
            });
            onPlayAudio();

            audioPlayer.onPlayerCompletion.listen((event) {
              print('THe audio playing has completer');
              setState(() {
                expandAnimation = 0.0;
                audioExpandDistance = 0;
                iconValue = Icons.play_arrow;
                audioPlayerCurrent = 'default';
                absorbFAB = false;
              });
            });
          } else if (_currentStatus == RecordingStatus.Stopped &&
              audioPlayerCurrent == 'play') {
            onStopAudio();
            // var pos2 = await audioPlayer.getCurrentPosition();
            setState(() {
              expandAnimation = 0.0;
              audioExpandDistance = 0;
              iconValue = Icons.play_arrow;
              audioPlayerCurrent = 'default';
              absorbFAB = false;
            });
          }
        },
      ),
    );
  }

  void onPlayAudio() async {
    await audioPlayer.play(widget.fileUrl, isLocal: true);
  }

  void onPauseAudio() async {
    await audioPlayer.pause();
  }

  void onResumeAudio() async {
    await audioPlayer.resume();
  }

  void onStopAudio() async {
    await audioPlayer.stop();
  }

}
