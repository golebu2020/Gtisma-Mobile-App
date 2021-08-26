import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieListFeed extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final Function initializeVideoPlayer;
  final UniqueKey myKey;

  ChewieListFeed(
      {Key key,
      this.videoPlayerController,
      this.looping,
      this.initializeVideoPlayer,
      this.myKey})
      : super(key: myKey);
  @override
  _ChewieListFeedState createState() => _ChewieListFeedState();
}

class _ChewieListFeedState extends State<ChewieListFeed> {
  ChewieController _chewieController;
  //bool _myOpacity;

  void initializeVideoPlayer() {
    initState();
  }

  @override
  void initState() {
    // TODO: implement initState
    //_myOpacity = true;
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      looping: false,
      showControls: true,
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
    //widget.videoPlayerController.dispose();
    //_chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
