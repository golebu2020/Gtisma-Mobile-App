import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';

class DialogAwesome{

  showMyDialog(BuildContext context, String title, String desc){
    AwesomeDialog(

      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      // body: Center(child: Text(
      //   'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
      //   style: TextStyle(fontStyle: FontStyle.italic),
      // ),),
      title: title,
      desc:  desc,
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    )..show();
  }

}
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gtisma/CustomViews/MyDrawer.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:gtisma/helpers/UserPreferences.dart';
// import 'package:gtisma/helpers/GlobalVariables.dart';
//
// SelectLanguage lang = SelectLanguage();
// dynamic nativeLanguage = '';
//
// class MakeAPictureDashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Picture();
//   }
// }
//
// class Picture extends StatefulWidget {
//   @override
//   _PictureState createState() => _PictureState();
// }
//
// class _PictureState extends State<Picture> {
//   File _image;
//   final picker = ImagePicker();
//   final List<ChosenFiles> pictureList= [
//     ChosenFiles('assets/images/drawer_header.jpg'),
//     ChosenFiles('assets/images/drawer_header.jpg'),
//     ChosenFiles('assets/images/drawer_header.jpg'),
//   ];
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected');
//       }
//     });
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var fontDesign = GoogleFonts.robotoMono(
//         fontWeight: FontWeight.w900,
//         fontSize: 18.0,
//         color: Color.fromRGBO(120, 78, 125, 1.0));
//     var lan = UserPreferences().data;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           elevation: 2,
//           title: Text(
//             lang.languagTester(lan)[35].toUpperCase(),
//             style: fontDesign,
//           ),
//           centerTitle: true,
//           iconTheme: IconThemeData(color: Color.fromRGBO(120, 78, 125, 1.0)),
//           backgroundColor: Colors.white,
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.add_a_photo),
//           onPressed: getImage,
//           tooltip: 'Pick Image',
//         ),
//         body: Container(
//           padding: EdgeInsets.all(2.0),
//           child: Column(
//             children: [
//               ListView.builder(
//                 itemCount: pictureList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ImageInterfaceDesign(index,context);
//                 },
//               ),
//               Card(
//                 child: Container(
//                   padding: EdgeInsets.all(2.0),
//                   child: _image == null
//                       ? Image.asset(
//                     'assets/images/place_holder.png',
//                     height: 250,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   )
//                       : Image.file(
//                     _image,
//                     height: 250,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 elevation: 2.0,
//                 color: Colors.white,
//                 margin: EdgeInsets.all(10.0),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: Row(
//                   children: [
//                     RaisedButton(
//                       child: Text('ADD'),
//                       onPressed: () {
//                         setState(() {
//                           //pictureList.add(ChosenFiles(_image));
//                         });
//
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           //child: _image == null ? Text('No image selected') : Image.file(_image, height: 250, width: 250, fit: BoxFit.cover,),
//         ),
//         drawer: MyDrawer(),
//       ),
//     );
//   }
//
//   Widget ImageInterfaceDesign(int index, BuildContext context) {
//     final chosen = pictureList[index];
//     return new Container(
//         child: Card(
//           child: Image.asset(chosen.myfile, height: 100, width: 100),
//         )
//     );
//
//   }
// }
//
// class ChosenFiles{
//   final String myfile;
//
//   ChosenFiles(this.myfile);
// }

// ListView.builder(
// scrollDirection: Axis.horizontal,
// itemBuilder: (context, index) {
// if(pictureList.isEmpty){
// return Text('Loading...');
// }else{
// return ImageInterfaceDesign(index, context);
// }
// },
// itemCount: pictureList.length,
// ),