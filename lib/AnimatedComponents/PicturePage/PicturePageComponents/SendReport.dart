import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/Screens/CustomDashboard.dart';
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
  bool isSendingVisible;
  @override
  void initState() {
    newBearer = UserPreferences().retrieveUserData();
    isSendingVisible = false;
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
    debugPrint('Good things to come');
    widget.retrieveJSON();
    String reportFile = UserPreferences().getReportFile();
    debugPrint('Debuggin Chineed');
    debugPrint(reportFile);
    debugPrint(UserPreferences().retrieveUserData());
    debugPrint(reportFile);

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
                elevation: 0.0,
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
            GestureDetector(
              onTap: () {
                setState(() {
                  isSendingVisible = true;
                });
                _getLocation();
              },
              child: Container(
                height: 50.0,
                width: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Visibility(
                      visible: !isSendingVisible,
                      child: Center(
                        child: Text(
                          'SUBMIT',
                          style: GoogleFonts.fredokaOne(
                              color: Color.fromRGBO(120, 78, 125, 1.0),
                              fontSize: 15.0),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isSendingVisible,
                      child: Center(
                        child: SizedBox(
                          width: 25.0,
                          height: 25.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.purple),
                            backgroundColor: Colors.blueAccent,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
      showAudioSnackBar(
          'Successfully Uploaded the report of the user', Colors.blueAccent);
      debugPrint(response.body);
      UserPreferences().saveReportFile('');
      widget.trigger();
      setState(() {
        isSendingVisible = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CustomDashboard(pageType: false);
      },));
    } else {
      debugPrint(
          'Unsuccessful in Uploading the result of the user or an Error occ');

      var jsonData = json.decode(response.body);
      dynamic resultAddress = " ";
      dynamic resultDescription = " ";
      // var data = jsonData['data'];
      resultAddress = jsonData['errors']['address'][0];
      resultDescription = jsonData['errors']['description'][0];
      showAudioSnackBar(resultAddress.toString() + " " + resultDescription.toString(), Colors.redAccent);
      debugPrint(jsonData.toString());
      widget.trigger();
      setState(() {
        isSendingVisible = false;
      });
    }
  }

  void showAudioSnackBar(String message, Color color) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
