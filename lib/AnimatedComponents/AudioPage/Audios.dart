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


class SimpleRecorderHome extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  SimpleRecorderHome({localFileSystem, Key key})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem(),
        super(key: key);

  @override
  _SimpleRecorderHomeState createState() => _SimpleRecorderHomeState();
}

class _SimpleRecorderHomeState extends State<SimpleRecorderHome>
    with TickerProviderStateMixin {
  TimerController _timerController;
  String recordStatus;
  bool animatedIconState;
  File outputFile;
  int audioCounter;
  List<ChosenAudioFiles> _audioList;
  bool _swipeDesciption;

  Animation<double> _animation;
  AnimationController _animationController;
  AnimationController controller;

  double progressAnimationValue;
  double timerProgressValue;

  //Flutter Sound Recorder
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  String audioButtonState = "START RECORDING";
  bool lottieAnimation = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String audioPlayerCurrent = 'default';
  AnimationController _animController;
  Animation<double> _movement;

  double popupState;
  bool popupVisibility;
  bool isPopupVisible;
  bool isAbsorbing;
  AnimationController _opacityController;
  PageController pageController = PageController(
    initialPage: 0,
  );
  Animation<double> _popMenu;
  bool iconVisible = true;
  bool isTimerVisible = false;
  IconData iconValue = Icons.play_arrow;
  bool playVisible = true;
  //the duration of audio
  int audioDuration = 0;
  double expandAnimation = 0.0;
  double audioExpandDistance = 0.0;
  bool absorbFAB = false;
  bool absorbPlayer = false;
  var currentAudioPos;
  void reversePopAnimation() {
    _opacityController.reverse();
    setState(() {
      popupState = 0.0;
      popupVisibility = false;
      isPopupVisible = false;
    });
  }

  void navigateNextPage(int next) {
    pageController.animateToPage(next,
        duration: Duration(milliseconds: 2000),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  getAllAudioFiles() {
    print('Bimbo');
    //UserPreferences().initReportFile();
    List<UploadingFile> uploadFile = [];
    for (var pic in _audioList) {
      //debugPrint(pic.myfile.toString());
      print(pic.myfile.path);
      // String image = "data:image/jpg;base64,$list";
      String list = base64Encode(pic.myfile.readAsBytesSync());
      String audio = "data:audio/wav;base64,$list";

      uploadFile.add(UploadingFile('audio', audio));
    }
    String jsonTags = jsonEncode(uploadFile);

    //print(jsonTags);
    UserPreferences().saveReportFile(jsonTags);
  }

  @override
  void initState() {
    _animController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    debugPrint(UserPreferences().retrieveUserData());
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    _movement = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
            tween: new Tween(begin: 20.0, end: 30.0).chain(CurveTween(
              curve: Sprung(250),
            )),
            weight: 20.0),
        TweenSequenceItem<double>(
            tween: new Tween(begin: 30.0, end: 20.0).chain(CurveTween(
              curve: Sprung.underDamped,
            )),
            weight: 20.0),
        // TweenSequenceItem<double>(
        //     tween: new Tween(begin: 20.0, end: 40.0)
        //         .chain(CurveTween(curve: Curves.easeOut)),
        //     weight: 60.0),
      ],
    ).animate(
        CurvedAnimation(parent: _animController, curve: Interval(0.1, 1.0)));

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _timerController = TimerController(this);
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    recordStatus = 'RECORD';
    animatedIconState = false;
    progressAnimationValue = 0.0;
    timerProgressValue = 0.0;
    audioCounter = 0;
    _audioList = [];
    _swipeDesciption = true;

    _init();

    _opacityController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    debugPrint(UserPreferences().retrieveUserData());
    popupState = 0.0;
    popupVisibility = false;
    isPopupVisible = false;
    _popMenu = Tween<double>(begin: 1000.0, end: 0.0).animate(//easeInOut
        CurvedAnimation(parent: _opacityController, curve: Sprung.underDamped));
    isAbsorbing = true;

    super.initState();
  }

  @override
  void dispose() {
    //_animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomPadding: false,
     resizeToAvoidBottomInset: false,
      body: returnStackDesign(),
    );
  }

  void showAudioSnackBar(String message, Color color) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        backgroundColor: color,
        animation: _animation,
        content: new Text(message)));
  }

  Widget returnStackDesign() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(120, 78, 125, 1.0),
                Color.fromRGBO(255, 255, 255, 1.0)
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(0.0),
              topRight: const Radius.circular(0.0),
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(200.0),
            ),
          ),
        ),
        Container(
          height: 310.0,
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.only(top: 200.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              audioListBuilder(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: iconVisible
              ? AudioGlassMorphs(child: Icons.mic)
              : AudioGlassMorphs(),
        ),
        AnimatedBuilder(
          animation: _animController,
          child: FloatingActionButton(
              heroTag: null,
              elevation: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                audioCounter.toString(),
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              )),
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.only(
                left: 15.0,
              ),
              height: 25, width: 25,
              // width: _movement.value,
              child: Transform.translate(
                child: child,
                offset: Offset(0, _movement.value),
              ),
              // child: FloatingActionButton(
              //   backgroundColor: Color.fromRGBO(120, 78, 125, 1.0),
              //   child: Text(pictureCounter.toString()),
              // ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Visibility(
            visible: isTimerVisible,
            child: Align(
                alignment: Alignment.topCenter,
                child: _current != null
                    ? Text(
                        "${_current?.duration.toString().substring(3, 7)}",
                        style: GoogleFonts.fredokaOne(
                            color: Colors.white, fontSize: 80.0),
                      )
                    : Text('')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 320.0, right: 15.0),
          child: AbsorbPointer(
            absorbing: absorbFAB,
            child: FloatingActionBubble(
              herotag: null,
              // Menu items
              items: <Bubble>[
                // Floating action menu item
                Bubble(
                  title: audioButtonState,
                  iconColor: audioButtonState == 'STOP RECORDING'
                      ? Colors.redAccent
                      : Colors.white,
                  bubbleColor: Color.fromRGBO(120, 78, 125, 1.0),
                  icon: Icons.mic,
                  titleStyle: GoogleFonts.fredokaOne(
                      color: Colors.white, fontSize: 13.0),
                  onPress: () {
                    if (_currentStatus == RecordingStatus.Initialized) {
                      _start();
                      // showAudioSnackBar(
                      //     "Audio recording has started", Colors.green);
                      setState(() {
                        audioButtonState = 'STOP RECORDING';
                        lottieAnimation = false;
                        playVisible = false;
                      });
                    } else if (_currentStatus == RecordingStatus.Recording) {
                      _stop();
                      // showAudioSnackBar(
                      //     "Audio recording has stopped", Colors.redAccent);
                      setState(() {
                        audioButtonState = 'START RECORDING';
                        playVisible = true;
                        audioPlayerCurrent = 'default';
                      });
                    } else if (_currentStatus == RecordingStatus.Stopped) {
                      _init();
                      // showAudioSnackBar(
                      //     "Audio recording has started", Colors.green);
                      Timer.periodic(Duration(seconds: 1), (timer) {
                        _start();
                        timer.cancel();
                      });
                      setState(() {
                        audioButtonState = 'STOP RECORDING';
                        lottieAnimation = false;
                      });
                    } else if (_currentStatus == RecordingStatus.Unset) {
                      // showAudioSnackBar(
                      //     "Audio recording has started", Colors.blueAccent);
                      _init();
                      Timer.periodic(Duration(seconds: 1), (timer) {
                        _start();
                        timer.cancel();
                      });
                      setState(() {
                        audioButtonState = 'STOP RECORDING';
                        lottieAnimation = false;
                      });
                    }
                  }, //getRecorderFn(),
                ),
                Bubble(
                  title: "ADD TO AUDIO LIST",
                  iconColor: Colors.white,
                  bubbleColor: Color.fromRGBO(120, 78, 125, 1.0),
                  icon: Icons.add_to_photos,
                  titleStyle: GoogleFonts.fredokaOne(
                      color: Colors.white, fontSize: 13.0),
                  onPress: () {
                    //_animationController.reverse();
                    setState(() {
                      debugPrint('Chinedu');
                      debugPrint(outputFile.toString());
                      debugPrint(audioCounter.toString());
                      if (audioCounter <= 5) {
                        //print(outputFile);
                        if (outputFile != null) {
                          print('Thanks');
                          HapticFeedback.lightImpact();
                          setState((){
                            _animController.reset();
                            _animController.forward();
                          });
                          _audioList.add(ChosenAudioFiles(outputFile));
                          outputFile = null;
                          audioCounter++;
                          print(_audioList.toString());
                        }
                        else{
                          debugPrint('Error Message');
                        }
                      }else{
                        debugPrint(
                            "You've reached the maximum allowable number of pictures");
                      }
                    });
                  },
                ),
                Bubble(
                    title: 'SUBMIT', //_mPlayer.isPlaying ? 'Stop' : 'Play',
                    iconColor: Colors.white,
                    bubbleColor: Color.fromRGBO(120, 78, 125, 1.0),
                    icon: Icons.done,
                    titleStyle: GoogleFonts.fredokaOne(
                        color: Colors.white, fontSize: 13.0),
                    onPress: () {
                      navigateNextPage(0);
                      _animationController.reverse();
                      new Timer.periodic(Duration(milliseconds: 500),
                          (timer) {
                        timer.cancel();
                        setState(() {
                          popupVisibility = !popupVisibility;
                        });
                        _opacityController.forward();
                      });
                    } //getPlaybackFn(),
                    ),
              ],

              // animation controller
              animation: _animation,

              // On pressed change animation state
              onPress: _animationController.isCompleted
                  ? _animationController.reverse
                  : _animationController.forward,

              // Floating Action button Icon color
              iconColor: Colors.blue,
              animatedIconData: AnimatedIcons.add_event,
              // Flaoting Action button Icon
              backGroundColor: Colors.blueAccent,
            ),
          ),
        ),
        getPlayerAnim(),
        swippingDescription(),
        Visibility(
          visible: popupVisibility,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _opacityController,
          child: Pop(
            pageController: pageController,
            trigger: reversePopAnimation,
            nextPage: navigateNextPage,
            retrieveJSON: getAllAudioFiles,
          ),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _popMenu.value), // _popMenu.value / 30.0
              child: Visibility(
                  visible: 1 - (_popMenu.value / 100.0) == 0.0
                      ? false
                      : true, // 1 - (_popMenu.value / 100.0)
                  child: Opacity(child: child, opacity: 1.0)),
            );
          },
        ),
      ],
    );
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

  _init() async {
    try {
      debugPrint('The Audio Library has been initialized');
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      setState(() {
        isTimerVisible = true;
        iconVisible = false;
      });
      debugPrint('Audio Recording has started recording..');
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
      const tick2 = const Duration(seconds: 1);
      new Timer.periodic(tick2, (Timer t) async {
        //print('NEDUNEDU');
        String starT = _current?.duration.toString().substring(5, 7);
        //print(int.parse(starT).toString());
        if (int.parse(starT) == 59) {
          print('Ended');
          _stop();
          setState(() {
            audioButtonState = 'START RECORDING';
            playVisible = true;
          });
          t.cancel();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    setState(() {
      isTimerVisible = false;
      iconVisible = true;
    });
    debugPrint('The Audio Recoding Has been Stopped');
    var result = await _recorder.stop();

    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    outputFile = file;
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      audioDuration = result.duration.inSeconds;
    });
  }

  void onPlayAudio() async {
    await audioPlayer.play(_current.path, isLocal: true);
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

  Widget ImageInterfaceDesign(int index, BuildContext context) {
    final chosen = _audioList[index];
    return GestureDetector(
      onTap: () {
        print('Thanks');
      },
      child: new Container(
          child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
                child: Text((index + 1).toString(),
                    style: TextStyle(
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900))),
          ),
          // child: Image.asset('assets/images/voice.png',
          //     height: 70, width: 45, fit: BoxFit.cover),
        ),
      )),
    );
  }

  Widget audioListBuilder() {
    return Container(
      margin: EdgeInsets.only(
        top: 40.0,
      ),
      //color: Colors.grey.shade300,
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _audioList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            child: ImageInterfaceDesign(index, context),
            direction: DismissDirection.vertical,
            key: UniqueKey(),
            background: Container(
              child: Icon(Icons.check_box, color: Colors.white),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(120, 78, 125, 1.0),
                    Color.fromRGBO(41, 78, 149, 1.0)
                  ],
                ),
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                  bottomLeft: const Radius.circular(10.0),
                  bottomRight: const Radius.circular(10.0),
                ),
              ),
            ),
            secondaryBackground: Container(
              child: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color.fromRGBO(120, 78, 125, 1.0), Colors.redAccent],
                ),
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                  bottomLeft: const Radius.circular(10.0),
                  bottomRight: const Radius.circular(10.0),
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                _audioList[index].myfile.delete();
                _audioList.removeAt(index);
                audioCounter = audioCounter - 1;
                _animController.reset();
                _animController.forward();
                HapticFeedback.lightImpact();
              });
            },
          );
          //return ImageInterfaceDesign(index, context);
        },
      ),
    );
  }

  Widget swippingDescription() {
    return Visibility(
      visible: _swipeDesciption,
      child: Stack(
        children: [
          Container(
            // color: Colors.black.withOpacity(0.7),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color.fromRGBO(120, 78, 125, 0.6), Colors.redAccent],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                'LONG PRESS THUMBNAIL AND SWIPE DOWN TO REMOVE',
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.fredokaOne(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 210, right: 20),
            child: RotatedBox(
                quarterTurns: 315,
                child: SizedBox(
                    height: 400.0,
                    width: 300.0,
                    child: Lottie.asset('assets/images/finger_swipe.json'))),
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                elevation: 0.0,
                onPressed: () {
                  debugPrint('Already read about object deleting');
                  setState(() {
                    _swipeDesciption = !_swipeDesciption;
                  });
                },
                color: Colors.white,
                shape: StadiumBorder(),
                child: Text(
                  'OK',
                  style: GoogleFonts.fredokaOne(
                      color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
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
}

class ChosenAudioFiles {
  final File myfile;

  ChosenAudioFiles(this.myfile);
}

class AudioAction extends StatefulWidget {
  @override
  _AudioActionState createState() => _AudioActionState();
}

class _AudioActionState extends State<AudioAction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 210.0, left: 25.0, right: 10.0),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 5),
                    width: 300.0,
                    height: 2.5,
                    color: Colors.blueAccent,
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 5),
                    margin: EdgeInsets.only(left: 300.0),
                    height: 13.0,
                    width: 13.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
