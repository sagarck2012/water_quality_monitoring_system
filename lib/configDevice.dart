import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';

class ConfigDevice extends StatefulWidget {
  final String id;
  final String token;
  final ID;
  final deviceId;
  const ConfigDevice({Key? key, required this.id, required this.token,required this.ID,required this.deviceId}) : super(key: key);

  @override
  State<ConfigDevice> createState() => _ConfigDeviceState(token: token, id: id, deviceId : deviceId);
}

class _ConfigDeviceState extends State<ConfigDevice> {
  final String? token;
  final String? id;
  final String? deviceId;

  _ConfigDeviceState({
    required this.token,
    required this.id,
    required this.deviceId,
  });


  int? pId ;
  int? timeInterval ;
  String? createdAt ;
  String? config_updated_at ;
  int? deviceReg ;
  int? deviceIn ;
  int? createdBy ;
  int? config_updated_by ;
  String? pond_name;

  bool isloading = true;
  List<Map<String, dynamic>> getAllPond = [];
  Map<String, dynamic> getCurrentConfigData ={};
  List<Map<String, dynamic>> idList = [ {"name": "None", "id": null} ];
  bool updateStatus = false;
  int? selectedId;
  String? currentName;


  Future<void> fetchPondData() async {
    final response = await http.get(
      Uri.parse('http://182.163.112.102:8007/api/pond/list/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        getAllPond = List<Map<String, dynamic>>.from(jsonData['data']);
        idList.addAll(getAllPond.map<Map<String, dynamic>>((pond) => {"name": pond['name'], "id": pond['id'] as int?}));
      });
    } else {
      // Handle error cases
      // print('Failed to fetch pond data');
    }
  }
  Future<void> fetchGetConfig() async {
    final response = await http.get(

      Uri.parse('http://182.163.112.102:8007/api/devices/config/${widget.id}/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {

      setState(() {
        getCurrentConfigData = json.decode(response.body)['data'];
        print("---------------------");
        print(getCurrentConfigData);
        pond_name = getCurrentConfigData["pond_name"];
        print("Pond Name is : $pond_name");
        print("---------------------");
        pId = getCurrentConfigData['id'];

        timeInterval = getCurrentConfigData['interval_time'];

        createdAt = getCurrentConfigData['created_at'];
        config_updated_at = getCurrentConfigData['config_updated_at'];

        deviceReg = getCurrentConfigData['device_reg'];
        print("Device ID : $deviceReg");
        deviceIn = getCurrentConfigData['device_in'];
        print("Config Updated_by ID : $deviceIn");
        createdBy = getCurrentConfigData['created_by'];
        config_updated_by = getCurrentConfigData['config_updated_by'] ?? null;

        print("Config Updated_by ID : $config_updated_by");
        // pond_name = getCurrentConfigData['pond_name'];
        print("Config Updated_by ID : $pond_name");
        isloading = false;
      });
    } else {
      // Handle error cases
      // print('Failed to fetch pond data');
    }
  }
  Future<void> submitConfig() async {

    if (selectedId != null) {
      int? deviceId = int.tryParse(id!);
      print("///////////// 1st time Assign     $selectedId  ---------------------");
      // --------------------------If er bhetor 1st time Assign-----------------
      // --------------------------else er bhetor Update Assign -----------------
      if(!updateStatus){
        final response = await http.post(
          Uri.parse('http://182.163.112.102:8007/api/devices/config/device-in/'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "device_id": deviceId,
            "device_in": selectedId,
          }),
        );

        if (response.statusCode == 200) {
          CustomSnackBar.show(context,'Config submitted successfully');
          print('CONFIG_DEVICE PAGE :: - Config submitted successfully');
          setState(() {
            pond_name =  currentName;
          });
          Navigator.pop(context);
        }
        else if(response.statusCode == 400){
          var data = jsonDecode(response.body);
          CustomSnackBar.show(context,'${data['message'].toString()}');
          bool shouldEdit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Device is already Configured.'),
                content: Text('Do you want to edit'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Return 'true' if YES is selected
                    },
                    child: Text('YES'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Return 'false' if NO is selected
                    },
                    child: Text('NO'),
                  ),
                ],
              );
            },
          );

          // Navigate to another page if user chose 'YES'
          if (shouldEdit) {
            setState(() {
              updateStatus =true;
              // submitConfig();
            });
          }
        }
        else {
          CustomSnackBar.show(context,'Config submitted successfully');
          print('CONFIG_DEVICE PAGE :: - Failed to submit config');
          // Handle error cases
        }
      }



      else{
        try{
          final String apiUrl = 'http://182.163.112.102:8007/api/devices/config/device-in/';

          final String token = 'your_authorized_token_here';

          final Map<String, dynamic> postData = {
            "id": pId,
            "interval_time": timeInterval,
            "created_at": createdAt,
            "config_updated_at": config_updated_at,
            "device_reg": deviceReg,
            "device_in": selectedId,
            "created_by": createdBy,
            "config_updated_by": config_updated_by,
            "pond_name": pond_name,
          };

          final response = await http.put(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.token}',
            },
            body: jsonEncode(postData),
          );

          if (response.statusCode == 200) {
            setState(() {
              deviceIn=selectedId;
              updateStatus = false;
              pond_name =  currentName;
            });
            print('Update Successful');
            print('Response: ${response.body}');
            CustomSnackBar.show(context,'Update Successful');

          } else {
            CustomSnackBar.show(context,'Update Failed');
            print('Update Failed Ami Aschi ei porjonto');
            print('Response: ${response.body}');
          }
        }
        catch (error)
        {
          print("Error is $error");
        }

      }
    } else {

      CustomSnackBar.show(context,'Please Select all Field');
    }
  }

  @override
  void initState() {
    super.initState();
    print("Congigpage : $id");
    fetchPondData();
    fetchGetConfig();
    isloading = false;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
      ),
      body: isloading ?
      Center(
        child: CircleAvatar(),
      )
          :Center(

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Device Interval Time $timeInterval"),
              Text("Current Pond :  $pond_name"),
              SizedBox(height: 20,),
              Text("Device Id :",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),

              TextField(
                controller: TextEditingController(text: '${widget.deviceId}'),
                readOnly: true,
              ),
              SizedBox(height: 20,),

              Text("Select Pond : " ,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),

              DropdownButton<int?>(
                value: selectedId,
                onChanged: (int? newValue) {
                  String? newName = idList.firstWhere((element) => element['id'] == newValue)['name'];
                  setState(() {
                    selectedId = newValue;
                   currentName = newName;
                  });
                },
                items: idList.map<DropdownMenuItem<int?>>((Map<String, dynamic> value) {
                  return DropdownMenuItem<int?>(
                    value: value['id'],
                    child: Text(value['name']),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              // Text('Selected ID: ${selectedId != null ? selectedId.toString() : "None"}'),
              ElevatedButton(
                onPressed: submitConfig,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


