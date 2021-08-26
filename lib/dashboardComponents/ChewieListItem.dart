import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:gtisma/helpers/UserPreferences.dart';

class ChewieListItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final Function initializeVideoPlayer;
  final UniqueKey urlKey;

  ChewieListItem(
      {Key key,
      this.videoPlayerController,
      this.looping,
      this.initializeVideoPlayer,
      this.urlKey})
      : super(key: urlKey);
  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController _chewieController;
  bool _myOpacity;
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  void initializeVideoPlayer() {
    initState();
  }

  @override
  void initState() {
    // TODO: implement initState
    _myOpacity = true;
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      looping: true,
      showControls: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child:
              Text('NO VIDEO\nCAPTURED', style: TextStyle(color: Colors.white)),
        );
      },

    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: 0.59524*height,
            width: 1.11111*width,
            child: Chewie(
              controller: _chewieController,
            ),
          ),
        ),
        Visibility(
          visible: _myOpacity,
          child: GestureDetector(
            onTap: () {
              widget.videoPlayerController.play();
              setState((){
                _myOpacity = false;
              });
            },
            child: Center(
              child: Opacity(
                opacity: 0.5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                    ),
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 80.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
