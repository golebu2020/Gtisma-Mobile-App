import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/Pictures.dart';
import 'package:gtisma/components/shader_mask_icon.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';

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
  Animation<double> _animation;
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double maxSlide = 230;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
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
  final nativeLanguage = UserPreferences().data;
  @override
  Widget build(BuildContext context) {
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
                            padding: EdgeInsets.only(left: 10.0, top: 20.0),
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
                                            width: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                              UserPreferences()
                                                  .retrieveSocialLoginPicURL()),
                                          radius: 30.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      UserPreferences()
                                          .retrieveSocialLoginName(),
                                      style: GoogleFonts.robotoSlab(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      UserPreferences()
                                          .retrieveSocialLoginEmail(),
                                      style: GoogleFonts.robotoSlab(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListTile(
                          selectedTileColor: Colors.red,
                          focusColor: Colors.blueAccent,
                          leading: ShaderMaskIcon(Icon(Icons.language)),
                          title: Text(
                            lang.languagTester(nativeLanguage)[39],
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            //Navigator.of(context).pop();
                            //dash.EyewitnessBodyState().moveToChangeLanguage();
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListTile(
                          leading: ShaderMaskIcon(Icon(Icons.report)),
                          title: Text(
                            lang.languagTester(nativeLanguage)[35],
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
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
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListTile(
                          leading: ShaderMaskIcon(Icon(Icons.add_a_photo)),
                          title: Text(
                            lang.languagTester(nativeLanguage)[36],
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
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
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListTile(
                            leading: ShaderMaskIcon(Icon(Icons.ondemand_video)),
                            title: Text(
                              lang.languagTester(nativeLanguage)[37],
                              style: GoogleFonts.robotoSlab(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
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
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListTile(
                          leading: ShaderMaskIcon(Icon(Icons.mic)),
                          title: Text(
                            'Audio report',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
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
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      SizedBox(
                        height: 30.0,
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
            Color.fromRGBO(41,78,149,1.0),
          ],
        ),
      ),
    );
  }
}

class AvaterDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: Stack(
        children: [
          ClipOval(
            child: Container(
              width: 80.0,
              height: 80.0,
              color: Colors.red,
            ),
          ),
          Container(
            child: AvatarGlow(
              glowColor: Colors.white,
              endRadius: 60.0,
              duration: Duration(milliseconds: 1000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 0.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      UserPreferences().retrieveSocialLoginPicURL()),
                  radius: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
