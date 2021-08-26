import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/components/shader_mask_icon.dart';
import 'package:video_player/video_player.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'ChewieListItem.dart';

import 'dart:io';




class VideoGlassMorphs extends StatefulWidget {
  final File file;
  VideoGlassMorphs({Key key, this.file}) : super(key: key);

  @override
  _VideoGlassMorphsState createState() => _VideoGlassMorphsState();
}

class _VideoGlassMorphsState extends State<VideoGlassMorphs> {
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  @override
  Widget build(BuildContext context) {
    if(widget.file != null){
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
            borderRadius: BorderRadius.circular(5.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30.0,
                sigmaY: 30.0,
              ),
              child: Container(
                height: 0.47619*height,
                width: 0.88889*width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 0.0041667*width,
                      color: Colors.white.withOpacity(0.2),
                    )),
                child: Center(
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: ChewieListItem(videoPlayerController: VideoPlayerController.file(widget.file), looping: true, urlKey: UniqueKey()),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    else{
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
            borderRadius: BorderRadius.circular(5.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30.0,
                sigmaY: 30.0,
              ),
              child: Container(
                height: 0.47619*height,
                width: 0.888889*width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 0.0041667*width,
                      color: Colors.white.withOpacity(0.2),
                    )),
                child: Center(child: ShaderMaskIcon(Icon(Icons.videocam, color: Colors.white, size: 50.0,))),
              ),
            ),
          ),
        ),
      );
    }

  }
}
