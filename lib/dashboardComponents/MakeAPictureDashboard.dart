import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';

SelectLanguage lang = SelectLanguage();
dynamic nativeLanguage = '';

class MakeAPictureDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Picture();
  }
}

class Picture extends StatefulWidget {
  @override
  _PictureState createState() => _PictureState();
}

class _PictureState extends State<Picture> with SingleTickerProviderStateMixin {
  bool addPicAnim;
  Animation<double> _animation;
  AnimationController _animationController;
  int pictureCounter;
  File _image;
  final picker = ImagePicker();
  List<ChosenFiles> pictureList;
  BuildContext context2;

  @override
  void initState() {
    pictureCounter = 0;
    addPicAnim = false;
    pictureList = [];
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context2 = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Builder(
            builder: (context) => Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 5.0),
                    Card(
                      elevation: 2.0,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: _image == null
                              ? Image.asset(
                            'assets/images/place_holder.png',
                            height: 250,
                            width: 250,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            _image,
                            height: 250,
                            width: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      color: Colors.white,
                    ),
                    Container(
                      height: 70,
                      child: ListView.builder(

                        scrollDirection: Axis.horizontal,
                        itemCount: pictureList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ImageInterfaceDesign(index, context);
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 278,
                  top: 3,
                  child: Bounce(
                   animate: addPicAnim,
                    child: Container(
                      height: 40,
                      width: 60,
                      child: RaisedButton(
                        child: Text(pictureCounter.toString(), style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        shape: StadiumBorder(),
                        elevation: 20,
                        onPressed: () {
                          debugPrint('Thank you');
                        },
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //drawer: MyDrawer(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          //Init Floating Action Bubble
          floatingActionButton: FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              // Floating action menu item
              Bubble(
                title: "Take a shot",
                iconColor: Colors.white,
                bubbleColor: Color.fromRGBO(120, 78, 125, 1.0),
                icon: Icons.camera,
                titleStyle: TextStyle(fontSize: 15, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  setState(() {
                    addPicAnim = !addPicAnim;
                    //pictureCounter ++;
                    getImage();

                  });
                },
              ),
              // Floating action menu item
              Bubble(
                title: "Add to thumbnail",
                iconColor: Colors.white,
                bubbleColor: Color.fromRGBO(120, 78, 125, 1.0),
                icon: Icons.add_to_photos,
                titleStyle: TextStyle(fontSize: 15, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  setState(() {
                    addPicAnim = !addPicAnim;
                    //pictureCounter ++;
                    if(pictureCounter <= 5){
                      if(_image != null){
                        pictureCounter++;
                        pictureList.add(ChosenFiles(_image));
                        _image = null;
                      }else{Scaffold.of(context2).showSnackBar(showMessage('My message','Error'));}
                    }else{debugPrint("You've reached the maximum allowable number of pictures");}

                  });
                },
              ),
              //Floating action menu item
              Bubble(
                title: "Submit",
                iconColor: Colors.white,
                bubbleColor:Color.fromRGBO(120, 78, 125, 1.0),
                icon: Icons.done,
                titleStyle: TextStyle(fontSize: 15, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                },
              ),
            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: _animationController.isCompleted
                ? _animationController.reverse
                : _animationController.forward,

            // Floating Action button Icon color
            iconColor: Colors.blue,
            animatedIconData: AnimatedIcons.add_event,
            // Flaoting Action button Icon
            backGroundColor: Color.fromRGBO(120, 78, 125, 1.0),
          )),
    );
  }

  Widget ImageInterfaceDesign(int index, BuildContext context) {
    final chosen = pictureList[index];
    return new Container(
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.file(chosen.myfile,
                height: 70, width: 70, fit: BoxFit.cover),
          ),
        ));
  }

  SnackBar showMessage(String message, String status){
    return SnackBar(
      content: Row(
        children: [
          status == 'Error'? Icon(Icons.error): Icon(Icons.done),
          SizedBox(width: 20,),
          Expanded(
            child:Text(message),
          ),
        ],
      ),

    );
  }


}

class ChosenFiles {
  final File myfile;

  ChosenFiles(this.myfile);
}
