import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyReportDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Display(),
    );
  }
}

class Display extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  String crimeTypesUrl = 'https://www.geotiscm.org/api/crimetype';
  List<Data> newData = [];
  Future<List<Data>> _getCrimes() async {
    var response = await http.get(Uri.encodeFull(crimeTypesUrl), headers: {
      'Accept': 'application/json',
      'clientId': 'mobileclientpqqh6ebizhTecUpfb0qA'
    });
    var jsonData1 = json.decode(response.body);
    var jsonData2 = jsonData1['data'];
    debugPrint(jsonData2.toString());
    List<Data> datas = [];
    for (var u in jsonData2) {
      Data data = Data(u['id'], u['name'], u['createdAt'], u['updatedAt']);
      datas.add(data);
    }
    print(datas.toString());
    newData = datas;
    return datas;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCrimes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(

        itemCount: newData.length,
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (Orientation == Orientation.portrait) ? 2 : 3),
        itemBuilder: (context, index) {
          Data data = newData[index];
          return ListTile(
            title: Text(data.name),
            onTap: () async {},
          );
        },
      ),
    );
  }
}

class Data {
  int id;
  String name;
  String createdAt;
  String updatedAt;

  Data(this.id, this.name, this.createdAt, this.updatedAt);
}
