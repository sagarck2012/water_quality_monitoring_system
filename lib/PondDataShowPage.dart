import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';

class PondDataShowPage extends StatefulWidget {
  final double value;
  final int sensor_Id;
  final String timestamp;
  final String token;
  final String ekok;
  final String image;
  final String title;
  final int pondId;
  final String ListHolderType;

  PondDataShowPage({
    Key? key,
    required this.value,
    required this.timestamp,
    required this.token,
    required this.sensor_Id,
    required this.ekok,
    required this.image,
    required this.title,
    required this.pondId,
    required this.ListHolderType,
  }) : super(key: key);

  @override
  State<PondDataShowPage> createState() => _PondDataShowPageState(ekok: ekok , image:image , title:title,ListHolderType:ListHolderType);
}

class _PondDataShowPageState extends State<PondDataShowPage> {
  final String? ekok;
  final String? image;
  final String? title;
  final String? ListHolderType;

  _PondDataShowPageState({
    required this.ekok,
    required this.image,
    required this.title,
    required this.ListHolderType,
  });


  List<double> doValues = [];
  List<String> TIME = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final token = widget.token;
    final timestamp = widget.timestamp;
    final sensor_Id = widget.sensor_Id;
    final value = widget.value;
    final pondId = widget.pondId;
    fetchData(token,pondId);
  }

  Future<void> fetchData(String token,int pondId) async {
    try{
      final response = await http.get(
        Uri.parse('http://182.163.112.102:8007/api/devices/data/pond/last-four-data/${widget.pondId}/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> data = responseData['data'];

        final List<dynamic> doList = data['$ListHolderType'];
        print("PH list er 1st index er Value : ");
        print(doList[0]);
        final List<double> extractedDOValues = doList.map<double>((entry) {
          return entry['value'];
        }).toList();
        final List<String> extractedTime_date = doList.map<String>((entry) {
          final DateTime dateTime = DateTime.parse(entry['data_time'].toString());
          final DateFormat formatter = DateFormat('hh:mm a');
          final String formattedDateTime = formatter.format(dateTime);
          return formattedDateTime;
        }).toList();

        setState(() {
          doValues = extractedDOValues;
          TIME = extractedTime_date;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    }
    catch (error) {
      print('Error: $error');
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${title}"),
      ),
      body: isLoading?
      Center(
          child : Loading(),
      )
      : Center(
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
                            "$image",
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
                                '${doValues[0]} ${ekok}',
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

                              child: Text(TIME[0],style: TextStyle(color: Colors.white),),
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
                                       "${TIME[1]}",
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
                                        '${doValues[1]}${ekok}',
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
                                        // '${dataList.isNotEmpty ? dataList[1]?.createdDate.split(" ")[1] : 00.00}',
                                        "${TIME[2]}",
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
                                          '${doValues[2]} ${ekok}',
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
                                        //'${dataList.isNotEmpty ? dataList[0]?.createdDate.split(" ")[1] : 00.00}',
                                    "${TIME[3]}",
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
                                        '${doValues[3]} ${ekok}',
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
