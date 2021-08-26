import 'dart:convert';

//import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/CustomViews/CustomProgressBar.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:http/http.dart' as http;

import 'EyewitnessLogin.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';

SelectLanguage lang = SelectLanguage();

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Password',
      debugShowCheckedModeBanner: false,
      home: Content(),
    );
  }
}

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isVisible1 = false;
  bool isVisible2 = false;
  bool _isAbsorbing = false;
  bool _isVisible = false;
  String url = 'https://www.geotiscm.org/api/password/reset';
  String urlConfirm = 'https://www.geotiscm.org/api/password/update';
  PageController pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailController2 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController rePasswordController2 = TextEditingController();
  String reset = '';
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  dynamic nativeLanguage = "";
  void initState() {
    super.initState();
    nativeLanguage = UserPreferences().data;
    reset = lang.languagTester(nativeLanguage)[42].toUpperCase();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showNot(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showNot(message);
    }, onResume: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showNot(message);
    });
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettings = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void setAbsorb() {
    setState(() {
      _isAbsorbing = !_isAbsorbing;
    });
  }

  void setProgress() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void showNot(var message) {
    var notification = message['notification'];
    String title = notification['title'];
    String body = notification['body'];
    debugPrint(title);
    debugPrint(body);
    _showNotification(title.toString(), body.toString());
  }

  void _showNotification(String title, String otp) async {
    await _demoNotification(title, otp);
    //await _showBigTextNotification();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            ));
  }

  Future<dynamic> resetPassword(String email) async {
    setState(() {
      isVisible1 = !isVisible1;
    });
    _loginProgressVisible = true;
    _loginButtonVisible = false;
    var response = await http.post(Uri.encodeFull(url), headers: {
      'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA'
    }, body: {
      'email': email,
    });

    if (response.statusCode == 200) {
      debugPrint(json.decode(response.body).toString());
      //BuildContext context, String title, String desc
      showDialogBox("Please check an OTP has been sent to your email");
      setState(() {
        _loginProgressVisible = false;
        _loginButtonVisible = true;
        reset = (lang.languagTester(nativeLanguage)[44] +
                lang.languagTester(nativeLanguage)[42])
            .toUpperCase();
        isVisible1 = !isVisible1;
      });
    } else {
      var message = json.decode(response.body);
      showDialogBoxError(message['message']);
      debugPrint(message.toString());
      setState(() {
        _loginProgressVisible = false;
        _loginButtonVisible = true;
        isVisible1 = !isVisible1;
      });
    }
    return "Success";
  }

  Future<dynamic> confirmResetPassword() async {
    setState(() {
      isVisible2 = !isVisible2;
      _loginProgressVisible = true;
      _loginButtonVisible = false;
    });
    var response = await http.post(Uri.encodeFull(urlConfirm), headers: {
      'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA'
    }, body: {
      'email': emailController2.text,
      'otp': otpController2.text,
      'password': passwordController2.text,
      'password_confirmation': rePasswordController2.text,
    });
    var values = json.decode(response.body);
    var displayValue = '';
    if (response.statusCode == 200) {
      var fullData = json.decode(response.body).toString();
      debugPrint(fullData);
      setState(() {
        reset = (lang.languagTester(nativeLanguage)[44] +
                lang.languagTester(nativeLanguage)[42])
            .toUpperCase();
        _loginProgressVisible = false;
        _loginButtonVisible = true;
        isVisible2 = !isVisible2;
      });
      //goto Login Screen
      NavigationHelper().navigateAnotherPage(context, EyewitnessLoginStat());
    } else {
      setState(() {
        _loginProgressVisible = false;
        _loginButtonVisible = true;
      });

      print(values.toString());
      try {
        displayValue = (values['message']);
      } catch (e) {}
      try {
        displayValue =
            (values['errors']['password'][0] + values['errors']['password'][1])
                .toString();
      } catch (e) {}
      showDialogBoxError(displayValue);
    }

    // showDialogBoxError(json.decode(response.body)['message']);
    // debugPrint(json.decode(response.body).toString());
    setState(() {
      isVisible2 = !isVisible2;
    });
    return "Success";
  }

  Widget buttonRecover() {
    List<int> myIntList = [1, 2, 3];
    return Container(
      padding: EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
      height: 60.0,
      child: RaisedButton.icon(
        shape: StadiumBorder(),
        onPressed: () {
          if (emailController.text.isNotEmpty) {
            resetPassword(emailController.text);
          } else {
            showDialogBoxError("Please fill empty field");
          }
        },
        //splashColor: Color.fromRGBO(120, 78, 125, 1.0),
        icon: Icon(
          Icons.lock_open,
          color: Colors.white,
        ),
        label: Text(
          lang.languagTester(nativeLanguage)[40].toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
        color: Color.fromRGBO(120, 78, 125, 1.0),
      ),
    );
  }

  Widget buttonConfirm() {
    return RaisedButton.icon(
      shape: StadiumBorder(),
      onPressed: () {
        if (emailController2.text.isNotEmpty &&
            otpController2.text.isNotEmpty &&
            passwordController2.text.isNotEmpty &&
            rePasswordController2.text.isNotEmpty) {
          confirmResetPassword();
        } else {
          showDialogBoxError("Please fill empty fields");
        }
      },
      // splashColor: Color.fromRGBO(120, 78, 125, 1.0),
      icon: Icon(
        Icons.lock_open,
        color: Colors.white,
      ),
      label: Text(
        lang.languagTester(nativeLanguage)[44].toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      color: Color.fromRGBO(120, 78, 125, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    var fontDesign = GoogleFonts.fredokaOne(
        fontSize: 18.0, color: Color.fromRGBO(120, 78, 125, 1.0));
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EyewitnessLoginStat(),
          )),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            reset.toUpperCase(),
            style: fontDesign,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 0.0298 * (height / 5) * 10,
                  ),
                  Hero(
                    child: Container(
                        child: Image.asset("assets/images/splash_icon_3.jpg",
                            width: 120, height: 120)),
                    tag: "resetTag",
                  ),
                  SizedBox(
                    height: 0.0298 * height * 1 / 10,
                  ),
                  Container(
                    height: height * 0.7,
                    width: width,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 0.0149 * height * 2.5,
                                right: 25.0,
                                left: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 0.02232 * height * 5),
                                SizedBox(
                                  height: 0.0893 * height,
                                  width: 0.8333 * width,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 1,
                                    controller: emailController,
                                    style: GoogleFonts.robotoSlab(
                                        color: Colors.black, fontSize: 18.0),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(242, 242, 242, 1.0),
                                      contentPadding: EdgeInsets.only(
                                        left: 0.0278 * width,
                                        right: 0.0278 * width,
                                        top: 0.0595 * height,
                                      ),
                                      hintText: lang
                                          .languagTester(nativeLanguage)[17],
                                      // labelText: lang.languagTester(nativeLanguage)[17].toUpperCase(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color:
                                            Color.fromRGBO(120, 78, 125, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0.02232 * height * 0.6),
                                signupButton(lang
                                    .languagTester(nativeLanguage)[40]
                                    .toUpperCase()),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(right: 10.0, left: 10.0),
                            //margin: EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 0.0298 * (height / 5) * 10,
                                  ),
                                  SizedBox(
                                    height: 0.0893 * height,
                                    width: 0.8333 * width,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: emailController2,
                                      keyboardType: TextInputType.emailAddress,
                                      style: GoogleFonts.robotoSlab(
                                          color: Colors.black, fontSize: 18.0),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(242, 242, 242, 1.0),
                                        contentPadding: EdgeInsets.only(
                                          left: 0.0278 * width,
                                          right: 0.0278 * width,
                                          top: 0.0595 * height,
                                        ),
                                        hintText: lang
                                            .languagTester(nativeLanguage)[17],
                                        //labelText: lang.languagTester(nativeLanguage)[17].toUpperCase(),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color:
                                              Color.fromRGBO(120, 78, 125, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.02232 * height * 0.6),
                                  SizedBox(
                                    height: 0.0893 * height,
                                    width: 0.8333 * width,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: otpController2,
                                      style: GoogleFonts.robotoSlab(
                                          color: Colors.black, fontSize: 18.0),
                                      keyboardType:
                                      TextInputType.visiblePassword,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(242, 242, 242, 1.0),
                                        contentPadding: EdgeInsets.only(
                                          left: 0.0278 * width,
                                          right: 0.0278 * width,
                                          top: 0.0595 * height,
                                        ),
                                        hintText: lang
                                            .languagTester(nativeLanguage)[41],
                                        //labelText: lang.languagTester(nativeLanguage)[41].toUpperCase(),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.security_outlined,
                                          color:
                                              Color.fromRGBO(120, 78, 125, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.02232 * height * 0.6),
                                  SizedBox(
                                    height: 0.0893 * height,
                                    width: 0.8333 * width,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: passwordController2,
                                      style: GoogleFonts.robotoSlab(
                                          color: Colors.black, fontSize: 18.0),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(242, 242, 242, 1.0),
                                        contentPadding: EdgeInsets.only(
                                          left: 0.0278 * width,
                                          right: 0.0278 * width,
                                          top: 0.0595 * height,
                                        ),
                                        hintText: lang
                                            .languagTester(nativeLanguage)[20],
                                        // labelText: lang.languagTester(nativeLanguage)[20].toUpperCase(),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color:
                                              Color.fromRGBO(120, 78, 125, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.02232 * height * 0.6),
                                  SizedBox(
                                    height: 0.0893 * height,
                                    width: 0.8333 * width,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: rePasswordController2,
                                      style: GoogleFonts.robotoSlab(
                                          color: Colors.black, fontSize: 18.0),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(242, 242, 242, 1.0),
                                        contentPadding: EdgeInsets.only(
                                          left: 0.0278 * width,
                                          right: 0.0278 * width,
                                          top: 0.0595 * height,
                                        ),
                                        hintText: lang
                                            .languagTester(nativeLanguage)[21],
                                        //labelText:lang.languagTester(nativeLanguage)[21].toUpperCase(),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color:
                                              Color.fromRGBO(120, 78, 125, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.02232 * height * 0.6),
                                  signupButton(
                                    lang
                                        .languagTester(nativeLanguage)[44]
                                        .toUpperCase(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialogBox(String errorMessage) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ForgotPassword"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn);
                },
              ),
            ],
          );
        });
  }

  showDialogBoxError(String errorMessage) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Forogot Password"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // pageController.animateToPage(1,
                  //     duration: Duration(milliseconds: 2000),
                  //     curve: Curves.fastLinearToSlowEaseIn);
                },
              ),
            ],
          );
        });
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
  }

  Future<void> _demoNotification(String title, String otp) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "channel_ID", 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'text ticker');
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, otp, platformChannelSpecifics,
        payload:
            'GTISMA ' + lang.languagTester(nativeLanguage)[41].toUpperCase());
  }

  showMyDialog(BuildContext context, String title, String desc) {
    // AwesomeDialog(
    //   context: context,
    //   animType: AnimType.SCALE,
    //   dialogType: DialogType.ERROR,
    //   // body: Center(child: Text(
    //   //   'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
    //   //   style: TextStyle(fontStyle: FontStyle.italic),
    //   // ),),
    //   title: title,
    //   desc: desc,
    //   btnOkOnPress: () {
    //     Navigator.of(context).pop();
    //   },
    // )..show();
  }

  bool _loginProgressVisible = false;
  bool _loginButtonVisible = true;
  Widget signupButton(String disp) {
    var fontDesign =
        GoogleFonts.fredokaOne(color: Colors.white, fontSize: 15.0);
    return AbsorbPointer(
      absorbing: _isAbsorbing,
      child: Container(
        height: 0.0893 * height,
        width: 0.8333 * width,
        margin: EdgeInsets.only(top: 0.0149 * height * 1.0),
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            if (disp == lang.languagTester(nativeLanguage)[40].toUpperCase()) {
              if (emailController.text.isNotEmpty) {
                resetPassword(emailController.text);
              } else {
                showDialogBoxError("Please fill empty field");
              }
            } else {
              if (emailController2.text.isNotEmpty &&
                  otpController2.text.isNotEmpty &&
                  passwordController2.text.isNotEmpty &&
                  rePasswordController2.text.isNotEmpty) {
                confirmResetPassword();
              } else {
                showDialogBoxError("Please fill empty fields");
              }
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: _loginButtonVisible,
                child: Text(
                  disp.toUpperCase(),
                  style: GoogleFonts.fredokaOne(
                      color: Colors.white, fontSize: 15.0),
                ),
              ),
              Visibility(
                visible: _loginProgressVisible,
                // visible: true,
                child: SizedBox(
                  height: (50 / 1.5),
                  width: (50 / 1.5),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black45.withOpacity(0.3)),
                    backgroundColor: Colors.white,
                    strokeWidth: 7,
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(120, 78, 125, 1.0),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  // Future<bool> _backPressed() {
  //   var fontDesign = GoogleFonts.fredokaOne(
  //       color: Colors.white, fontSize: 15.0);
  //   return showDialog(
  //     context: context,
  //     builder: (context) => Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: new AlertDialog(
  //         title: new Text('Are you sure?'),
  //         content: new Text('Do you want to exit an App'),
  //         backgroundColor:Colors.white,
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("NO", style: fontDesign),
  //             onPressed: () => Navigator.of(context).pop(false),
  //             color: Colors.blueAccent,
  //             shape: StadiumBorder(),
  //           ),
  //
  //           FlatButton(
  //             child: Text("YES",style: fontDesign),
  //             onPressed: () => Navigator.of(context).pop(true),
  //             color: Colors.blueAccent,
  //             shape: StadiumBorder(),
  //           ),
  //           // new GestureDetector(
  //           //   onTap: () => Navigator.of(context).pop(true),
  //           //   child: Text("YES"),
  //           // ),
  //         ],
  //       ),
  //     ),
  //   ) ??
  //       false;
  // }
}
