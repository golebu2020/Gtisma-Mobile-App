import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:gtisma/helpers/NavigationPreferences.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';

import 'IntroScreen.dart';

class LanguageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Language(),
      ),
    );
  }
}

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> with TickerProviderStateMixin {
  List<AnimationController> _animContList = [];
  List<CurvedAnimation> _curvedAnimList = [];
  List<Animation<double>> _animationList = [];
  double _animatedBlue = 0.0;
  Color colorAnim = Colors.white;
  AnimationController controller;
  AnimationController controller2;
  Animation<dynamic> movement;
  Animation<dynamic> movement2;
  Animation<dynamic> scaler;
  Animation<dynamic> scaler2;
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      duration: Duration(milliseconds: 10000),
      vsync: this,
    );
    controller2 = AnimationController(
      duration: Duration(milliseconds: 10200),
      vsync: this,
    );
    movement = TweenSequence(
      <TweenSequenceItem<dynamic>>[
        TweenSequenceItem<dynamic>(
            tween: new Tween(begin: 1000.0, end: 50.0).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 10.0),
        TweenSequenceItem<dynamic>(
            tween: new Tween(
              begin: 50.0,
              end: -500.0,
            ).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 10.0),
      ],
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    movement2 = TweenSequence(
      <TweenSequenceItem<dynamic>>[
        TweenSequenceItem<dynamic>(
            tween: new Tween(begin: 1000.0, end: 50.0).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 10.0),
        TweenSequenceItem<dynamic>(
            tween: new Tween(
              begin: 50.0,
              end: -500.0,
            ).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 10.0),
      ],
    ).animate(CurvedAnimation(parent: controller2, curve: Curves.easeOut));

    scaler = TweenSequence(
      <TweenSequenceItem<dynamic>>[
        TweenSequenceItem<dynamic>(
            tween: new Tween(begin: 0.0, end: 1.0).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 20.0),
        TweenSequenceItem<dynamic>(
            tween: new Tween(begin: 1.0, end: 0.0).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 20.0),
      ],
    ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.5)));
    scaler2 = TweenSequence(
      <TweenSequenceItem<dynamic>>[
        TweenSequenceItem<dynamic>(
            tween: new Tween(begin: 0.0, end: 1.0).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 20.0),
        TweenSequenceItem<dynamic>(
            tween: new Tween(begin: 1.0, end: 0.0).chain(CurveTween(
              curve: Curves.ease,
            )),
            weight: 20.0),
      ],
    ).animate(CurvedAnimation(parent: controller2, curve: Interval(0.2, 1.0)));

    _animContList.add(new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500)));
    _animContList.add(new AnimationController(
        vsync: this, duration: Duration(milliseconds: 900)));
    _animContList.add(new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300)));
    _animContList.add(new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1700)));

    _curvedAnimList.add(
        new CurvedAnimation(curve: Curves.easeOut, parent: _animContList[0]));
    _curvedAnimList.add(
        new CurvedAnimation(curve: Curves.easeOut, parent: _animContList[1]));
    _curvedAnimList.add(
        new CurvedAnimation(curve: Curves.easeOut, parent: _animContList[2]));
    _curvedAnimList.add(
        new CurvedAnimation(curve: Curves.easeOut, parent: _animContList[3]));

    _animationList.add(new Tween<double>(
      begin: 1000.0,
      end: 0.0,
    ).animate(_curvedAnimList[0]));
    _animationList.add(new Tween<double>(
      begin: 1000.0,
      end: 0.0,
    ).animate(_curvedAnimList[1]));
    _animationList.add(new Tween<double>(
      begin: 1000.0,
      end: 0.0,
    ).animate(_curvedAnimList[2]));
    _animationList.add(new Tween<double>(
      begin: 1000.0,
      end: 0.0,
    ).animate(_curvedAnimList[3]));

    _animContList.forEach((element) {
      element.forward();
    });
    controller.addStatusListener((status) {
      if (status.index == 3) {
        controller.forward();
      }
    });
    controller2.addStatusListener((status) {
      if (status.index == 3) {
        controller2.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animContList.forEach((element) {
      element.dispose();
    });
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            SizedBox(height: 0.14881*height),
            Padding(
              padding: EdgeInsets.only(right: 0.08333*width, left: 0.08333*width),
              child: Center(
                  child: Text(
                'SELECT YOUR PREFERRED LANGUAGE',
                style: TextStyle(
                    color: Colors.indigo.withOpacity(0.5),
                    fontSize: 25,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.left,
              )),
            ),
            Center(
              child: Stack(
                children: [
                  InkWell(
                    child: AnimatedBuilder(
                      animation: _animationList[0],
                      child: Container(
                        width: 0.833333*width,
                        height: 0.089286*height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(120, 78, 125, 1.0),
                              Colors.blueAccent,
                            ],
                          ),
                          color: Color.fromRGBO(120, 78, 125, 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                            child: Text(
                          'ENGLISH',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0),
                        )),
                      ),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_animationList[0].value, 50.0),
                          child: child,
                        );
                      },
                    ),
                    onTap: () {
                      _animContList.forEach((element) {
                        element.reverse();
                        new Timer.periodic(Duration(milliseconds: 1000),
                            (timer) {
                          timer.cancel();
                          setState(() {
                            _animatedBlue = 1000.0;
                          });
                        });
                      });
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationList[1],
                    child: Container(
                      width: 0.833333*width,
                      height: 0.089286*height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(120, 78, 125, 1.0),
                            Colors.blueAccent,
                          ],
                        ),
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                          child: Text(
                        'YORUBA',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0),
                      )),
                    ),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animationList[1].value, 120.0),
                        child: child,
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationList[2],
                    child: Container(
                      width: 0.83333*width,
                      height: 0.089286*height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(120, 78, 125, 1.0),
                            Colors.blueAccent,
                          ],
                        ),
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                          child: Text(
                        'IGBO',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0),
                      )),
                    ),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animationList[2].value, 190.0),
                        child: child,
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationList[3],
                    child: Container(
                      width: 0.83333*width,
                      height: 0.089286*height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(120, 78, 125, 1.0),
                            Colors.blueAccent,
                          ],
                        ),
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                          child: Text(
                        'HAUSA',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0),
                      )),
                    ),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animationList[3].value, 260.0),
                        child: child,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            onEnd: () {
              controller.forward().whenCompleteOrCancel(() {
                controller.repeat();
              });
            },
            curve: Curves.ease,
            duration: Duration(milliseconds: 1500),
            height: _animatedBlue,
            color: colorAnim,
            width: double.infinity,
            //child: IntroScreen(),
            child: AnimatedBuilder(
              builder: _buildAnimation,
              animation: controller,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.pinkAccent.withOpacity(0.3), Colors.blueAccent, Color.fromRGBO(120, 78, 125, 1.0)],
      )),
      child: Stack(
        children: [
          Opacity(
              opacity: scaler.value,
              child: Transform.translate(
                offset: Offset(movement.value, 100),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Image.asset(
                          'assets/images/intro_screen2_1.png',
                        ),
                        width: 0.833333*width,
                        height: 0.4464286*height,
                      ),
                      SizedBox(height: 0.03274*height),
                      Text(
                        'Report Crime Incidents on the Fly',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Opacity(
              opacity: scaler2.value,
              child: Transform.translate(
                offset: Offset(movement2.value, 100),
                child: Padding(
                  padding: const EdgeInsets.only(right: 0.0, left: 0.0),
                  child: Column(
                    children: [
                      SizedBox(
                          child:
                              Image.asset('assets/images/intro_screen2_2.png'),
                          height: 0.44643*width,
                          width: 0.83333*width),
                      SizedBox(height: 0.029762*height),
                      Text(
                        'Many of life failures are those who did not know how close they were to success when they gave up',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )),

          Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 10.5,
            child: SizedBox(
              height: 0.096726*height,
              width: 0.83333*width,
              child: RaisedButton(
                elevation: 1.0,
                color: Color.fromRGBO(120, 78, 125, 1.0),
                onPressed: () {

                },
                child: Text('Continue', style: TextStyle(color:Colors.white, fontSize: 20.0),),
                //shape: StadiumBorder(),

              ),
            ),
          ),

        ],
      ),
    );
  }
}
