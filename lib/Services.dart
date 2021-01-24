// import 'package:flutter/cupertino.dart';
// import 'package:gtisma/models/CrimeTypes.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
//
// class Services {
//   // _____________________________DOWNLOAD CRIME TYPES__________________________________
//
//   static const String crimeTypesUrl = 'https://www.geotiscm.org/api/crimetype';
//   static Future<List<Crime<Datum>>> getCrimeTypes() async {
//     final response = await http.get(Uri.encodeFull(crimeTypesUrl), headers: {
//       'Accept': 'application/json',
//       'clientId': 'mobileclientpqqh6ebizhTecUpfb0qA'
//     });
//
//     if (response.statusCode == 200) {
//       final List<Crime<Datum>> crimes = crimeFromJson(response.body)();
//
//     } else {
//       return List<Crime<Datum>>();
//     }
//   }
// }
