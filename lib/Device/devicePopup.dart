import 'package:flutter/material.dart';
import 'package:water_quality_monitoring_system/configDevice.dart';
import 'package:water_quality_monitoring_system/timeInterval.dart';

class DevicePopup {
  final BuildContext context;
  final token;
  final id;
  final deviceId;
  final ID;
  DevicePopup(this.context,this.token,this.id,this.deviceId,this.ID);

  void showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Time Interval'),
                onTap: () {
                  // Implement the Activate option's logic here
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TimeInterval(token:token.toString(),deviceId: id),));
                },
              ),
              ListTile(
                title: Text('Configure'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigDevice(id:  id.toString(), token: token.toString(), ID: ID, deviceId : deviceId)));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

