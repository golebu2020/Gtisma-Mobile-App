import 'package:flutter/material.dart';


// ignore: must_be_immutable
class ProgressButton{
  Widget progressButton(BuildContext context, bool value, String disp) {
    return Container(
      width: 300,
      height: 60,
      child: Column(
        children: [
          Container(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(120, 78, 125, 1.0),
                onPrimary: Colors.white,
              ),
            ),
          ),
          Container(height: 10, child: LinearProgressIndicator()),
        ],
      ),
    );
  }

  // ElevatedButton buttonContinue(BuildContext cont, bool value, String disp) {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //         primary: Color.fromRGBO(120, 78, 125, 1.0),
  //         onPrimary: Colors.white,
  //         elevation: 0.0),
  //     onPressed: () {
  //       setState(() {
  //         loginData(emailController.text.toString(),
  //             passwordController.text.toString());
  //       });
  //       // Navigator.push(
  //       //     cont,
  //       //     MaterialPageRoute(builder: (context) => PostsPage()));
  //     },
  //     child: Text(
  //       disp,
  //       style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
  //     ),
  //   );
  // }

}
