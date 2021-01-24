import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';






class SendReport extends StatefulWidget {
  final Function trigger;
  SendReport(this.trigger);
  @override
  _SendReportState createState() => _SendReportState();
}

class _SendReportState extends State<SendReport> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  void _getLocation() async{
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

    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      var latitude = _locationData.latitude;
      var longitude = _locationData.longitude;
      debugPrint(latitude.toString());
      debugPrint(longitude.toString());
    });
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
          padding: const EdgeInsets.all(50.0),
          child: Image.asset(
            'assets/images/intro_screen2_3.png',
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
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
}