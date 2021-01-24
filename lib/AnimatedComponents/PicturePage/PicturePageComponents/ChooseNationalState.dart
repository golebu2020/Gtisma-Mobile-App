import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/models/States.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';


class ChooseNational extends StatefulWidget {
  final Function nextPage;
  final Function trigger;

  ChooseNational(this.trigger, this.nextPage);
  @override
  ChooseNationalState createState() => ChooseNationalState();
}

class ChooseNationalState extends State<ChooseNational> {
  List<bool> crimeTypeSelection = [];
  int lim;
  static const String crimeTypesUrl = 'https://www.geotiscm.org/api/state';
  Future<List<NationalState>> _getCrimes() async {
    final response = await http.get(Uri.encodeFull(crimeTypesUrl), headers: {
      'Accept': 'application/json',
      'clientId': 'mobileclientpqqh6ebizhTecUpfb0qA'
    });
    var jsonMe = json.decode(response.body);
    var jsonData = jsonMe['data'];
    List<NationalState> states = [];
    for (var u in jsonData) {
      NationalState state =
      NationalState(u['id'], u['name'], u['created_at'], u['updated_at']);
      states.add(state);
      crimeTypeSelection.add(false);
    }
    crimeTypeSelection = List<bool>.filled(states.length, false);
    print(states.length);
    print('Thanks');
    return states;
  }

  final ScrollController _scrollController =
  ScrollController(keepScrollOffset: true);
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
                'SELECT CURRENT STATE',
                style: GoogleFonts.fredokaOne(
                    color: Colors.white.withOpacity(0.7), fontSize: 15.0),
              ),
            )),
        Container(
          width: 300,
          height: 340,
          child: FutureBuilder(
            future: _getCrimes(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white.withOpacity(1),
                        strokeWidth: 2,

                      ),
                    ),
                  ),
                );
              } else {
                lim = snapshot.data.length;
                print(lim);
                return Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Divider(
                            color: Colors.white.withOpacity(0.05),
                            height: 1.0,
                          ),
                          CheckboxListTile(
                            value: crimeTypeSelection[index],
                            title: Text(
                              snapshot.data[index].name,
                              style: GoogleFonts.robotoSlab(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0),
                            ),
                            controlAffinity: ListTileControlAffinity.platform,
                            onChanged: (value) {
                              widget.nextPage(3);
                              UserPreferences().saveReportStateId(snapshot.data[index].id);
                              setState((){
                                int c = -1;
                                for (var i in crimeTypeSelection){
                                  c = c + 1;
                                  crimeTypeSelection[c] = false;
                                }
                                if (value == true) {
                                  HapticFeedback.lightImpact();
                                  crimeTypeSelection[index] = value;
                                }

                              });
                            },
                            activeColor: Colors.blueAccent,
                            checkColor: Colors.white,
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: Divider(
            height: 20,
            color: Colors.white.withOpacity(0.2),
          ),
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
                onPressed: widget.trigger,
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
                  widget.nextPage(3);
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
    );
  }
}