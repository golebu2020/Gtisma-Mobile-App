import 'package:flutter/material.dart';

@immutable
class Message {
  final String title;
  final String body;

  Message({
    @required this.title,
    @required this.body});
}
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:animate_do/animate_do.dart';
// import 'package:floating_action_bubble/floating_action_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:simple_timer/simple_timer.dart';
// import 'package:animate_icons/animate_icons.dart';
// import 'dart:math';
//
//
//
// typedef _Fn = void Function();
//
// class SimpleRecorderHome extends StatelessWidget {
//   SimpleRecorderHome({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SimpleRecorder(),
//     );
//   }
// }
//
//
// class SimpleRecorder extends StatefulWidget {
//   @override
//   _SimpleRecorderState createState() => _SimpleRecorderState();
// }
//
// class _SimpleRecorderState extends State<SimpleRecorder> with TickerProviderStateMixin {
//   TimerController _timerController;
//   FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
//   bool _mPlayerIsInited = false;
//   bool _mRecorderIsInited = false;
//   bool _mplaybackReady = false;
//   String _mPath;
//   String recordStatus;
//
//   Animation<double> _animation;
//   AnimationController _animationController;
//   AnimateIconController controller;
//
//   @override
//   void initState() {
//     // Be careful : openAudioSession return a Future.
//     // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
//     _mPlayer.openAudioSession().then((value) {
//       setState(() {
//         _mPlayerIsInited = true;
//       });
//     });
//     openTheRecorder().then((value) {
//       setState(() {
//         _mRecorderIsInited = true;
//       });
//     });
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 260),
//     );
//
//     final curvedAnimation =
//     CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
//     _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
//     _timerController = TimerController(this);
//     controller = AnimateIconController();
//
//     recordStatus = 'RECORD';
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     stopPlayer();
//     _mPlayer.closeAudioSession();
//     _mPlayer = null;
//
//     stopRecorder();
//     _mRecorder.closeAudioSession();
//     _mRecorder = null;
//     if (_mPath != null) {
//       var outputFile = File(_mPath);
//       if (outputFile.existsSync()) {
//         outputFile.delete();
//       }
//     }
//
//     //_animationController.dispose();
//     super.dispose();
//   }
//
//   //-----------------------Opening the Recorder Here----------------------------
//
//   Future<void> openTheRecorder() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone permission not granted');
//     }
//
//     //Generating Random numbers here
//     List list = List.generate(16, (i) => i);
//     list.shuffle();
//
//     int firstRandonNum = list[0];
//     int secondRandonNum = list[1];
//
//
//     var tempDir = await getTemporaryDirectory();
//     _mPath = '${tempDir.path}/gtisma_recorder_firstRandom.aac';
//     var outputFile = File(_mPath);
//     if (outputFile.existsSync()) {
//       await outputFile.delete();
//     }
//     await _mRecorder.openAudioSession();
//     _mRecorderIsInited = true;
//   }
//
//   // ----------------------  Here is the code for recording and playback -------
//
//   Future<void> record() async {
//     assert(_mRecorderIsInited && _mPlayer.isStopped);
//     await _mRecorder.startRecorder(
//       toFile: _mPath,
//       codec: Codec.aacADTS,
//       //codec: Codec.aacADTS,
//     );
//     setState(() {});
//   }
//
//   Future<void> stopRecorder() async {
//     await _mRecorder.stopRecorder();
//     _mplaybackReady = true;
//   }
//
//   void play() async {
//     assert(_mPlayerIsInited && _mplaybackReady && _mRecorder.isStopped && _mPlayer.isStopped);
//     await _mPlayer.startPlayer(fromURI: _mPath, codec: Codec.aacADTS, whenFinished: () {
//       setState(() {
//
//       });
//     });
//     setState(() {
//
//     });
//   }
//
//   Future<void> stopPlayer() async {
//
//     await _mPlayer.stopPlayer();
//   }
//
// // ----------------------------- UI --------------------------------------------
//
//   _Fn getRecorderFn() {
//     if (!_mRecorderIsInited || !_mPlayer.isStopped) {
//       return null;
//     }
//     return _mRecorder.isStopped
//         ? record
//         : () {
//       stopRecorder().then((value) => setState(() {}));
//     };
//   }
//
//   _Fn getPlaybackFn() {
//     if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
//       return null;
//     }
//     return _mPlayer.isStopped
//         ? play
//         : () {
//       stopPlayer().then((value) => setState(() {}));
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionBubble(
//         herotag: "Btn2",
//         // Menu items
//         items: <Bubble>[
//           // Floating action menu item
//           Bubble(
//             title: recordStatus,
//             iconColor: Colors.white,
//             bubbleColor: Color.fromRGBO(130, 100, 180, 1.0),
//             icon: Icons.mic,
//             titleStyle: GoogleFonts.fredokaOne(
//                 color: Colors.white, fontSize: 13.0),
//             onPress: () {
//               setState(() {
//                 recordStatus = 'STOP';
//               });
//               //getRecorderFn();
//               _timerController.start();
//             },
//           ),
//
//           Bubble(
//             title: "SUBMIT",
//             iconColor: Colors.white,
//             bubbleColor: Color.fromRGBO(120, 78, 150, 1.0),
//             icon: Icons.done,
//             titleStyle: GoogleFonts.fredokaOne(
//                 color: Colors.white, fontSize: 13.0),
//             onPress: () async {
//
//             },
//           ),
//         ],
//
//         // animation controller
//         animation: _animation,
//
//         // On pressed change animation state
//         onPress: _animationController.isCompleted
//             ? _animationController.reverse
//             : _animationController.forward,
//
//         // Floating Action button Icon color
//         iconColor: Colors.blue,
//         animatedIconData: AnimatedIcons.add_event,
//         // Flaoting Action button Icon
//         backGroundColor: Color.fromRGBO(120, 78, 125, 1.0),
//       ),
//       backgroundColor: Colors.white,
//       body: getContainer(),
//     );
//   }
//
//   Widget returnStackDesign(){
//     return Stack(
//       children: [
//         Container(
//           height: 280.0,
//           padding: EdgeInsets.all(10.0),
//           margin: EdgeInsets.only(top: 40.0),
//           child: Card(
//             elevation: 0.0,
//             shape: StadiumBorder(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
//                   alignment: Alignment.center,
//                   width: double.infinity,
//                   height: 150.0,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [Color.fromRGBO(120, 78, 125, 1.0), Color.fromRGBO(41,78,149,1.0)],
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topLeft: const Radius.circular(20.0),
//                       topRight: const Radius.circular(20.0),
//                       bottomLeft: const Radius.circular(20.0),
//                       bottomRight: const Radius.circular(20.0),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 150,
//                         height: 150,
//                         child: SimpleTimer(
//                           status: null,
//                           onEnd: (){
//                             getRecorderFn();
//
//                           },
//                           strokeWidth: 2.0,
//                           progressIndicatorColor: Colors.white,
//                           progressTextStyle: GoogleFonts.fredokaOne(
//                               color: Colors.white, fontSize: 30.0),
//                           backgroundColor: Color.fromRGBO(120, 78, 125, 1.0),
//                           controller: _timerController,
//                           duration: Duration(seconds: 20),
//                         ),
//                       ),
//                       Visibility(visible: true,child: Expanded(child: Lottie.asset('assets/images/green_sound.json',fit: BoxFit.fill, height: 50.0))),
//                     ],
//                   ),
//                 ),
//                 getPlayBackTiles(),
//               ],
//             ),
//           ),
//         ),
//
//       ],
//     );
//   }
//
//   Widget getContainer(){
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.all(3),
//           padding: const EdgeInsets.all(3),
//           height: 80,
//           width: double.infinity,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Color(0xFFFAF0E6),
//             border: Border.all(
//               color: Colors.indigo,
//               width: 3,
//             ),
//           ),
//           child: Row(children: [
//             RaisedButton(
//               onPressed: getRecorderFn(),
//               color: Colors.white,
//               disabledColor: Colors.grey,
//               child: Text(_mRecorder.isRecording ? 'Stop' : 'Record'),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Text(_mRecorder.isRecording
//                 ? 'Recording in progress'
//                 : 'Recorder is stopped'),
//           ]),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 10, right: 3, left: 3),
//           padding: const EdgeInsets.all(3),
//           height: 80,
//           width: double.infinity,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Color(0xFFFAF0E6),
//             border: Border.all(
//               color: Colors.indigo,
//               width: 3,
//             ),
//           ),
//           child: Row(children: [
//             RaisedButton(
//               onPressed: getPlaybackFn(),
//               color: Colors.white,
//               disabledColor: Colors.grey,
//               child: Text(_mPlayer.isPlaying ? 'Stop' : 'Play'),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Text(_mPlayer.isPlaying
//                 ? 'Playback in progress'
//                 : 'Player is stopped'),
//           ]),
//         ),
//       ],
//     );
//
//   }
//
//   Widget getPlayBackTiles(){
//     return Padding(
//       padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 20.0),
//       child: Card(
//         elevation: 15.0,
//         shadowColor: Colors.pinkAccent,
//         color: Colors.white,
//         shape: StadiumBorder(),
//         child: Row(
//           children: [
//             AnimateIcons(
//               startIcon: Icons.play_circle_fill,
//               endIcon: Icons.stop_circle_rounded,
//               size: 30.0,
//               controller: controller,
//               // add this tooltip for the start icon
//               startTooltip: 'Icons.add_circle',
//               // add this tooltip for the end icon
//               endTooltip: 'Icons.add_circle_outline',
//               onEndIconPress: () {
//
//                 return true;
//               },
//               onStartIconPress: () {
//                 getPlaybackFn();
//                 if (controller.isStart()) {
//
//                   controller.animateToEnd();
//                   //
//                 } else if (controller.isEnd()) {
//                   controller.animateToStart();
//                   // getPlaybackFn();
//                 }
//                 // _timerController.start();
//                 return true;
//               },
//               duration: Duration(milliseconds: 600),
//               clockwise: true,
//               color: Color.fromRGBO(120, 78, 125, 1.0),
//             ),
//             SizedBox(
//               width: 250.0,
//               height: 5.0,
//               child: LinearProgressIndicator(
//                 value: 0.7,
//                 backgroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// void startTimer() {
//   new Timer.periodic(
//     Duration(seconds: progressAnimationValue.toInt()),
//         (Timer timer) => setState(
//           () {
//         if (timerProgressValue == 1) {
//           timer.cancel();
//         } else {
//           setState(() {
//             timerProgressValue += 0.2;
//           });
//
//         }
//       },
//     ),
//   );
// }