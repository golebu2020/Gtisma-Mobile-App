import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieListItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  ChewieListItem({Key key, @required this.videoPlayerController, this.looping}):super(key:key);
  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 1.5,
      autoInitialize: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text('errorMessage', style: TextStyle(color: Colors.white)),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(controller: _chewieController,),
    );
  }
}
