import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fill The Field';
    }
    return null;
  }

  Future<void> submitForm() async{
    if (_formKey.currentState!.saveAndValidate()) {
      final formValues = _formKey.currentState!.value;
      print('Name value: ${formValues['name']}');
      print('User Name value: ${formValues['username']}');

      final String url ="http://182.163.112.102:8007/api/users/create/";
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final Map<String,String> body ={
        "name":"${formValues['name'].toString()}",
        "username":"${formValues['username'].toString()}",
        "email":"${formValues['email'].toString()}",
        "phone":"${formValues['phone'].toString()}",
        "password1":"${formValues['password1'].toString()}",
        "password2":"${formValues['password2'].toString()}",
        "address": "${formValues['address'].toString()}"
      };
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if(response.statusCode == 201){
        print("hello");
        CustomSnackBar.show(context,'Api Hit');
      }


      // Reset the form fields after submission
      _formKey.currentState!.reset();
    //  CustomSnackBar.show(context,'${formValues['name']} your registration done');
    } else {
      CustomSnackBar.show(context,'Form is invalid');
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Example')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Registration!!!",

                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 10,),
                FormField("name","Name"),
                SizedBox(height: 6,),
                FormField("username","User Name"),
                SizedBox(height: 6,),
                FormField("email","E-mail"),
                SizedBox(height: 6,),
                FormField("phone","Phone"),
                SizedBox(height: 6,),
                FormField("password1","Password"),
                SizedBox(height: 6,),
                FormField("password2","Confirm Password"),
                SizedBox(height: 6,),
                FormField("address","Address"),

                SizedBox(height: 20),

                // buttonText: 'Login',
               CustomButton(onPressed: submitForm, buttonText: "Submit"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FormBuilderTextField FormField(String name, String lableText) {
    return FormBuilderTextField(
              name: name, // Add a unique name for each field
              decoration: InputDecoration(
                labelText: lableText,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(45),
                    left: Radius.circular(45),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(45),
                    left: Radius.circular(45),
                  ),
                ),
              ),
              validator: _validateField,
            );
  }
}
