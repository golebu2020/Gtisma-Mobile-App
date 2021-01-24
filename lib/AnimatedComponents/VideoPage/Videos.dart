import 'dart:async';

import 'package:camera/camera.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/Screens/CustomDashboard.dart';
import 'package:gtisma/Screens/IntroScreen.dart';
import 'package:gtisma/dashboardComponents/GlassMorphism.dart';
import 'package:gtisma/dashboardComponents/VideoGlassMorphs.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:sprung/sprung.dart';

class VideosHome extends StatefulWidget {
  VideosHome({Key key}) : super(key: key);

  @override
  _VideosHomeState createState() => _VideosHomeState();
}

class _VideosHomeState extends State<VideosHome> with TickerProviderStateMixin {
  Color defaultState = Colors.white.withOpacity(0.5);
  Color activeState = Colors.red;
  bool recordState = false;

  Animation<double> _opacityAnimation;

  AnimationController _opacityController;
  File savedVideo;

  List<CameraDescription> _cameras;
  CameraController _controller;
  Future<void> _initializeCameraControllerFuture;
  File vidPath;
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  bool _start = false;
  bool openPreview = true;

  @override
  void initState() {
    // TODO: implement initState
    _initCamera();
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_opacityController);
    super.initState();
  }

  Future<void> _initCamera() async {
    var status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      _fileInit();
      _cameras = await availableCameras();
      _controller = CameraController(_cameras[0], ResolutionPreset.medium,
          enableAudio: true);
      _initializeCameraControllerFuture = _controller.initialize();
    }
  }

  void _fileInit() async {
    vidPath =
        File(join((await getTemporaryDirectory()).path, '${fileName}.mp4'));
  }

  void _recordVideo(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;
      if (_start) {
        var fileName = DateTime.now().millisecondsSinceEpoch.toString();
        vidPath =
            File(join((await getTemporaryDirectory()).path, '${fileName}.mp4'));
        await _controller.startVideoRecording(vidPath.path);
        setState(() {
          _opacityController.forward();
          //_isRec = !_isRec;
        });
      } else {
        _controller.stopVideoRecording();
        setState(() {
          //_isRec = !_isRec;
          _opacityController.reverse();
        });
        //Navigator.pop(context, vidPath);
        setState(() {
          savedVideo = vidPath;
        });
        debugPrint(vidPath.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    try {
      if (vidPath.existsSync()) {
        vidPath.delete();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(children: <Widget>[
          FutureBuilder(
              future: _initializeCameraControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Container(color: Colors.white);
                }
              }),
          Positioned(
            top: 520.0,
            left: 88.0,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _start = true;
                        recordState = true;
                        _recordVideo(context);
                      });
                    },

                    child: GlassMorphism(Icon(Icons.videocam,
                        color: recordState == false
                            ? defaultState
                            : activeState))),
                SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _start = false;
                      recordState = false;
                      _recordVideo(context);
                    });
                  },
                  child: GlassMorphism(Icon(Icons.stop,
                      color:
                          recordState == false ? activeState : defaultState)),
                ),
                SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    NavigationHelper().navigateAnotherPage(
                        context,
                        CustomDashboard(
                          videoFile: savedVideo,
                          pageType: true,
                        ));
                  },
                  child: GlassMorphism(Icon(
                    Icons.check,
                    color: Colors.white,
                  )),
                ),
              ],
            ),
          ),
          Visibility(
            visible: openPreview,
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  _start = true;
                  _recordVideo(context);
                  new Timer.periodic(
                    Duration(seconds: 2),
                    (Timer timer) => setState(
                      () {
                        openPreview = false;
                        _start = false;
                        _recordVideo(context);
                        timer.cancel();
                      },
                    ),
                  );
                },
                color: Colors.white,
                shape: StadiumBorder(),
                child: Text(
                  'OPEN PREVIEW',
                  style: GoogleFonts.fredokaOne(
                      color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 18.0),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class VideoDetailing extends StatefulWidget {
  final File videoFile;
  VideoDetailing({Key key, @required this.videoFile}) : super(key: key);

  @override
  _VideoDetailingState createState() => _VideoDetailingState();
}

class _VideoDetailingState extends State<VideoDetailing>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  AnimationController _animController;
  Animation<double> _movement;
  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _animController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
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
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Detailing Page',
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionBubble(
          herotag: Text('VideoHero1'),
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
                title: 'START RECORDING',
                iconColor: Colors.white,
                bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                icon: Icons.mic,
                titleStyle:
                    GoogleFonts.fredokaOne(color: Colors.white, fontSize: 13.0),
                onPress: () {
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  //   return VideosHome();
                  // },));
                  NavigationHelper().navigateAnotherPage(context, VideosHome());
                }),
            Bubble(
              title: "ADD TO VIDEO LIST",
              iconColor: Colors.white,
              bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
              icon: Icons.add_to_photos,
              titleStyle:
                  GoogleFonts.fredokaOne(color: Colors.white, fontSize: 13.0),
              onPress: () {
                debugPrint('Start recording');
              },
            ),
            Bubble(

                title: 'SUBMIT', //_mPlayer.isPlaying ? 'Stop' : 'Play',
                iconColor: Colors.white,
                bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                icon: Icons.done,
                titleStyle:
                    GoogleFonts.fredokaOne(color: Colors.white, fontSize: 13.0),
                onPress: () {
                  debugPrint('Start recording');
                }),
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
        backgroundColor: Colors.white,
        body: Stack(
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
              child: Center(
                child: Padding(
                  padding:
                  const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  child: AnimatedOpacity(

                    child: widget != null
                        ? VideoGlassMorphs(
                      file: widget.videoFile,
                    )
                        : Container(
                      color: Colors.white,
                    ),
                    duration: Duration(milliseconds: 1000),
                    opacity: 1.0,
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animController,
              child: FloatingActionButton(
               heroTag: UniqueKey(),
                  elevation: 50,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    '0',
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
          ],
        ),
      ),
    );
  }
}
