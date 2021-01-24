import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/models/CrimeTypes.dart';
import 'package:gtisma/models/States.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class WriteReport extends StatelessWidget {
  Function trigger;
  Function nextPage;
  int nextPageIndex;
  WriteReport({Key key, this.trigger, this.nextPage}) : super(key: key);
  TextEditingController controller = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                  'WRITE YOUR REPORT',
                  style: GoogleFonts.fredokaOne(
                      color: Colors.white.withOpacity(0.7), fontSize: 15.0),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
            child: TextFormField(
              controller: controller,
              maxLines: 2,
              minLines: 2,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              style: GoogleFonts.robotoSlab(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(242, 242, 242, 0.1),
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Describe the crime incident',
                hintStyle: GoogleFonts.robotoSlab(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0),
                //labelText: 'Describe the crime incident',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: TextFormField(
              controller: locationController,
              maxLines: 2,
              minLines: 2,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              style: GoogleFonts.robotoSlab(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(242, 242, 242, 0.1),
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Location of incident',
                hintStyle: GoogleFonts.robotoSlab(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0),
                //labelText: 'Describe the crime incident',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: TextFormField(
              controller: addressController,
              maxLines: 2,
              minLines: 2,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              style: GoogleFonts.robotoSlab(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(242, 242, 242, 0.1),
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Provide an address or landmarks',
                hintStyle: GoogleFonts.robotoSlab(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0),
                //labelText: 'Describe the crime incident',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                  BorderSide(color: Color.fromRGBO(255, 255, 255, 0.0)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
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
                  onPressed: () => trigger(),
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
                    debugPrint('Fix me');
                    UserPreferences().saveReportDescription(controller.text);
                    UserPreferences().saveReportAddress(addressController.text);
                    UserPreferences().saveReportLocation(locationController.text);
                    nextPage(1);
                  },
                  child: Text(
                    'CONTINUE',
                    style: GoogleFonts.fredokaOne(
                        color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 15.0),
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}