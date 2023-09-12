import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:water_quality_monitoring_system/configDevice.dart';

class DeviceRegistration extends StatefulWidget {
  final String token;
  const DeviceRegistration({Key? key,required this.token}) : super(key: key);

  @override
  State<DeviceRegistration> createState() => _DeviceRegistrationState(token : token);
}

class _DeviceRegistrationState extends State<DeviceRegistration> {
  final String? token;

  _DeviceRegistrationState({
       required this.token,
    });

  TextEditingController deviceIdController = TextEditingController();
  TextEditingController deviceCodeController = TextEditingController();
  TextEditingController installedByController = TextEditingController();

  void _submitForm() async {
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
      print('Device created successfully');
      print(response.body);
      print("-------------------------------");
      final responseData = jsonDecode(response.body);
      final  id = responseData['data']['id'];
      print('Device created successfully with ID: $id');
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigDevice(id : id.toString(), token : token.toString() )));
    }
    else if(response.statusCode == 400){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Alert( message: 'Device creation failed. Device Already Exist.',);
        },
      );
    }

    else {
      print('Failed to create device');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: deviceIdController,
            decoration: InputDecoration(labelText: 'Device ID'),
          ),
          TextField(
            controller: deviceCodeController,
            decoration: InputDecoration(labelText: 'Device Code'),
          ),
          TextField(
            controller: installedByController,
            decoration: InputDecoration(labelText: 'Installed By'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Create Device'),
          ),
        ],
      ),
    );
  }
}




















