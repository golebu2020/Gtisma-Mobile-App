import 'package:flutter/material.dart';
import 'package:gtisma/AnimatedComponents/AudioPage/Audios.dart';
import 'package:gtisma/AnimatedComponents/AudioRecoding.dart';
import 'package:gtisma/AnimatedComponents/VideoPage/Videos.dart';
import 'package:gtisma/CustomViews/custom_drawer.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/CustomViews/MyDrawer.dart';
import 'package:gtisma/dashboardComponents/MakeAPictureDashboard.dart';
import 'package:gtisma/dashboardComponents/MakeATextDashboard.dart';
import 'package:gtisma/dashboardComponents/MakeAVideoDashboard.dart';
import 'package:gtisma/dashboardComponents/MyReportsDashboard.dart';
import 'package:gtisma/dashboardComponents/SelectCrimeTypes.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'EyewitnessDashboard.dart';
import 'EyewitnessLogin.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:line_icons/line_icons.dart';
import 'package:gtisma/AnimatedComponents/PicturePage/Pictures.dart';
import 'dart:io';

SelectLanguage lang = SelectLanguage();
dynamic nativeLanguage = '';

class CustomDashboard extends StatefulWidget {
  //videoFile: savedVideo
  final File videoFile;
  final bool pageType;
  CustomDashboard({Key key, this.videoFile, this.pageType}) : super(key: key);

  @override
  CustomDashboardState createState() => CustomDashboardState();
}

class CustomDashboardState extends State<CustomDashboard> {
  //
  String selectedPageTitle;
  bool appBarState = false;
  Widget _widgetIndex;
  Widget w0;
  Widget w1;
  Widget w2;
  Widget w3;

  var lan = UserPreferences().data;

  void setAppBarState() {
    setState(() {
      appBarState = !appBarState;
    });
  }

  void setGlobalValue(int value) {
    setState(() {
      if (value == 0) {
        print('thank you for your cooperation');
        setState(() {
          w3 = VideoDetailing(key: UniqueKey(), videoFile: widget.videoFile);
          _widgetIndex = IndexedStack(index: 0, children: [w0, w1, w2, w3]);
          selectedPageTitle = lang.languagTester(lan)[35].toUpperCase();
        });
      }
      if (value == 1) {
        w3 = VideoDetailing(key: UniqueKey(), videoFile: widget.videoFile);
        print('thank you for your cooperation');
        _widgetIndex = IndexedStack(index: 1, children: [w0, w1, w2, w3]);
        selectedPageTitle = lang.languagTester(lan)[36].toUpperCase();
      }
      if (value == 2) {
        w3 = VideoDetailing(key: UniqueKey(), videoFile: widget.videoFile);
        _widgetIndex = IndexedStack(index: 2, children: [w0, w1, w2, w3]);
        //selectedPageTitle = lang.languagTester(lan)[35].toUpperCase();
        selectedPageTitle = 'Audio'.toUpperCase();
      }
      if (value == 3) {
        w3 = VideoDetailing(key: UniqueKey(), videoFile: widget.videoFile);
        _widgetIndex = IndexedStack(index: 3, children: [w0, w1, w2, w3]);
        //selectedPageTitle = lang.languagTester(lan)[35].toUpperCase();
        selectedPageTitle = lang.languagTester(lan)[37].toUpperCase();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.pageType == false) {
      w0 = EyewitnessDashboard(
        key: UniqueKey(),
      );
      w1 = PictureFrame(
        key: UniqueKey(),
      );
      w2 = SimpleRecorderHome(
        key: UniqueKey(),
      );
      w3 = VideoDetailing(key: UniqueKey(), videoFile: widget.videoFile);
      _widgetIndex = IndexedStack(index: 0, children: [w0, w1, w2, w3]);
      selectedPageTitle = lang.languagTester(lan)[35].toUpperCase();
    }
    if (widget.pageType == true) {
      w0 = EyewitnessDashboard(
        key: UniqueKey(),
      );
      w1 = PictureFrame(
        key: UniqueKey(),
      );
      w2 = SimpleRecorderHome(
        key: UniqueKey(),
      );
      w3 = VideoDetailing(key: UniqueKey(), videoFile: widget.videoFile);
      _widgetIndex = IndexedStack(index: 3, children: [w0, w1, w2, w3]);
      selectedPageTitle = lang.languagTester(lan)[37].toUpperCase();
    }
  }

  AppBar appBar;
  @override
  Widget build(BuildContext context) {
    var fontDesign = GoogleFonts.fredokaOne(
        color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 18.0);

    appBar = false
        ? AppBar()
        : AppBar(
            elevation: 1.0,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) {
                return IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Color.fromRGBO(120, 78, 125, 1.0),
                    ),
                    onPressed: () {
                      appBarState == false
                          ? CustomDrawer.of(context).open()
                          : CustomDrawer.of(context).close();
                    });
              },
            ),
            title: Text(
              selectedPageTitle,
              style: fontDesign,
            ),
          );
    Widget child1 = myDrawerPage();

    Widget child2 = CustomDrawer(
        child: child1,
        setGlobalValue: setGlobalValue,
        setAppBarState: setAppBarState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Eye witness Reports",
      home: child2,
    );
  }

  Widget myDrawerPage() {
    return Scaffold(
      appBar: appBar,
      //body: PictureFrame(),
      body: _widgetIndex,
    );
  }
}
