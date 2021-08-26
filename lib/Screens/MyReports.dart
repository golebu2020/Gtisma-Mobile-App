import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:gtisma/helpers/http_service.dart';
import 'package:gtisma/helpers/post_model.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'EyewitnessLogin.dart';

class MyReports extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'My Reports',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(120, 78, 125, 1.0),
            centerTitle: true,
            title: Text("Posts"),
          ),
          body: FutureBuilder(
            future: httpService.getPost(),
            // ignore: missing_return
            builder:
                (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
              if (snapshot.hasData) {
                List<Post> posts = snapshot.data;
                return ListView(
                  children: posts
                      .map((Post post) => ListTile(title: Text(post.title), subtitle: Text(post.id.toString()),))
                      .toList(),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

}
