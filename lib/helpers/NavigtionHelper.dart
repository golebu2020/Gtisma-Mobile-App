import 'package:flutter/material.dart';


class NavigationHelper{
  navigateAnotherPage(BuildContext cont, Widget screen) {
    Navigator.pushReplacement(
        cont,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeOutQuad;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              child: child,
              position: animation.drive(tween),
            );
          },
          pageBuilder: (context, animation, animationTime) {
            return screen;
          },
        ));
  }
}