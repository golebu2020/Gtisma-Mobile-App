import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/PicturePageComponents/Pop.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/Pictures.dart';
import 'package:gtisma/Screens/CustomDashboard.dart';
import 'package:gtisma/Screens/IntroScreen.dart';
import 'package:gtisma/dashboardComponents/ChewieListItem.dart';
import 'package:gtisma/dashboardComponents/GlassMorphism.dart';
import 'package:gtisma/dashboardComponents/VideoGlassMorphs.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:sprung/sprung.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as videoThumb;

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
  AnimationController _opacityController;
  PageController pageController = PageController(
    initialPage: 0,
  );
  double popupState;
  bool popupVisibility;
  bool isPopupVisible;
  bool isAbsorbing;
  List<ChosenAudioFiles> _videoList;
  Animation<double> _popMenu;
  bool _swipeDesciption;
  File outputFile;
  int videoCounter;

  Color defaultState = Colors.white.withOpacity(0.5);
  Color activeState = Colors.red;
  bool recordState = false;

  Animation<double> _opacityAnimation;

  AnimationController _opacityController2;
  File savedVideo;

  List<CameraDescription> _cameras;
  CameraController _controller;
  Future<void> _initializeCameraControllerFuture;
  File vidPath;
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  bool _start = false;
  bool openPreview = true;
  bool videoPreviewState;
  File videoRenderer;
  bool _chosenVideo;
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  Future<void> _initCamera() async {
    var status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      _fileInit();
      _cameras = await availableCameras();
      _controller = CameraController(_cameras[0], ResolutionPreset.low,
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
  void initState() {
    _chosenVideo = false;
    _initCamera();
    videoPreviewState = false;
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_opacityController);

    _videoList = [];
    videoCounter = 0;
    // TODO: implement initState
    _swipeDesciption = true;
    _opacityController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _popMenu = Tween<double>(begin: 1000.0, end: 0.0).animate(//easeInOut
        CurvedAnimation(parent: _opacityController, curve: Sprung.underDamped));
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
      ],
    ).animate(
        CurvedAnimation(parent: _animController, curve: Interval(0.1, 1.0)));
    popupVisibility = false;
    super.initState();
  }

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

  getAllVideoFiles() {
    print('Bimbo');
    //UserPreferences().initReportFile();
    List<UploadingFile> uploadFile = [];
    for (var pic in _videoList) {
      //debugPrint(pic.myfile.toString());
      print(pic.myfile.path);
      // String image = "data:image/jpg;base64,$list";
      String list = base64Encode(pic.myfile.readAsBytesSync());
      String audio = "data:video/mp4;base64,$list";

      uploadFile.add(UploadingFile('video', audio));
    }
    String jsonTags = jsonEncode(uploadFile);

    //print(jsonTags);
    UserPreferences().saveReportFile(jsonTags);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animController.dispose();
    _controller.dispose();
    // try {
    //   if (vidPath.existsSync()) {
    //     vidPath.delete();
    //   }
    // } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 0.29762*height,
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
                padding: EdgeInsets.only(
                  top: 0.0014881*height,
                ),
                child: AnimatedOpacity(
                  child: widget != null
                      ? VideoGlassMorphs(
                          file: videoRenderer,
                        )
                      : Container(
                          color: Colors.white,
                        ),
                  // child: VideoGlassMorphs(file: videoRenderer,),
                  duration: Duration(milliseconds: 1000),
                  opacity: 1.0,
                ),
              ),
            ),
          ),
          Container(
            height: 0.46131*height,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(top: 0.29762*height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                audioListBuilder(),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _animController,
            child: FloatingActionButton(
                heroTag: UniqueKey(),
                elevation: 50,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  videoCounter.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                )),
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.only(
                  left: 0.08333*width,
                ),
                height: 0.03720*height, width: 0.069444*width,
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
            padding: EdgeInsets.only(top: 0.491071*height, right: 0.055556*width),
            child: FloatingActionBubble(
              herotag: Text('VideoHero156'),
              // Menu items
              items: <Bubble>[
                // Floating action menu item
                Bubble(
                    title: 'START RECORDING',
                    iconColor: Colors.white,
                    bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                    icon: Icons.videocam,
                    titleStyle: GoogleFonts.fredokaOne(
                        color: Colors.white, fontSize: 13.0),
                    onPress: () {
                      setState(() {
                        _chosenVideo = true;
                        videoPreviewState = true;
                      });
                    }),
                Bubble(
                  title: "ADD TO VIDEO LIST",
                  iconColor: Colors.white,
                  bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                  icon: Icons.add_to_photos,
                  titleStyle: GoogleFonts.fredokaOne(
                      color: Colors.white, fontSize: 13.0),
                  onPress: () {
                    //_animationController.reverse();
                    setState(() {
                      outputFile = savedVideo;
                      debugPrint('Chinedu');
                      debugPrint(outputFile.toString());
                      debugPrint(videoCounter.toString());
                      if (videoCounter <= 5) {
                        //print(outputFile);
                        if (outputFile != null) {
                          print('Thanks');
                          HapticFeedback.lightImpact();
                          setState(() {
                            _animController.reset();
                            _animController.forward();
                          });
                          _videoList.add(ChosenAudioFiles(outputFile));
                          outputFile = null;
                          videoCounter++;
                          print(_videoList.toString());
                        } else {
                          debugPrint('Error Message');
                        }
                      } else {
                        debugPrint(
                            "You've reached the maximum allowable number of pictures");
                      }
                    });
                  },
                ),
                Bubble(
                    title: 'SUBMIT', //_mPlayer.isPlaying ? 'Stop' : 'Play',
                    iconColor: Colors.white,
                    bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                    icon: Icons.done,
                    titleStyle: GoogleFonts.fredokaOne(
                        color: Colors.white, fontSize: 13.0),
                    onPress: () {
                      debugPrint('Start recording');
                      navigateNextPage(0);
                      _animationController.reverse();
                      new Timer.periodic(Duration(milliseconds: 500), (timer) {
                        timer.cancel();
                        setState(() {
                          popupVisibility = !popupVisibility;
                        });
                        _opacityController.forward();
                      });
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
          ),
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
              retrieveJSON: getAllVideoFiles,
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
          Visibility(
              child: videoInterface(context), visible: videoPreviewState),
        ],
      ),
    );
  }

  Widget ImageInterfaceDesign(int index, BuildContext context) {
    final chosen = _videoList[index];
    return GestureDetector(
      onTap: () {
        print('Thanks');
        debugPrint(_videoList[index].myfile.toString());
        // getThumnail(_videoList[index].myfile.path);
      },
      child: Opacity(
        opacity: 0.5,
        child: new Container(
            child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            //getThumnail(String filePath)
            child: Container(
              width: 0.166667*width,
              height: 0.1041667*height,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
              //child: Image.asset('/data/user/0/org.security.gtisma/cache/1613518685262.jpg',width: 60, height: 60.0),
              // child: Image.asset(getThumnail(_videoList[index].myfile.path).toString(),width: 60, height: 60.0),
              child: Center(
                  child: Text((index + 1).toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900))),
            ),
          ),
        )),
      ),
    );
  }

  Widget audioListBuilder() {
    return Opacity(
      opacity: 1.0,
      child: Container(
        margin: EdgeInsets.only(
          top: 0.05952*height,
        ),
        //color: Colors.grey.shade300,
        height: 0.104167*height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _videoList.length,
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
                    colors: [
                      Color.fromRGBO(120, 78, 125, 1.0),
                      Colors.redAccent
                    ],
                  ),
                  color: Colors.black,
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
                  _videoList[index].myfile.delete();
                  _videoList.removeAt(index);
                  videoCounter = videoCounter - 1;
                  _animController.reset();
                  _animController.forward();
                  HapticFeedback.lightImpact();
                });
              },
            );
            //return ImageInterfaceDesign(index, context);
          },
        ),
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
                colors: [Color.fromRGBO(120, 78, 125, 0.6), Colors.blueAccent],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 0.05556*width, right: 0.05556*width),
              child: Text(
                'LONG PRESS THUMBNAIL AND SWIPE DOWN TO REMOVE',
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.fredokaOne(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.3125*height, right: 0.05556*width),
            child: RotatedBox(
                quarterTurns: 315,
                child: SizedBox(
                    height: 0.59524*height,
                    width: 0.83333*width,
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

  String recordingState  = 'Video not recording';
  Widget videoInterface(BuildContext context) {
    return _chosenVideo == true
        ? Stack(children: <Widget>[
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
              top: 0.77381*height,
              left: 0.24444*width,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _start = true;
                          recordState = true;
                          recordingState  = 'Recording video';
                          _recordVideo(context);

                        });
                      },
                      child: GlassMorphism(Icon(Icons.videocam,
                          color: recordState == false
                              ? defaultState
                              : activeState))),
                  SizedBox(
                    width: 0.013889*width,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _start = false;
                        recordState = false;
                        recordingState  = 'Video not recording';
                        _recordVideo(context);

                      });
                    },
                    child: GlassMorphism(Icon(Icons.stop,
                        color:
                            recordState == false ? activeState : defaultState)),
                  ),
                  SizedBox(
                    width: 0.013889*width,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        videoPreviewState = false;
                        videoRenderer = savedVideo;
                        _chosenVideo = false;
                      });
                    },
                    child: GlassMorphism(Icon(
                      Icons.check,
                      color: Colors.white,
                    )),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 1.0,
                    child: Text(recordingState,
                  style:
                  GoogleFonts.play(color: Colors.white, fontSize: 18.0),
                ))),
            Visibility(
              visible: false, //openPreview,
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
                    'BEGIN PREVIEW',
                    style: GoogleFonts.fredokaOne(
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                        fontSize: 18.0),
                  ),
                ),
              ),
            ),
          ])
        : Text('');
  }

  var uint8list;
  String getThumnail(String filePath) {
    uint8list = videoThumb.VideoThumbnail.thumbnailFile(
      video: filePath,
      imageFormat: videoThumb.ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    debugPrint('Chined $uint8list');
    return uint8list;
  }
}

class ChosenAudioFiles {
  final File myfile;

  ChosenAudioFiles(this.myfile);
}
