import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gtisma/CustomViews/SocialMediaSignup.dart';
import 'package:gtisma/Screens/ReportExperiment.dart';

class AdminLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ElevatedButton buttonContinue(BuildContext cont, bool value, String disp) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(120, 78, 125, 1.0),
          onPrimary: Colors.white,),
      onPressed: () {
        Navigator.push(
            cont,
            MaterialPageRoute(builder: (context) => ReportExperiment()));
      },
      child: Text(
        disp,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  SocialMediaSignup design = SocialMediaSignup();
  @override
  Widget build(BuildContext context) {
    var firstPage = Container(
      width: 320,
      child: Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Email',
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                prefixIcon: const Icon(Icons.email,
                    color: Colors.blueAccent),
              ),
            ),
          ),
          Container(
            height: 55,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Password',
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.lock,color: Colors.blueAccent),
                    // color: Color.fromARGB(200, 178, 199, 254)),
              ),
            ),
          ),
        ],
      ),
    );
    return MaterialApp(
      title: 'Admin Login',
      home: Scaffold(
          backgroundColor: Color.fromRGBO(253, 253, 254, 1.0),
          appBar: AppBar(
            title: Text('Admin Login'),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(120, 78, 125, 1.0),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'adminAnim',
                    child: Image.asset(
                      'assets/images/signup.png',
                      height: 250.0,
                      width: 250.0,
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Container(
                      width: 330,
                      height: 315,
                      child: Column(
                        children: [
                          firstPage,
                          Container(
                            width: 300,
                            height: 50,
                            margin: EdgeInsets.only(top: 20),
                            child: buttonContinue(context, false, 'Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
