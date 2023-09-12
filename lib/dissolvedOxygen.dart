import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class DissolvedOxygen extends StatefulWidget {
  // const DissolvedOxygen({Key? key}) : super(key: key);
  final dynamic value;
  final String timestamp;
  final String token;
  const DissolvedOxygen({Key? key, required this.value, required this.timestamp,required this.token}) : super(key: key);

  @override
  State<DissolvedOxygen> createState() => _DissolvedOxygenState();
}

class _DissolvedOxygenState extends State<DissolvedOxygen> {
  List<Data> dataList = [];

  @override
  void initState() {
    super.initState();
    final token = widget.token;
    final timestamp = widget.timestamp;
    print('--------------$timestamp');



    final value = widget.value;
    print(value);
    fetchData(token);

  }

  Future<void> fetchData(String token) async {
    print("aise");
    final url = Uri.parse('http://182.163.112.102:8007/api/devices/data/datatables/lastthree/');
    final data = jsonEncode({
      "token" : token,
      "device_id" : 2,
      'sensor_id': 172,
    });
    final response = await http.post(url, body: data);
    print('----auuuu');
    // print(response.body);
    final jsonData = json.decode(response.body);
    print(jsonData);
    if (jsonData['code'] == 200) {
      final dataListJson = jsonData['data'] as List<dynamic>;
      final dataList = dataListJson.map((json) => Data.fromJson(json)).toList();
      print('////////////// $dataList');
      // final lastThreeValues = dataList.reversed.take(4).map((json) => json['value'] as double).toList();
      // timestamp = phArray[0]['Timeime'];
      setState(() {
        this.dataList = dataList;

      });
      print(dataList[1]?.createdDate);
      print(widget.timestamp);
      // print(dataList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dissolved Oxygen"),
      ),
      body:  Center(
        child:
        Container(
          width:  double.infinity,

          child:
          Column(
            crossAxisAlignment:  CrossAxisAlignment.center,
            children:  [

              Container(

                padding:  EdgeInsets.fromLTRB(35, 40, 35, 20),
                width:  double.infinity,
                child:
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.center,
                  children:  [
                    Container(
                      // group2183J4x (11:26486)
                      margin:  EdgeInsets.fromLTRB(60, 0, 60, 20),
                      padding:  EdgeInsets.fromLTRB(50, 9, 50, 9),
                      // padding:  EdgeInsets.all(10.0),
                      width:  double.infinity,

                      decoration:  BoxDecoration (
                        color:  Color(0xff6fc5ff),
                        borderRadius:  BorderRadius.circular(8),
                        boxShadow:  [
                          BoxShadow(
                            color:  Color(0x19000000),
                            offset:  Offset(0, 4),
                            blurRadius:  2,
                          ),
                        ],
                      ),
                      child:
                      Center(

                        child:
                        SizedBox(
                          width:  60,
                          height:  62,
                          child:
                          Image.asset(
                            "assets/images/O2.png",
                            width:  32.76,
                            height:  39,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // group2184Ude (11:26487)
                        margin:  EdgeInsets.fromLTRB(60, 0, 60, 61),
                        padding: EdgeInsets.fromLTRB(0,10,0,10),
                        width:  double.infinity,
                        // height:  62,
                        decoration:  BoxDecoration (
                          color:  Color(0xff6fc5ff),
                          borderRadius:  BorderRadius.circular(8),
                          boxShadow:  [
                            BoxShadow(
                              color:  Color(0x19000000),
                              offset:  Offset(0, 4),
                              blurRadius:  2,
                            ),
                          ],
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child:
                              Text(
                                '${dataList.isNotEmpty ? dataList[0]?.value : 0.0} mg/L',
                                style:  GoogleFonts.notoSans (
                                  fontSize:  18,
                                  fontWeight:  FontWeight.w500,
                                  height:  1.3625,
                                  color:  Color(0xffffffff),
                                ),
                              ),
                            ),
                            Container(

                              child: Text("Last Updated",style: TextStyle(color: Colors.white),),
                            ),




                            Container(
                              child: Text('${dataList.isNotEmpty ? dataList[3]?.createdDate: 00.00}',style: TextStyle(color: Colors.white),),
                            )
                          ],
                        )

                    ),
                    Container(

                      margin: EdgeInsets.all(35),

                      width:  double.infinity,
                      child:
                      Column(
                        crossAxisAlignment:  CrossAxisAlignment.center,
                        children:  [
                          Container(
                            // autogrouphbi8dur (WBKzYTznATBM7kxuN2hBi8)
                            margin:  EdgeInsets.fromLTRB(0, 0, 0, 14),
                            width:  double.infinity,
                            height:  41,
                            child:
                            Row(
                              crossAxisAlignment:  CrossAxisAlignment.center,
                              children:  [
                                Container(

                                  margin:  EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  // width:  81,
                                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                  height:  double.infinity,
                                  decoration:  BoxDecoration (
                                    color:  Color(0xff6fc5ff),
                                    borderRadius:  BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color:  Color(0x19000000),
                                        offset:  Offset(0, 4),
                                        blurRadius:  2,
                                      ),
                                    ],
                                  ),
                                  child:
                                  Center(
                                    child:
                                    Text(
                                      '${dataList.isNotEmpty ? dataList[2]?.createdDate.split(" ")[1] : 00.00}',
                                      // "10.30",
                                      style:  GoogleFonts.notoSans (
                                        fontSize:  16,
                                        fontWeight:  FontWeight.w500,
                                        height:  1.3625,
                                        color:  Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // padding:  EdgeInsets.fromLTRB(27, 10, 64, 9),
                                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                                  height:  double.infinity,
                                  decoration:  BoxDecoration (
                                    color:  Color(0xffcaeaff),
                                    borderRadius:  BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color:  Color(0x19000000),
                                        offset:  Offset(0, 4),
                                        blurRadius:  2,
                                      ),
                                    ],
                                  ),
                                  child:
                                  Row(
                                    crossAxisAlignment:  CrossAxisAlignment.center,
                                    children:  [
                                      Container(

                                        margin:  EdgeInsets.fromLTRB(0, 1, 24, 0),
                                        width:  7,
                                        height:  7,
                                        decoration:  BoxDecoration (
                                          borderRadius:  BorderRadius.circular(3.5),
                                          color:  Color(0xff9d9d9d),
                                        ),
                                      ),
                                      Text(

                                        // '${dataList[1]?.value}',
                                        '${dataList.isNotEmpty ? dataList[2]?.value : 0.0} mg/L',
                                        // "asknal",
                                        style:  GoogleFonts.notoSans(
                                          fontSize:  16,
                                          fontWeight:  FontWeight.w500,
                                          height:  1.3625,
                                          color:  Color(0xff9d9d9d),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(

                            margin:  EdgeInsets.fromLTRB(0, 0, 0, 16),
                            width:  double.infinity,
                            height:  41,
                            child:
                            Row(
                              crossAxisAlignment:  CrossAxisAlignment.center,
                              children:  [
                                Container(

                                  margin:  EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                  height:  double.infinity,
                                  decoration:  BoxDecoration (
                                    color:  Color(0xff6fc5ff),
                                    borderRadius:  BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color:  Color(0x19000000),
                                        offset:  Offset(0, 4),
                                        blurRadius:  2,
                                      ),
                                    ],
                                  ),
                                  child:
                                  Center(
                                    child:
                                    FittedBox(
                                      child: Text(
                                        '${dataList.isNotEmpty ? dataList[1]?.createdDate.split(" ")[1] : 00.00}',
                                        // '2:00 PM',
                                        style:  GoogleFonts.notoSans(
                                          fontSize:  16,
                                          fontWeight:  FontWeight.w500,
                                          height:  1.3625,
                                          color:  Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogroupwppiHex (WBL192qWvtVeM6FoUqWpPi)
                                  // padding:  EdgeInsets.fromLTRB(27, 8, 64, 11),
                                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                                  height:  double.infinity,

                                  decoration:  BoxDecoration (
                                    color:  Color(0xffcaeaff),
                                    borderRadius:  BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color:  Color(0x19000000),
                                        offset:  Offset(0, 4),
                                        blurRadius:  2,
                                      ),
                                    ],
                                  ),
                                  child:
                                  Row(
                                    crossAxisAlignment:  CrossAxisAlignment.center,
                                    children:  [
                                      Container(
                                        // ellipse6Aye (11:26480)
                                        margin:  EdgeInsets.fromLTRB(0, 1, 24, 0),
                                        width:  7,
                                        height:  7,
                                        decoration:  BoxDecoration (
                                          borderRadius:  BorderRadius.circular(3.5),
                                          color:  Color(0xff9d9d9d),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          // Vm2 (11:26479)
                                          '${dataList.isNotEmpty ? dataList[1]?.value : 0.0} mg/L',
                                          // '7.00',
                                          style:  GoogleFonts.notoSans (
                                            fontSize:  16,
                                            fontWeight:  FontWeight.w500,
                                            height:  1.3625,
                                            color:  Color(0xff9d9d9d),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // autogroupnjjtedv (WBL1LCBaxNw7rQvXBkNJJt)
                            width:  double.infinity,
                            height:  41,
                            child:
                            Row(
                              crossAxisAlignment:  CrossAxisAlignment.center,
                              children:  [
                                Container(
                                  // autogroup9sac1Da (WBL1SGqnfsqxAYvqaU9SAC)
                                  margin:  EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  // width:  81,

                                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                  height:  double.infinity,
                                  decoration:  BoxDecoration (
                                    color:  Color(0xff6fc5ff),
                                    borderRadius:  BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color:  Color(0x19000000),
                                        offset:  Offset(0, 4),
                                        blurRadius:  2,
                                      ),
                                    ],
                                  ),
                                  child:
                                  Center(
                                    child:
                                    FittedBox(
                                      child: Text(
                                        '${dataList.isNotEmpty ? dataList[0]?.createdDate.split(" ")[1] : 00.00}',
                                        // '9:00 PM',
                                        style:  GoogleFonts.notoSans (

                                          fontSize:  16,
                                          fontWeight:  FontWeight.w500,
                                          height:  1.3625,
                                          color:  Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogroupvzxqTLU (WBL1VXFNjmqaJeo4agvzxQ)
                                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                                  height:  double.infinity,
                                  decoration:  BoxDecoration (
                                    color:  Color(0xffcaeaff),
                                    borderRadius:  BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color:  Color(0x19000000),
                                        offset:  Offset(0, 4),
                                        blurRadius:  2,
                                      ),
                                    ],
                                  ),
                                  child:
                                  Row(
                                    crossAxisAlignment:  CrossAxisAlignment.center,
                                    children:  [
                                      Container(

                                        margin:  EdgeInsets.fromLTRB(0, 1, 24, 0),
                                        width:  7,
                                        height:  7,
                                        decoration:  BoxDecoration (
                                          borderRadius:  BorderRadius.circular(3.5),
                                          color:  Color(0xff9d9d9d),
                                        ),
                                      ),
                                      Text(
                                        // qM2 (11:26481)
                                        '${dataList.isNotEmpty ? dataList[0]?.value : 0.0} mg/L',
                                        // '6.50',
                                        style:  GoogleFonts.notoSans(

                                          fontSize:  16,
                                          fontWeight:  FontWeight.w500,
                                          height:  1.3625,
                                          color:  Color(0xff9d9d9d),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}















// -------------------------------  DO Data Model-------------------------------



class Data {
  final dynamic id;
  final dynamic deviceCode;
  final dynamic sensorName;
  final dynamic value;
  final dynamic parameterId;
  final dynamic createdDate;

  Data({
    required this.id,
    required this.deviceCode,
    required this.sensorName,
    required this.value,
    required this.parameterId,
    required this.createdDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final createdDate = json['created_date'] as dynamic;
    return Data(
      id: json['id'] as dynamic,
      deviceCode: json['DeviceCode'] as dynamic,
      sensorName: json['SensorName'] as dynamic,
      value: json['value'] as dynamic,
      parameterId: json['parameter_id'] as dynamic,
      createdDate: createdDate,
    );
  }
}
