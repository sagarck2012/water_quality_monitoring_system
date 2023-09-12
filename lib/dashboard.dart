import 'package:flutter/material.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:water_quality_monitoring_system/CommonWidget/dashboardTable.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/authUtlity.dart';
import 'package:water_quality_monitoring_system/deviceManagement.dart';
import 'package:water_quality_monitoring_system/login.dart';

import 'package:water_quality_monitoring_system/pond_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;




class Dashboard extends StatefulWidget {
  final String token;
  final String ID;

  const Dashboard({Key? key, required this.token, required this.ID})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState(token: token, ID: ID);
}


// --------------------------------
class _DashboardState extends State<Dashboard> {
  final String? token;
  final String? ID;

  _DashboardState({
    required this.token,
    required this.ID,
  });

// Obtain shared preferences.


  List<Map<String, dynamic>> dropdownItems = [
  ];

  List<String> options = [];
  bool availablePondData = false;
  int passRow = 10;
  bool refresh = false;

  // String? selectedOption ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPondData();
  }

  // -----------------------------------------       Pond List Function               ----------------------------------------


  List<Map<String, dynamic>> getAllPond = [];

  Future<void> fetchPondData() async {
    try {
      final response = await http.get(
        Uri.parse('http://182.163.112.102:8007/api/pond/list/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print("??????????? >>>>>>>>>>>>> ????????????");
        final jsonData = json.decode(response.body);
        setState(() {
          if (refresh) {
            getAllPond.clear();
            options.clear();
            dropdownItems.clear();
          }
          getAllPond = List<Map<String, dynamic>>.from(jsonData['data']);

          for (int i = 0; i < getAllPond.length; i++) {
            final pond = getAllPond[i];
            print(pond["id"]);
            print(pond["name"]);
            options.add(pond["id"].toString());
            dropdownItems.add(
                {'name': pond["name"], 'value': pond["id"].toString()});
          }

          print("@@@@@@@@@@ $dropdownItems");
          print("|||||||||||||||| $options");
          if(options.isEmpty){
            isLoading = false;
            return;
          }
          print(dropdownItems[0]);
          select.selectedOption = options.isNotEmpty ? options[0] : null;

          if (select.selectedOption != null) {
            print("STEP ------------------   1");
            fetchData(widget.token);
            print("STEP ------------------   3");
          }
          else {
            print("************* HOILO TA KI ***********");
            CustomSnackBar.show(context, "KI jani Somossa");
          }
        });
      }
      else if(response.statusCode == 401){
        AuthUtility.clearUserInfo();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);
      }
      else {
        print('Failed to fetch pond data');
      }
    }
    catch (error) {
      print("DashBoard $error");
    }
  }


  // ----------------------------------------------     Table data Function  -------------------------

  bool isLoading = true;
  List<dynamic> doValues = [];

  List<dynamic> phValues = [];

  List<dynamic> tempValues = [];
  List<dynamic> data_time = [];
  String Location = "";

  Future<void> fetchData(String token) async {
    print("Device ------------${select.selectedOption}");
    try {
      final response = await http.get(
        Uri.parse(
            'http://182.163.112.102:8007/api/devices/data/pond/last-ten-data/${select
                .selectedOption}/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {

        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> data = responseData['data'];


// -----------------------  DO  ---------  PH ---------- Temp  ----------------------

        List<dynamic> extractedPhValues = ListDataMethod(data, "PH", "value");
        List<dynamic> extractedDOValues = ListDataMethod(data, "DO", "value");
        List<dynamic> extractedTempValues = ListDataMethod(
            data, "Temp", "value");
        List<dynamic> extractedDateTimeValues = ListDataMethod(
            data, "PH", "data_time");

        setState(() {

          doValues = extractedDOValues;
          phValues = extractedPhValues;
          tempValues = extractedTempValues;
          data_time = extractedDateTimeValues;
          Location = data["pond"]["name"];
          if (doValues.isEmpty) {
            availablePondData = false;
            doValues = [
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0"
            ];
          }
          if (phValues.isEmpty) {
            availablePondData = false;
            phValues = [
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0"
            ];
          }
          else {
            if (phValues.length < 10) {
              passRow = phValues.length;
            }
            else {
              passRow = 10;
            }
            isLoading = false;
            availablePondData = true;
            print("Row I will pass : $passRow");
          }
          if (tempValues.isEmpty) {
            availablePondData = false;
            tempValues = [
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0",
              "0.0"
            ];
          }
          if (data_time.isEmpty) {
            availablePondData = false;
            data_time = [
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
              "0000-00-00T00:00:00Z",
            ];
          }
          isLoading = false;
        });
      } else {
        CustomSnackBar.show(context, 'Api NOT Hit');
      }
    }
    catch (error) {
      CustomSnackBar.show(context, "$error");
    }
  }

  List<dynamic> ListDataMethod(Map<String, dynamic> data, String columnName,
      String whatValueIWant) {
    final List<dynamic> tempList = data['$columnName'];
    final List<dynamic> extractedValues = tempList.map<dynamic>((entry) {
      return entry['$whatValueIWant'];
    }).toList();
    return extractedValues;
  }


  static const List<String> menuItems = ['Profile', 'Logout'];
  String selectedMenuItem = menuItems[0];
  // ----------------------------- -    UI  -------------------------------------

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return  Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  selectedMenuItem = value;
                  if(value=="Logout"){
                    AuthUtility.clearUserInfo();
                  }
                  Navigator.pushNamed(context, '/$value');
                });
              },
              itemBuilder: (BuildContext context) {
                return menuItems.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            ),
          ],

        ),
        body: isLoading ?
        Center(
          child: Loading(),
        )
            : SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ColoredCardWidget(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        color: Colors.blueGrey,
                        cardText: "Pond/Tank",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PondList(token: "$token"),
                            ),
                          );
                        },
                      ),
                      ColoredCardWidget(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        color: Colors.cyan,
                        cardText: "Device Management",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DeviceManagement(
                                    token: "$token",
                                    ID: widget.ID,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text("Select Pond :", style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                          DropdownButton<String>(
                            value: select.selectedOption,
                            items: dropdownItems.map<DropdownMenuItem<String>>((
                                item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Text(
                                    item['name']), // Display the value property
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                select.selectedOption = newValue;
                                fetchData(widget.token);
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black45,
                          ),
                          onPressed: () {
                        setState(() {
                          fetchPondData();
                          refresh = true;
                        });
                      }, child: Text("Refresh")),
                      SizedBox(height: 20),
                      // Text('Selected Option: ${select.selectedOption}'),
                      SizedBox(height: 20),
                    ],
                  ),
                  availablePondData ?
                  DynamicTable(data_time: data_time,
                    doValues: doValues,
                    phValues: phValues,
                    Location: Location,
                    tempValues: tempValues,
                    totalRow: passRow,)
                      :
                 Text("No Data",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),)
                ],
              ),
            ),
          ),
        ),
      );
  }
}