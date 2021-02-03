import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:gtisma/Services.dart';
import 'package:gtisma/components/PictureGlassMorph.dart';
import 'package:gtisma/models/CrimeTypes.dart';
import 'package:supercharged/supercharged.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:gtisma/models/States.dart';
import 'package:animate_do/animate_do.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/CustomViews/MyDrawer.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'dart:async';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'package:sprung/sprung.dart';
import 'package:location/location.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/PicturePageComponents/Pop.dart';
import 'package:lottie/lottie.dart';

class PictureFrame extends StatefulWidget {
  PictureFrame({Key key}) : super(key: key);
  @override
  PictureFrameState createState() => PictureFrameState();
}

class PictureFrameState extends State<PictureFrame> with AnimationMixin {
  AnimationController _animController;
  AnimationController _animController2;
  AnimationController _opacityController;
  Animation<double> _movement;
  Animation<double> _popMenu;
  Animation<double> _animationOpacity;
  bool isAbsorbing;
  double popupState;
  bool popupVisibility;
  bool isPopupVisible;
  int nextPageIndex;
  bool _swipeDesciption;
  bool expandThumbnail;

  File imageFile;
  bool addPicAnim;
  Animation<double> _animation;
  AnimationController _animationController;
  int pictureCounter;
  final picker = ImagePicker();
  List<ChosenFiles> pictureList;
  BuildContext context2;

  double heightChange = 50;
  double widthChange = 50;

  void chi() {
    debugPrint("It's chi!");
  }

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    isAbsorbing = true;
    pictureCounter = 0;
    addPicAnim = false;
    popupState = 0.0;
    popupVisibility = false;
    isPopupVisible = false;
    nextPageIndex = 1;
    _swipeDesciption = true;
    pictureList = [];
    expandThumbnail = false;
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

    _opacityController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    _animController2 = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    _popMenu = Tween<double>(begin: 1000.0, end: 0.0).animate(//easeInOut
        CurvedAnimation(parent: _animController2, curve: Sprung.underDamped));

    _animationOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(_opacityController);

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
    _opacityController.forward();

    super.initState();
  }

  void reversePopAnimation() {
    _animController2.reverse();
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

  void gotoThirdPage() {
    pageController.animateToPage(2,
        duration: Duration(milliseconds: 2000),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  Future getImage() async {
    setState(() {
      isAbsorbing = false;
    });
    PictureFrameState().initState();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        setState(() {
          isAbsorbing = true;
        });
      } else {
        print('No image selected');
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _animationController.dispose();
    _animController2.dispose();
    _opacityController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context2 = context;
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(241, 241, 241, 1.0),
        child: Stack(
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
            Align(
              heightFactor: 2.35,
              widthFactor: 0.95,
              alignment: Alignment.bottomRight,
              child: FadeInRight(
                duration: Duration(milliseconds: 1000),
                delay: Duration(milliseconds: 1000),
                child: FloatingActionBubble(
                  herotag: "Btn1",
                  // Menu items
                  items: <Bubble>[
                    // Floating action menu item
                    Bubble(
                      title: "TAKE A SHOT",
                      iconColor: Colors.white,
                      bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                      icon: Icons.camera,
                      titleStyle: GoogleFonts.fredokaOne(
                          color: Colors.white, fontSize: 13.0),
                      onPress: () {
                        //_animationController.reverse();
                        setState(() {
                          addPicAnim = !addPicAnim;
                          //pictureCounter ++;
                          getImage();
                        });
                      },
                    ),
                    // Floating action menu item
                    Bubble(
                      title: "ADD TO THUMBNAILS",
                      iconColor: Colors.white,
                      bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                      icon: Icons.add_to_photos,
                      titleStyle: GoogleFonts.fredokaOne(
                          color: Colors.white, fontSize: 13.0),
                      onPress: () {
                        //_animationController.reverse();
                        setState(() {
                          addPicAnim = !addPicAnim;
                          //pictureCounter ++;
                          if (pictureCounter <= 5) {
                            if (imageFile != null) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                widthChange = 20.0;
                                heightChange = 20.0;
                                _animController.reset();
                                _animController.forward();
                              });
                              pictureCounter++;
                              pictureList.add(ChosenFiles(imageFile));
                              imageFile = null;
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
                    //Floating action menu item
                    Bubble(
                      title: "SUBMIT",
                      iconColor: Colors.white,
                      bubbleColor: Color.fromRGBO(116, 78, 126, 1.0),
                      icon: Icons.done,
                      titleStyle: GoogleFonts.fredokaOne(
                          color: Colors.white, fontSize: 13.0),
                      onPress: () async {
                        //navigateNextPage(0);
                        _animationController.reverse();
                        // _animController2.reset();
                        _animController2.forward();

                        setState(() {
                          //isAbsorbing = false;
                          popupState = 0.5;
                          popupVisibility = true;
                          isPopupVisible = true;
                        });

                        //getAllPictureFiles();
                      },
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
            Column(
              children: [
                SizedBox(height: 20),
                Stack(
                  children: [
                    PictureGlassMorphs(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0),
                        child: imageFile == null
                            ? Container(
                                width: 400,
                                color: Colors.transparent,
                                height: 211,
                                padding: EdgeInsets.all(100.0),
                                child: InkWell(
                                  splashColor: Colors.redAccent,
                                  onTap: () {
                                    debugPrint('clicked here');
                                    setState(() {
                                      expandThumbnail = !expandThumbnail;
                                    });
                                  },
                                ),
                              )
                            : InkWell(
                                splashColor: Colors.redAccent,
                                onTap: () {
                                  debugPrint('clicked here');
                                  setState(() {
                                    expandThumbnail = !expandThumbnail;
                                  });
                                },
                                child: Hero(
                                  tag: 'pictureHero',
                                  child: Image.file(
                                    imageFile,
                                    height: 211,
                                    width: 400,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0,),
                  //color: Colors.grey.shade300,
                  height: 75,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pictureList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        onResize: () => debugPrint('draggging dismissable'),
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
                            pictureList[index].myfile.delete();
                            pictureList.removeAt(index);
                            pictureCounter = pictureCounter - 1;
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
              ],
            ),
            AnimatedBuilder(
              animation: _animController,
              child: FloatingActionButton(
                  elevation: 50,
                  backgroundColor: pictureCounter==6?Colors.red:Colors.blueAccent,
                  child: Text(
                    '${pictureCounter.toString()}',
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
              padding: const EdgeInsets.only(left: 129.0, top: 80.0),
              child: Visibility(
                //isAbsorbing == true ? 0.0 : 1.0,
                visible: isAbsorbing == true ? false : true,
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(1),
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
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
              animation: _animController2,
              child: Pop(
                pageController: pageController,
                trigger: reversePopAnimation,
                nextPage: navigateNextPage,
                retrieveJSON: getAllPictureFiles,
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
            swippingDescription(),
            pictureDetails(),
          ],
        ),
      ),
    );
  }

  Widget pictureDetails() {
    return InkWell(
      splashColor: Colors.redAccent,
      onTap: () {
        setState(() {
          expandThumbnail = !expandThumbnail;
        });
      },
      child: Visibility(
        visible: expandThumbnail,
        child: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: imageFile == null
              ? Text('Null')
              : Image.file(imageFile, height: 500, width: double.infinity),
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
                colors: [Color.fromRGBO(120, 78, 125, 0.6), Colors.redAccent],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: AnimatedBuilder(
                animation: _animationOpacity,
                child: Text(
                  'LONG PRESS THUMBNAIL AND SWIPE DOWN TO REMOVE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredokaOne(
                      color: Colors.white, fontSize: 18.0),
                ),
                builder: (context, child) {
                  return Opacity(
                    opacity: _animationOpacity.value,
                    child: child,
                  );
                },
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

  Widget ImageInterfaceDesign(int index, BuildContext context) {
    final chosen = pictureList[index];
    return GestureDetector(
      onTap: () {
        debugPrint('${index.toString()} pressed');
      },
      child: new Container(
          child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.file(chosen.myfile,
              height: 70, width: 70, fit: BoxFit.cover),
        ),
      )),
    );
  }
  // var report = "data:imag/jpg;base64," + reportFile;
  // var newReport = jsonEncode(report);
  // var newReport2 = "$newReport";
  // print(newReport2);

  getAllPictureFiles() {
    List<UploadingFile> uploadFile = [];
    for (var pic in pictureList) {
      //debugPrint(pic.myfile.toString());
      print(pic.myfile.path);
      String list = base64Encode(pic.myfile.readAsBytesSync());
      String image = "data:image/jpg;base64,$list";

      uploadFile.add(UploadingFile('picture',image));
    }
    String jsonTags = jsonEncode(uploadFile);
    //print(jsonTags);
    UserPreferences().saveReportFile(jsonTags);
  }
}

enum AniProps { offset, opacity }

class AnimationAction extends StatelessWidget {
  final _tween = MultiTween<AniProps>()
    ..add(AniProps.offset, Tween(begin: Offset(-100, -90), end: Offset(0, -90)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(AniProps.offset, Tween(begin: Offset(0, -90), end: Offset(0, 20)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0), 1500.milliseconds,
        Curves.easeInOut);
  Widget widget;
  AnimationAction(this.widget);
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<MultiTweenValues<AniProps>>(
      tween: _tween,
      duration: _tween.duration,
      child: widget,
      builder: (context, child, value) {
        return Transform.translate(
          offset: value.get(AniProps.offset),
          child: Opacity(
            child: child,
            opacity: value.get(AniProps.opacity),
          ),
        );
      },
    );
  }
}

class AnimatedContains extends StatelessWidget {
  Widget widget;
  AnimatedContains(this.widget);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation(
      tween: 0.0.tweenTo(50.0),
      duration: 150.milliseconds,
      curve: Curves.easeOut,
      delay: 2.seconds,
      child: widget,
      builder: (context, child, value) {
        return Container(
          margin: EdgeInsets.only(left: 30.0),
          child: child,
          height: value,
          width: value,
        );
      },
    );
  }
}

class PictureDetailing extends StatelessWidget {
  final File imageFile;
  PictureDetailing(this.imageFile);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: imageFile == null
          ? Text('Null')
          : Hero(
              tag: 'pictureHero',
              child:
                  Image.file(imageFile, height: 500, width: double.infinity)),
    );
  }
}

class ChosenFiles {
  final File myfile;

  ChosenFiles(this.myfile);
}

//File uploading model class
class UploadingFile {
  final String type;
  final dynamic file;

  UploadingFile(this.type, this.file);

  Map toJson() => {
        'type': type,
        'file': file,
      };
}
