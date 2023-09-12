import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/authUtlity.dart';
import 'package:water_quality_monitoring_system/PondDataShowPage.dart';
import 'package:water_quality_monitoring_system/constant.dart';
import 'package:water_quality_monitoring_system/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class WaterQuality extends StatefulWidget {
  final String token;
  final int pondId;
  const WaterQuality({Key? key, required this.token,required this.pondId}) : super(key: key);

  @override
  State<WaterQuality> createState() => _WaterQualityState();
}

class _WaterQualityState extends State<WaterQuality> {


  double tempValue = 0.0;
  double phValue = 0.0;
  double doValue = 0.0;
  String timestamp = "";
  String tempTimestamp = "";
  String doTimestamp = "";
  bool isLoading = true;
  bool empty = false;
  Future<void> fetchData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://182.163.112.102:8007/api/devices/data/pond/latest/${widget.pondId}/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> data = responseData['data'];

        setState(() {
          if(data.isEmpty) empty = true;
          tempValue = data['Temp']['value'];
          print("Temparature Value : $tempValue");
          tempTimestamp = data['Temp']['data_time'];
          phValue = data['PH']['value'];
          print("PH Value : $phValue");
          timestamp = data['PH']['data_time'];
          doValue = data['DO']['value'];
          print("DO Value : $doValue");
          doTimestamp = data['DO']['data_time'];
          isLoading= false;
        });
      }
      else {
        print('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(widget.token);
  }


  @override
  Widget build(BuildContext context) {

    String token = widget.token;

//Eita kichu e na eita ei jonno dawa hoise jate Water quality page ta ListView te ana jay (Ignore this Line)
    List<String> items = List.generate(1, (index) => 'Item $index');


    return Scaffold(
      appBar: AppBar(
        title: Text("Water Quality"),
        // automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Close the dialog and return false
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Close the dialog and return true
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              ).then((value) {

                if (value == true) {
                  AuthUtility.clearUserInfo();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              });
            },
            child: Text('Logout'),
          ),
        ],

      ),
      body: RefreshIndicator(
        // backgroundColor: Colors.lightBlueAccent,
        // color: Colors.white,
        onRefresh: () => fetchData(token as String),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              child : Center(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  width:  double.infinity,
                  child:

                  Column(
                    crossAxisAlignment:  CrossAxisAlignment.center,
                    children:  [
                      SizedBox(height: 20),

                      Container(
                        width:  double.infinity,
                        height:  130,
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {

                                if(Conostant.valuePh != null && !empty ){
                                  print("inner Button $Conostant.valuePh");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  PondDataShowPage(
                                      value: phValue,
                                      timestamp: timestamp,
                                      token : token,
                                      sensor_Id : 171,
                                      ekok : "PH",
                                      image : "assets/images/ph.png",
                                      title : "PH",
                                      pondId : widget.pondId,
                                        ListHolderType : "PH",
                                    )),
                                  );
                                }
                                else{
                                  Text("Hello");
                                //  Center(child: CircularProgressIndicator());
                                }

                              },
                              child: Container(
                                margin:  EdgeInsets.fromLTRB(0, 0, 16, 0),
                                padding:  EdgeInsets.fromLTRB(9.5, 12, 9.5, 11),
                                width:  156,
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
                                child:Column(
                                  children: [
                                    Image.asset("assets/images/ph.png"),
                                    SizedBox(width: 10),
                                     Text(
                                        'PH',
                                        textAlign:  TextAlign.center,
                                        style:  GoogleFonts.notoSans(
                                          fontSize:  16,
                                          fontWeight:  FontWeight.w500,
                                          color:  Color(0xffffffff),
                                        ),
                                      ),
                                     Text(
                                        '$phValue',
                                        textAlign:  TextAlign.center,
                                        style:  GoogleFonts.notoSans(
                                          fontSize:  14,
                                          fontWeight:  FontWeight.w500,
                                          color:  Color(0xffffffff),
                                        ),
                                      ),

                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if(tempValue != null && !empty ){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  PondDataShowPage(
                                      value: tempValue,
                                      timestamp: tempTimestamp,
                                      token: token,
                                      sensor_Id : 173,
                                      ekok : "°C",
                                      image : "assets/images/temperature.png",
                                      title : "Temperature",
                                      pondId: widget.pondId,
                                      ListHolderType : "Temp",
                                    )),
                                  );
                                }
                                else{
                                  Text("Hello");
                              //    CircularProgressIndicator();
                                }

                              },
                              child: Container(
                                margin:  EdgeInsets.fromLTRB(0, 0, 16, 0),
                                padding:  EdgeInsets.fromLTRB(9.5, 12, 9.5, 11),
                                width:  156,
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
                                child:Column(
                                  children: [
                                    Image.asset("assets/images/temperature.png"),
                                    SizedBox(width: 10),
                                    FittedBox(
                                      child: Text(
                                        'Temperature',
                                        textAlign:  TextAlign.center,
                                        style:  GoogleFonts.notoSans(
                                          fontSize:  16,
                                          fontWeight:  FontWeight.w500,
                                          color:  Color(0xffffffff),
                                        ),
                                      ),
                                    ),

                                      Text(
                                        '$tempValue',
                                        textAlign:  TextAlign.center,
                                        style:  GoogleFonts.notoSans(
                                          fontSize:  14,
                                          fontWeight:  FontWeight.w400,
                                          color:  Color(0xffffffff),
                                        ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Container(
                        width:  double.infinity,
                        height:  130,
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if(doValue != null && !empty ){
                                  Future.delayed(Duration(milliseconds: 400 ), ()
                                  {

                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(builder: (context) =>
                                          PondDataShowPage(
                                            value: doValue,
                                            timestamp: doTimestamp,
                                            token: token,
                                            sensor_Id : 172,
                                            ekok : "mg/L",
                                            image : "assets/images/O2.png",
                                            title : "Dissolved Oxygen",
                                            pondId: widget.pondId,
                                            ListHolderType : "DO",
                                          )),
                                    );
                                  });
                                }
                                else{
                                  Text("Hello");
                                 // CircularProgressIndicator();
                                }
                              },
                              child: Container(
                                margin:  EdgeInsets.fromLTRB(0, 0, 16, 0),
                                padding:  EdgeInsets.fromLTRB(9.5, 12, 9.5, 11),
                                width:  156,
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
                                child:Column(
                                  children: [
                                    Image.asset("assets/images/O2.png"),
                                    SizedBox(width: 10),
                                    Text(
                                      'Dissolved Oxygen',
                                      textAlign:  TextAlign.center,
                                      style:  GoogleFonts.notoSans(
                                        fontSize:  16,
                                        fontWeight:  FontWeight.w500,
                                        color:  Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      '$doValue',
                                      textAlign:  TextAlign.center,
                                      style:  GoogleFonts.notoSans(
                                        fontSize:  14,
                                        fontWeight:  FontWeight.w500,
                                        color:  Color(0xffffffff),
                                      ),
                                    ),
                                  ],
                                ),
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
          },
        ),
      ),
    );
  }
}






