import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';


class TimeInterval extends StatefulWidget {
  final String token;
  final int deviceId;
  TimeInterval({Key? key,required this.token,required this.deviceId}) : super(key: key);

  @override
  State<TimeInterval> createState() => _TimeIntervalState();
}

class _TimeIntervalState extends State<TimeInterval> {
  final _formKey = GlobalKey<FormState>();




  TextEditingController deviceIdController = TextEditingController();
  TextEditingController timeIntervalController = TextEditingController();

  int _deviceId = -1;
  int _timeInterval = 0;

  @override
  void initState() {
    super.initState();
    deviceIdController = new TextEditingController(text: '${widget.deviceId}');
    _deviceId = int.parse("${widget.deviceId}");
  }

  Future<void> _submitForm() async {
    try{
      print('Device ID: $_deviceId');
      print('Time Interval(In seconds): $_timeInterval');

      final String url = 'http://182.163.112.102:8007/api/devices/config/interval/';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };
      final Map<String, dynamic> body = {
        "device_id": _deviceId,
        "data_interval": _timeInterval,
      };

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 ) {
        CustomSnackBar.show(context, 'Request Sent Successfully');
        var data = jsonDecode(response.body);
        if(data['message'] == "Interval successfully set."){
          print("Data send successful");
          deviceIdController.clear();
          timeIntervalController.clear();
          Navigator.pop(context);
        }
        else {
          print("Update failed");
        }
      }
    }

    catch (error) {
      CustomSnackBar.show(context, '$error');
    }


  }

  @override
  Widget build(BuildContext context) {
    // print(widget.token);
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Interval"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField(
              //   controller: deviceIdController,
              //   decoration: InputDecoration(
              //       labelText: 'Device ID',
              //       hintText: 'Input your device ID '
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter device ID';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     _deviceId = widget.deviceId;
              //   },
              // ),
              Text("Set Device Time Interval",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23),),
              SizedBox(height: 10,),
              TextFormField(
                controller: timeIntervalController,
                decoration: InputDecoration(labelText: 'Time Interval(In seconds)',
                    hintText: 'Input time interval (In seconds)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time interval';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _timeInterval = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // do something with the form data, e.g. submit to server

                    _submitForm();}
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


