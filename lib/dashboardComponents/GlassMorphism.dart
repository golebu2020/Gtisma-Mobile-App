import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  Icon icon;
  GlassMorphism(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 24,
                spreadRadius: 16,
                color: Colors.black.withOpacity(0.2),
              )
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 30.0,
                  sigmaY: 30.0,
                ),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(200.0),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.white.withOpacity(0.2),
                      )),
                  child: Center(
                    child: icon,
                      //child: Icon(Icons.videocam, color: Colors.white.withOpacity(0.5)),
                      )),
                ),
              ),
            ),
          ),

    );
  }
}