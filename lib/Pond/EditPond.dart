import 'package:flutter/material.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:water_quality_monitoring_system/pond_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditFormDemo extends StatefulWidget {
  final editPondData;
  final token;
  final ValueChanged<bool> onEditSuccess;
   EditFormDemo({super.key, required this.editPondData, required this.token, required this.onEditSuccess});

  @override
  _EditFormDemoState createState() => _EditFormDemoState();
}

class _EditFormDemoState extends State<EditFormDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _editedName = '';
  double _editedDepth = 0;
  double _editedArea = 0;
  bool isloading = false;

  Future<void> EditPond() async{
    print(_editedName);
    print(tokenValue.token.toString());
    final String url = 'http://182.163.112.102:8007/api/pond/edit/';
    final Map<String, dynamic> body = {
      "id": widget.editPondData["id"],
      "name": _editedName,
      "depth": _editedDepth,
      "area": _editedArea,
      "created_at": widget.editPondData["created_at"],
      "updated_at": widget.editPondData["updated_at"],
      "user": widget.editPondData["user"],
      "created_by": widget.editPondData["created_by"],
      "updated_by": widget.editPondData["updated_by"]
    };
    final Map<String,String>headers ={
      "Authorization": "Bearer ${widget.token}",
      "Content-Type": "application/json",
    };

    final response = await http.post(
      Uri.parse(url),
      headers:headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      ToastMessage.show(context, "Update Successfully");
      _handleEditSuccess();
    } else {
      ToastMessage.show(context, "Update Failed Because of ${response.statusCode} Response");
      isloading=false;
      setState(() {

      });
    }

  }
  void _handleEditSuccess() {
    isloading=false;
    print("TRUE KI HOISE");
    widget.onEditSuccess(true);
    // setState(() {});
    Navigator.pop(context);
  }
  void _editItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _editedName =_editedName.trim();
      EditPond();
    }
    else{
      ToastMessage.show(context,"Form is not valid");
    }
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editedName = "${widget.editPondData["name"]}";
    _editedDepth = double.parse("${widget.editPondData["depth"]}") ;
    _editedArea = double.parse("${widget.editPondData["area"]}") ;
    print('Edited Name: $_editedName');
    print('Edited Depth: $_editedDepth');
    print('Edited Area: $_editedArea');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pond'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Pond/Tank Name'),
                initialValue: _editedName, // Set initial value
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) => _editedName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pond/Tank Depth(meter)'),
                keyboardType: TextInputType.number,
                initialValue: _editedDepth.toString(), // Set initial value
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid depth';
                  }
                  return null;
                },
                onSaved: (value) => _editedDepth = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: ' Pond/Tank Area(square meter)'),
                keyboardType: TextInputType.number,
                initialValue: _editedArea.toString(), // Set initial value
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid area';
                  }
                  return null;
                },
                onSaved: (value) => _editedArea = double.parse(value!),
              ),
              SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(side: MaterialStatePropertyAll(BorderSide(color: Colors.blue))),
                onPressed: (){
                  isloading = true;
                  _editItem();
                  setState(() {

                  });
                },
                child: isloading?
                 CircularProgressIndicator()
                    :Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



























