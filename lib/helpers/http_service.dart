import 'dart:convert';

import 'package:gtisma/helpers/post_model.dart';
import 'package:http/http.dart';

class HttpService {
  final String postUrl = "https://jsonplaceholder.typicode.com/posts";
  Future<List<Post>> getPost() async {
    Response res = await get(postUrl);

    if(res.statusCode == 200){
      List<dynamic> body = jsonDecode(res.body);
      List<Post> post = body.map((dynamic item) => Post.fromJson(item)).toList();
      return post;
    }else{
      throw "can't get post";

    }
  }
}
