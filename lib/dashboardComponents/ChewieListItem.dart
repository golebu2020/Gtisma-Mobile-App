import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
            height: 400,
            width: 400,
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
                  children: [
                    Container(
                      height: 80.0,
                      width: 80.0,
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
