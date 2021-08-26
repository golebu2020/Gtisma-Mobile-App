import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportExperiment extends StatefulWidget {
  @override
  _ReportExperimentState createState() => _ReportExperimentState();
}

class _ReportExperimentState extends State<ReportExperiment> {
  var url = 'http://www.geotiscm.org/api/gender';
  var data; var len; List _listInfo=['Gender'];   var _currentItemSelected = 'Gender'; var myData = ['Gender'];

  void initState() {
    super.initState();
    this.fetchData();
  }

  Future<String> fetchData() async {
    var response = await http.get(Uri.encodeFull(url), headers: {'Accept':'application/json','clientId':'mobileclientpqqh6ebizhTecUpfb0qA'});
    print(response.body);
    var lp;List m;
    setState(() {
      data = jsonDecode(response.body);
      m = data["data"];
      lp = m.length;
    });
    //print(m[1].toString());
    for(int i=0; i<lp; i++){
      myData.add(m[i]['name'].toString());
    }
    debugPrint(myData.toString());

     // _listInfo.add(myData[i]['name'].toString());

    return "Success";
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ReportExperiment"),
      ),
      // body: Center(child: Text(data[0]['meter'].toString()),
      body: Center(
        child: DropdownButton<dynamic>(
          items: myData
              .map((dynamic dropDownStringItem) {
            return DropdownMenuItem<dynamic>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          onChanged: (dynamic newSelected) {
            debugPrint('Gender Selected');
            _dropDownSelectedaction(newSelected);
          },
          value: _currentItemSelected,
        ),
      ),
    );
  }
  void _dropDownSelectedaction(dynamic newSelect) {
    setState(() {
      this._currentItemSelected = newSelect;
    });
  }

}
