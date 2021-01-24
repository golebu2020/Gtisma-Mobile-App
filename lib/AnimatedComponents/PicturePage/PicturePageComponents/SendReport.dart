import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Pictures.dart';

class SendReport extends StatefulWidget {
  Function trigger;
  Function nextPage;
  int nextPageIndex;
  Function retrieveJSON;
  SendReport({Key key, this.retrieveJSON, this.trigger, this.nextPage})
      : super(key: key);
  @override
  _SendReportState createState() => _SendReportState();
}

class _SendReportState extends State<SendReport> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String newBearer;

  @override
  void initState() {
    newBearer = UserPreferences().retrieveUserData();
    super.initState();
  }

  void _getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    var latitude = _locationData.latitude;
    var longitude = _locationData.longitude;
    debugPrint(latitude.toString());
    debugPrint(longitude.toString());

    String textLocation = UserPreferences().getReportLocation();
    UserPreferences().saveReportLocation(
        latitude.toString() + '-' + longitude.toString() + '_' + textLocation);
    String description = UserPreferences().getReportDescription();
    String address = UserPreferences().getReportAddress();
    String locationThings = UserPreferences().getReportLocation();
    int stateId = UserPreferences().getReportStateId();
    int crimeId = UserPreferences().getReportCrimeId();

    debugPrint(description);
    debugPrint(address);
    debugPrint(locationThings);
    debugPrint(stateId.toString());
    debugPrint(crimeId.toString());
    _sendReport(stateId, crimeId, description, locationThings, address);
  }

  _sendReport(stateId, crimeId, description, locationThings, address) async {
    widget.retrieveJSON();
    String reportFile = UserPreferences().getReportFile();
    debugPrint(reportFile);
    debugPrint(UserPreferences().retrieveUserData());
    sendTextReport(stateId.toString(), crimeId.toString(), description,
        locationThings, address, reportFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.1),
              borderRadius: BorderRadius.only(
                // topLeft: const Radius.circular(10.0),
                // topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(40.0),
                bottomRight: const Radius.circular(40.0),
              ),
            ),
            child: Center(
              child: Text(
                'SUBMIT REPORT',
                style: GoogleFonts.fredokaOne(
                    color: Colors.white.withOpacity(0.7), fontSize: 15.0),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(
              left: 50.0, right: 50, top: 50.0, bottom: 25),
          child: Image.asset(
            'assets/images/intro_screen2_3.png',
          ),
        ),
        FloatingActionButton(
          heroTag: Text('gotoNextPage'),
          backgroundColor: Colors.white,
          child: RotatedBox(
              quarterTurns: 270,
              child: Icon(Icons.arrow_forward_ios,
                  color: Color.fromRGBO(120, 78, 125, 1.0))),
          onPressed: () {
            debugPrint('Chinedu');
            widget.nextPage(0);
          },
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50.0,
              width: 150.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    bottomLeft: const Radius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  debugPrint('Chinedu');
                  widget.trigger();
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.fredokaOne(
                      color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 15.0),
                ),
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              height: 50.0,
              width: 150.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(30.0),
                    bottomRight: const Radius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  _getLocation();
                  //sendTextReport();
                },
                child: Text(
                  'SUBMIT',
                  style: GoogleFonts.fredokaOne(
                      color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 15.0),
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> sendTextReport(stateId, crimeId, description, locationThings,
      address, reportFile) async {
    debugPrint(newBearer);
    debugPrint(reportFile);
    var url = 'https://www.geotiscm.org/api/reports';
    debugPrint('beginning sending...');

    final msg = jsonEncode({
      'state_id': stateId.toString(),
      'crime_type_id': crimeId.toString(),
      'description': description,
      'location': locationThings,
      'address': address,
      'report_file': reportFile,
    });

    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $newBearer",
          'Accept': 'application/json',
          'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA',
        },
        body: msg);
    debugPrint(response.headers.toString());
    debugPrint(response.request.toString());
    debugPrint(response.toString());

    if (response.statusCode == 200) {
      debugPrint('Successfully Uploaded the report of the user');
      debugPrint(response.body);
    } else {
      debugPrint(
          'Unsuccessful in Uploading the result of the user or an Error occ');
      debugPrint(response.body);
    }
  }
}
