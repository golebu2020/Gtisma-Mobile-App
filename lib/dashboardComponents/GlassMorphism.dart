import 'dart:ui';
import 'package:gtisma/helpers/UserPreferences.dart';

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  Icon icon;
  GlassMorphism(this.icon);
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();

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
                  height: 0.08185*height,
                  width: 0.08185*height,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(200.0),
                      border: Border.all(
                        width: 0.004167*width,
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