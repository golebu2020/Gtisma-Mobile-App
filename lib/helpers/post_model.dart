import 'package:flutter/cupertino.dart';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    @required this.userId,
    @required this.id,
    @required this.title,
    @required this.body});

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      userId: json['userId'] as int,
      body: json['body'] as String,
      id: json['id'] as int,
      title: json['title'] as String,
    );

  }
}
