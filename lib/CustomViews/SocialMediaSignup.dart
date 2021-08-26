import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class SocialMediaSignup {
  var goSocial = Container(
    width: 300,
    height: 50,
    child: Row(
      children: [
        Icon(Icons.add, color: Colors.red),
        Icon(Icons.add, color: Colors.red),
      ],
    ),
  );

  var goLogin = Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 1,
                width: 100,
                color: Colors.black12,
              ),
              Text(
                'OR0',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
              Container(
                height: 1,
                width: 100,
                color: Colors.black12,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 70.0, left: 70.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: 35,
                  height: 35,
                  child: InkWell(
                      onTap: () async{
                        // debugPrint('Facebook Signup');
                        // final FacebookLogin facebookSignin = FacebookLogin();
                        // final result = await facebookSignin.logIn(['email']);
                        // final token = result.accessToken.token;
                        // final graphResponse = await http.get(
                        //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,email&access_token=$token');
                        // final profile = json.decode(graphResponse.body);
                        // print(profile.toString());
                      },
                      child: Image.asset('assets/myIcons/facebook_icon.png'))),
              Container(
                  width: 35,
                  height: 35,
                  child: InkWell(
                      child: Image.asset('assets/myIcons/instagram_icon.png'))),
              Container(
                  width: 35,
                  height: 35,
                  child: InkWell(
                      child: Image.asset('assets/myIcons/twitter_icon.png'))),
              Container(
                  width: 35,
                  height: 35,
                  child: InkWell(
                      child: Image.asset('assets/myIcons/gmail_icon.png'))),
            ],
          ),
        ),
      ],
    ),
  );
}
