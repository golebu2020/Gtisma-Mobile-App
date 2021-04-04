import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/helpers/DeviceInformation.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/push_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:gtisma/helpers/GlobalVariables.dart';

import 'EyewitnessLogin.dart';

SelectLanguage lang = SelectLanguage();

class OTPVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fontDesign = GoogleFonts.robotoMono(
        fontWeight: FontWeight.w900, fontSize: 18.0, color: Color.fromRGBO(120, 78, 125, 1.0));
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Color.fromARGB(50, 20, 10, 10)),
    );
    return MaterialApp(
      title: 'First Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(lang.languagTester(UserPreferences().data)[28].toUpperCase(),style: fontDesign),
          centerTitle: true,
        ),
        body: OTPBody(),
      ),
    );
  }
}

class OTPBody extends StatefulWidget {
  @override
  _OTPBodyState createState() => _OTPBodyState();
}

class _OTPBodyState extends State<OTPBody> {
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
  dynamic email = "";
  var url = 'https://www.geotiscm.org/api/user/confirmotp';
  var url_resend_otp= 'https://www.geotiscm.org/api/user/resendotp';
  TextEditingController Controller1 = TextEditingController();
  TextEditingController Controller2 = TextEditingController();
  TextEditingController Controller3 = TextEditingController();
  TextEditingController Controller4 = TextEditingController();
  TextEditingController Controller5 = TextEditingController();
  TextEditingController Controller6 = TextEditingController();
  bool verify_state = false; bool resend_otp = false; bool absorb_verify = false; bool absorb_resend = false;
  void setVerifyState(){
    setState(() {
      verify_state = !verify_state;
      absorb_verify = !absorb_verify;
    });
  }

  void setResendOTP(){
    setState(() {
      resend_otp = !resend_otp;
      absorb_resend = !absorb_resend;
    });
  }

  void initState() {
    // TODO: implement initState
    email = UserPreferences().userEmail;
    debugPrint('This is the push notification message:');

    super.initState();

  }


  Future<dynamic> OTPVerify(String otp) async {
    setVerifyState();
    var response = await http.post(Uri.encodeFull(url), headers: {
      'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA'
    }, body: {
      'email': email,
      'otp': otp,

    });

    if (response.statusCode == 200) {
      var full = json.decode(response.body);
      String data = full['data'];
      debugPrint(data);
      setVerifyState();
      //UserPreferences().saveSpecific("token",data);
      UserPreferences().storeToken(true);
      Navigator.push(context, CupertinoPageRoute(builder:(context)=> EyewitnessLoginStat()));
    } else {
      showDialogBox("Unsuccessful! Please try later or check your network");
      debugPrint(json.decode(response.body).toString());
      setVerifyState();

    }
    return "Success";
  }
  Future<dynamic> resendOTP() async {
    setResendOTP();
    var response = await http.post(Uri.encodeFull(url_resend_otp), headers: {
      'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA'
    }, body: {
      'email': UserPreferences().getSpecific('email'),
      'last_name': UserPreferences().getSpecific('last_name'),
      'first_name': UserPreferences().getSpecific('first_name'),
      'phone': UserPreferences().getSpecific('phone'),
      'password': UserPreferences().getSpecific('password'),
      'password_confirmation': UserPreferences().getSpecific('password_confirmation'),
      'gender_id': UserPreferences().getSpecific('gender_id'),
    });

    if (response.statusCode == 200) {
      debugPrint(json.decode(response.body).toString());
      showDialogBox("Another OTP has been sent to your email. Please check.");
      setResendOTP();
    } else {
      showDialogBox("Unsuccessful! Please try later or check your network");
      debugPrint(json.decode(response.body).toString());
      setResendOTP();
    }
    return "Success";
  }

  Widget buttonContinue(BuildContext cont, String disp) {
    return Container(
      padding: EdgeInsets.only(right: 0.027778*width, left: 0.027778*width),
      child: RaisedButton.icon(
        //
        shape: StadiumBorder(),
        onPressed: () {
          //Verify OTP here
          String one = Controller1.text.toString();
          String two = Controller2.text.toString();
          String three = Controller3.text.toString();
          String four = Controller4.text.toString();
          String five = Controller5.text.toString();
          String six = Controller6.text.toString();
          String finalOtp = one + two + three + four + five + six;
          debugPrint(finalOtp);
          OTPVerify(finalOtp);
        },

        icon: Icon(
          Icons.lock,
          color: Colors.white,
        ),
        label: Text(
          disp,
          style: TextStyle(color: Colors.white),
        ),
        color:Color.fromRGBO(120, 78, 125, 1.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('assets/images/OTP_confirm.jpg'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              lang.languagTester(UserPreferences().data)[29] + ':',
              style: TextStyle(
                  fontFamily: 'Roboto-Regular.ttf',
                  fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, color: Color.fromRGBO(85, 133, 215, 1)),
              SizedBox(
                width: 0.027778*width,
              ),
              Center(
                  child: Text(
                email,
                style: TextStyle(
                    fontFamily: 'Roboto-Regular.ttf',
                    fontWeight: FontWeight.w800),
              )),
            ],
          ),
          SizedBox(
            height: 0.044643*height,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.11111*width, right:0.11111*width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 0.089286*height,
                  width: 0.11111*width,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    maxLength: 1,
                    textInputAction: TextInputAction.next,
                    controller: Controller1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 0.089286*height,
                  width: 0.11111*width,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    maxLength: 1,
                    textInputAction: TextInputAction.next,
                    controller: Controller2,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 0.089286*height,
                  width: 0.11111*width,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    maxLength: 1,
                    textInputAction: TextInputAction.next,
                    controller: Controller3,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 0.089286*height,
                  width: 0.11111*width,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    maxLength: 1,
                    textInputAction: TextInputAction.next,
                    controller: Controller4,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 0.089286*height,
                  width: 0.11111*width,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    maxLength: 1,
                    textInputAction: TextInputAction.next,
                    controller: Controller5,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 0.089286*height,
                  width: 0.11111*width,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    maxLength: 1,
                    textInputAction: TextInputAction.next,
                    controller: Controller6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AbsorbPointer(
            absorbing: absorb_verify,
            child: Container(
              child: buttonContinue(
                  context, lang.languagTester(UserPreferences().data)[30]),
              height: 0.074405*height,
              width: 0.83333*width,
              margin: EdgeInsets.only(top: 0.044643*height),
            ),
          ),
          Visibility(
            visible: verify_state,
            child: Container(
              width: 0.83333*width,
              height: 0.005952*height,
              child: LinearProgressIndicator(
              ),
            ),
          ),
          AbsorbPointer(
            absorbing: absorb_resend,
            child: Container(
              padding: EdgeInsets.only(right: 0.027778*width, left: 0.027778*width),
              child: RaisedButton(
                color: Colors.blueAccent,
                shape: StadiumBorder(),
                onPressed: () {
                  resendOTP();
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              height: 0.074405*height,
              width: 0.83333*width,
              margin: EdgeInsets.only(top: 0.0074405*height),
            ),
          ),
          Visibility(
            visible: resend_otp,
            child: Container(
              width: 0.83333*width,
              height: 0.0059524*height,
              child: LinearProgressIndicator(
              ),
            ),
          )
        ],
      ),
    );
  }

  showDialogBox(String errorMessage) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("User Activation"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


}
