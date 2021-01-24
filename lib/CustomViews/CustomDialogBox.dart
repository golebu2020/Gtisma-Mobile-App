import 'package:flutter/material.dart';


class CustomDialogBox{
  // void openCustomDialog(BuildContext context, String title, String content){
  //   PageRouteBuilder(
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionBuilder: (context, a1, a2, widget){
  //       var begin = Offset(1.0, 0.0);
  //       var end = Offset.zero;
  //       var curve = Curves.easeOutQuad;
  //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //       return SlideTransition(
  //         position: a1.drive(tween),
  //         child: Opacity(
  //           opacity: a1.value,
  //           child: AlertDialog(
  //             shape: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(2.0)),
  //             title: Text(title),
  //             content: Text(content),
  //             ),
  //           ),
  //         );
  //     },
  //     transitionDuration: Duration(milliseconds:200),
  //     barrierDismissible: true,
  //     barrierLabel: "",
  //     context: context,
  //       // ignore: missing_return
  //       pageBuilder: (context, animation, animationTime){
  //       },
  //   );
  // }

}