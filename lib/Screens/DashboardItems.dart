import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetUser{
  String bearer;

  Future<String> getUser(String bearer) async {
    String url = Uri.encodeFull('https://www.geotiscm.org/api/user');
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $bearer",
      'Accept': 'application/json',
      'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA',
    });
    var jsonData = json.decode(response.body);
    var userTypeName = jsonData['data']['roles'][0]['pivot']['role_id'];
    return userTypeName.toString();
  }

  Future<int> approveReport(String bearer, int reportId) async {
    String url = Uri.encodeFull('https://www.geotiscm.org/api/reports/approval');
    var response = await http.post(url, headers: {
     //HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $bearer",
      'Accept': 'application/json',
      'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA',
    },body: {
      'report_id':reportId.toString(),
    });
    print(response.body);
    if(response.statusCode == 200){
      return response.statusCode;
    }else{
      return response.statusCode;
    }
  }

  Future<List<String>> getLoginUser(String bearer) async {
    String url = Uri.encodeFull('https://www.geotiscm.org/api/user');
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $bearer",
      'Accept': 'application/json',
      'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA',
    });
    List<String> listOfInfo = [];
    var jsonData = json.decode(response.body);
    var userTypeName = jsonData['data']['roles'][0]['pivot']['role_id'];
    String firstName = jsonData['data']['first_name'];
    String lastName = jsonData['data']['last_name'];
    String email = jsonData['data']['email'];
    String pictureUrl = jsonData['data']['picture_url'];
   listOfInfo.addAll({firstName, lastName, email,pictureUrl, userTypeName.toString()});
   return listOfInfo;
  }


}
