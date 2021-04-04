import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/components/shader_mask_icon.dart';
import 'package:video_player/video_player.dart';
import 'package:gtisma/helpers/UserPreferences.dart';

import 'dart:io';

class PictureGlassMorphs extends StatefulWidget {

  @override
  _PictureGlassMorphsState createState() => _PictureGlassMorphsState();
}

class _PictureGlassMorphsState extends State<PictureGlassMorphs> {
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  Widget build(BuildContext context) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              blurRadius: 24,
              spreadRadius: 16,
              color: Colors.black.withOpacity(0.2),
            )
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30.0,
                sigmaY: 30.0,
              ),
              child: Container(
                height: 0.3274*height,
                width: 0.91667*width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white.withOpacity(0.2),
                    )),
                child: Center(child: ShaderMaskIcon(Icon(Icons.photo_camera_rounded, color: Colors.white, size: 50.0,))),
              ),
            ),
          ),
        ),
      );
  }
}
