import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/Pictures.dart';
import 'package:gtisma/Screens/EyewitnessLogin.dart';
import 'package:gtisma/components/shader_mask_icon.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'package:gtisma/helpers/NavigationPreferences.dart';
//import 'package:translator/translator.dart';

SelectLanguage lang = SelectLanguage();
dynamic nativeLanguage = '';

class CustomDrawer extends StatefulWidget {
  final Widget child;
  final Function setGlobalValue;
  final Function setAppBarState;

  CustomDrawer(
      {Key key,
      @required this.child,
      @required this.setGlobalValue,
      this.setAppBarState})
      : super(key: key);

  static CustomDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomDrawerState>();

  @override
  CustomDrawerState createState() => new CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  Animation<double> _animation;
  static const Duration toggleDuration = Duration(milliseconds: 250);
  double maxSlide = 0.63889*UserPreferences().getGeneralWidth();//230;
  double minDragStartEdge = 0.16667*UserPreferences().getGeneralWidth();//60;
  double maxDragStartEdge = (0.63889 - 0.04444)*UserPreferences().getGeneralWidth();
  AnimationController _animationController;
  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: CustomDrawerState.toggleDuration,
      vsync: this,
    );
  }

  void close() {
    _animationController.reverse();
    widget.setAppBarState();
  }

  void open() {
    _animationController.forward();
    widget.setAppBarState();
  }

  void toggleDrawer() => _animationController.isCompleted ? close() : open();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: _animationController,
          child: widget.child,
          builder: (context, child) {
            double animValue = _animationController.value;
            final slideAmount = maxSlide * animValue;
            final contentScale = 1.0 - (0.3 * animValue);
            return Stack(
              children: <Widget>[
                MyDrawer(
                    myChild: widget.child,
                    setGlobalValue: widget.setGlobalValue),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slideAmount)
                    ..scale(contentScale, contentScale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _animationController.isCompleted ? close : null,
                    child: child,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}

class MyDrawer extends StatefulWidget {
  final Function setGlobalValue;
  final Widget myChild;

  MyDrawer({Key key, this.myChild, @required this.setGlobalValue})
      : super(key: key);
  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  String nativeLanguage;
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  //dynamic translator = GoogleTranslator();
  var audioReport;

  @override
  void initState(){
    // TODO: implement initState
    nativeLanguage = UserPreferences().data;
    print('Obtaining the nativeLanuage...');

    print(nativeLanguage);
    translateText();
    super.initState();
  }

  void translateText() async{
   // audioReport = await translator.translate('voice', from: 'en', to: 'yo');
  }

  @override
  Widget build(BuildContext context) {
    var fontDesign2 = GoogleFonts.nunitoSans(
        fontSize: 18.0, color:Colors.white, fontWeight: FontWeight.w700);
    var fontDesign = GoogleFonts.nunitoSans(
        fontSize: 18.0, color:Colors.white, fontWeight: FontWeight.normal);
    var fontDesign3 = GoogleFonts.nunitoSans(
        fontSize: 15.0, color:Colors.white, fontWeight: FontWeight.normal);
    return Material(
      color: Colors.blueAccent,
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Theme(
              data: ThemeData(brightness: Brightness.dark),
              child: Stack(
                children: [
                  BackgroundDecoration(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0.0277778*width, top: 0.029762*height),
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: AvatarGlow(
                                      glowColor: Colors.white,
                                      endRadius: 60.0,
                                      duration: Duration(milliseconds: 1000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration:
                                          Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(
                                          side: BorderSide(
                                            width: 0.0027778*width,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: UserPreferences()
                                                    .retrieveSocialLoginPicURL() !=
                                                null
                                            ? CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                backgroundImage: NetworkImage(
                                                    UserPreferences()
                                                        .retrieveSocialLoginPicURL()),
                                                radius: 30.0,
                                              )
                                            : ShaderMaskIcon(Icon(
                                                Icons.person,
                                                size: 50.0,
                                              )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.083333*width),
                                    child: Text(
                                      UserPreferences()
                                          .retrieveSocialLoginName(),
                                      style: fontDesign2,

                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.083333*width),
                                    child: Text(
                                      UserPreferences()
                                          .retrieveSocialLoginEmail(),
                                      style: fontDesign3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.044643*height*1,
                      ),
                      Divider(
                        height: 0.001488*height,
                        thickness: 20,
                        color: Colors.pinkAccent.withOpacity(0.05),
                      ),
                      SizedBox(
                        height: 0.044643*height,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.05556*width),
                        child: ListTile(
                          leading: ShaderMaskIcon(Icon(Icons.report)),
                          title: Text(
                            lang.languagTester(nativeLanguage)[35],
                            style: fontDesign,
                          ),
                          onTap: () async {
                            CustomDrawer.of(context).close();
                            new Timer.periodic(
                              Duration(milliseconds: 300),
                              (Timer timer) => setState(
                                () {
                                  widget.setGlobalValue(0);
                                  timer.cancel();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: UserPreferences().retrieveUserTypeId() == 3
                            ? true
                            : false,
                        child: Divider(
                          height: 1,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      Visibility(
                        visible: UserPreferences().retrieveUserTypeId() == 3
                            ? true
                            : false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.05556*width),
                          child: ListTile(
                            leading: ShaderMaskIcon(Icon(Icons.add_a_photo)),
                            title: Text(
                              lang.languagTester(nativeLanguage)[36],
                              style:fontDesign,
                            ),
                            onTap: () async {
                              CustomDrawer.of(context).close();
                              new Timer.periodic(
                                Duration(milliseconds: 300),
                                (Timer timer) => setState(
                                  () {
                                    widget.setGlobalValue(1);
                                    timer.cancel();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: UserPreferences().retrieveUserTypeId() == 3
                            ? true
                            : false,
                        child: Divider(
                          height: 1,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      Visibility(
                        visible: UserPreferences().retrieveUserTypeId() == 3
                            ? true
                            : false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.05556*width),
                          child: ListTile(
                              leading:
                                  ShaderMaskIcon(Icon(Icons.ondemand_video)),
                              title: Text(
                                lang.languagTester(nativeLanguage)[37],
                                style: fontDesign,
                              ),
                              onTap: () async {
                                CustomDrawer.of(context).close();
                                new Timer.periodic(
                                  Duration(milliseconds: 300),
                                  (Timer timer) => setState(
                                    () {
                                      widget.setGlobalValue(3);
                                      timer.cancel();
                                    },
                                  ),
                                );
                                //PictureFrameState().dispose();
                              }),
                        ),
                      ),
                      Visibility(
                        visible: UserPreferences().retrieveUserTypeId() == 3
                            ? true
                            : false,
                        child: Divider(
                          height: 1,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      Visibility(
                        visible: UserPreferences().retrieveUserTypeId() == 3
                            ? true
                            : false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.05556*width),
                          child: ListTile(
                            leading: ShaderMaskIcon(Icon(Icons.mic)),
                            title: Text(
                              lang.languagTester(nativeLanguage)[45],
                              //'Audio report',
                              style: fontDesign,
                            ),
                            onTap: () async {
                              CustomDrawer.of(context).close();
                              new Timer.periodic(
                                Duration(milliseconds: 300),
                                (Timer timer) => setState(
                                  () {
                                    widget.setGlobalValue(2);

                                    timer.cancel();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Divider(
                        height: 0.0014881*height,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.055556*width),
                        child: ListTile(
                          leading: ShaderMaskIcon(Icon(Icons.adjust_outlined)),
                          title: Text(
                            lang.languagTester(nativeLanguage)[46],
                            style: fontDesign,
                          ),
                          onTap: () async {
                            googleLogOut();
                            CustomDrawer.of(context).close();
                            new Timer.periodic(
                              Duration(milliseconds: 300),
                              (Timer timer) => setState(
                                () {
                                  NavigationPreferences().storeLoginScreen(false);
                                  //widget.setGlobalValue(2);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return EyewitnessLoginStat();
                                  },));
                                  // NavigationPreferences()
                                  //     .storeLoginScreen(false);
                                  // NavigationHelper().navigateAnotherPage(
                                  //     context, EyewitnessLoginStat());
                                  timer.cancel();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void googleLogOut(){
    //final GoogleSignIn googleSignIn = new GoogleSignIn();
    // googleSignIn.isSignedIn().then((value) async{
    //   var value = await googleSignIn.signOut();
    //   debugPrint(value.toString());
    // });
  }
}

class BackgroundDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromRGBO(120, 78, 125, 1.0),
            Color.fromRGBO(41, 78, 149, 1.0),
          ],
        ),
      ),
    );
  }
}
