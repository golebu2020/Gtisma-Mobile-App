import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/components/shader_mask_icon.dart';
import 'package:video_player/video_player.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'dart:io';

class AudioGlassMorphs extends StatefulWidget {
  final dynamic child;
  AudioGlassMorphs({Key key, this.child,}):super(key: key);

  @override
  _AudioGlassMorphsState createState() => _AudioGlassMorphsState();
}

class _AudioGlassMorphsState extends State<AudioGlassMorphs> {
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();

  @override
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
                    width: 0.004167*width,
                    color: Colors.white.withOpacity(0.2),
                  )),
              child: widget.child != null?Center(child: ShaderMaskIcon(Icon(widget.child, color: Colors.white, size: 50.0,))):Text(''),
            ),
          ),
        ),
      ),
    );
  }
}
