import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:water_quality_monitoring_system/Api/CommonApi.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:water_quality_monitoring_system/Device/devicePopup.dart';

class DeviceManagement extends StatefulWidget {
  final String token;
  final String ID;
  const DeviceManagement({Key? key,required this.token,required this.ID}) : super(key: key);

  @override
  State<DeviceManagement> createState() => _DeviceManagementState(token: token,);
}

class _DeviceManagementState extends State<DeviceManagement> {
  final String? token;

  _DeviceManagementState({
    required this.token,
  });

  bool isLoading = true;
  List<Map<String, dynamic>> getAllDevice = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((_) {
      setState(() {
        isLoading = false;
      });
    });



  }

  Future<void> fetchData() async {
    isLoading = true;
    try {
      List<Map<String, dynamic>> data = await ApiService.fetchData(token.toString());
      setState(() {
        getAllDevice = data;
        print("DeviceManagement Page ::  All Data of ");
      //  print(getAllDevice);
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }



  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          title: Text('Device List'),
        // leading: IconButton(onPressed: () {
        //   Navigator.pop(context, MaterialPageRoute(builder: (context) => DeviceManagement(token: widget.token, ID: widget.ID),));
        // }, icon: Icon(Icons.arrow_back)),
      ),
      body: isLoading?
          Center(
            child: Loading(),
          )
      : ListView.builder(
          itemCount: getAllDevice.length,
          itemBuilder: (context, index) {
          final device = getAllDevice[index];
          print("-----------  Device   -----------");
          print(device);
           return ListTile(
               title: Text(" Device Id: ${device['device_id']}"),
               // (${device['id']})
               subtitle: Text('Installed By : ${device['installed_by']}, Device Code : ${device['device_code']} '),
               onTap: () {
                 DevicePopup devicePopup = DevicePopup(context,token,device['id'],device['device_id'],widget.ID);
                 devicePopup.showOptionsDialog();
               },
             );

    }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController deviceIdController = TextEditingController();
          TextEditingController deviceCodeController = TextEditingController();
          TextEditingController installedByController = TextEditingController();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Add New Device'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: deviceIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Device ID',
                          ),
                        ),
                        TextField(
                          controller: deviceCodeController,
                          decoration: InputDecoration(
                            hintText: 'Device Code',
                          ),
                        ),
                        TextField(
                          controller: installedByController,
                          decoration: InputDecoration(
                            hintText: 'Installed By',
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final deviceId = int.tryParse(deviceIdController.text) ?? 0;
                          final deviceCode = deviceCodeController.text;
                          final installedBy = installedByController.text;


                          final response = await http.post(
                            Uri.parse('http://182.163.112.102:8007/api/devices/create-device/'),
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json', // Specify JSON content type
                            },
                            body: jsonEncode({
                              "device_id": deviceId,
                              "device_code": deviceCode,
                              "installed_by": installedBy,
                            }),
                          );

                          if (response.statusCode == 201) {
                            // Pond successfully added, update UI
                            fetchData();
                            Navigator.pop(context);
                          }
                          else if(response.statusCode == 404) {
                            // Handle error cases
                            Alert(message : 'Failed to Add ');
                            print('Device Management Page :: Failed to add pond');
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.cyan),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        child: Container(height: 50,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}



