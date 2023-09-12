import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/authUtlity.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/loginModel.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/token.dart';
import 'package:water_quality_monitoring_system/Notification/local_Notification.dart';
import 'package:water_quality_monitoring_system/dashboard.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:water_quality_monitoring_system/user/userInfo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController usermailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _controller = ScrollController();
  final _focusNode = FocusNode();

  bool rememberMe = false;
  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;


  Future<String?> login(String email, String password) async {
    try{
  final url = Uri.parse('http://182.163.112.102:8007/api/users/token/');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
  'email': email,
  'password': password,
  });
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    // NotificationManager().simpleNotificationShow();
    final tokenData = jsonDecode(response.body);
  final access = tokenData['access'];
  final refresh = tokenData['refresh'];

  usermailController.clear();
  passController.clear();
  //------------------ Now you have the access and refresh tokens  ---------------------

  print('Access Token: $access');
  //print('Refresh Token: $refresh');
    tokenV.tokenValue = access;
  decodeAccessToken(access);
  return access;
  } else if(response.statusCode == 401) {
    ToastMessage.show(context, 'Your Email Or Password Incorrect');
  }
  return null;
  }
    catch(error)
    {
      print("Error : $error");
    }

  }

  late final String ID  ;
  void decodeAccessToken(String accessToken) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

    if (decodedToken != null) {
      tokenValue.token = decodedToken.toString();
      // Extract user details from the decoded token
      print('User ID: ${decodedToken['user_id']}');
      ID = decodedToken['user_id'].toString();
      print('Username: ${decodedToken['username']}');
      userInfo.userName = decodedToken['username'].toString();
      print('Name: ${decodedToken['name']}');
      userInfo.name = decodedToken['name'].toString();
      print('Is Staff: ${decodedToken['is_staff']}');
      userInfo.Staff = decodedToken['is_staff']?"Staff":"Not Staff";
      print('Email: ${decodedToken['email']}');
      userInfo.userEmail = decodedToken['email'].toString();
      print('Phone: ${decodedToken['phone']}');
      userInfo.userPhoneNumber= decodedToken['phone'].toString();
      loginModel model = loginModel.fromJson(decodedToken);
      await AuthUtility.saveUserInfo(model);
      tokenV.tokenValue = accessToken;
      await AuthUtility.saveToken(accessToken);
      await AuthUtility.saveID(ID);

    } else {
      print('Failed to decode access token.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery
                .of(context)
                .size
                .height,
          ),
          child: Container(
            padding:  EdgeInsets.fromLTRB(40, 100, 23, 205),
            width:  double.infinity,
            decoration:  BoxDecoration (
              color:  Color(0xffffffff),
              image:  DecorationImage (
                fit:  BoxFit.cover,
                image: AssetImage("assets/images/background.png"),
              ),
            ),

            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin:  EdgeInsets.fromLTRB(0, 0, 38.23, 19),
                    width:  87.77,
                    height:  81.44,
                    child:
                    Image.asset(
                      'assets/images/fish_login.png',
                      width:  87.77,
                      height:  81.44,
                    ),
                  ),
                  Container(
                    margin:  EdgeInsets.fromLTRB(0, 0, 10, 43),
                    width:  266,
                    height:  79,
                    child:
                    Stack(
                      children:  [
                        Positioned(
                          left:  32,
                          top:  0,
                          child:
                          Align(
                            child:
                            SizedBox(
                              width:  194,
                              height:  41,
                              child:
                              FittedBox(
                                child: Text(
                                  'Water Quality',
                                  style:  GoogleFonts.openSansCondensed (
                                    fontSize:  32,
                                    fontWeight:  FontWeight.w700,
                                    height:  1.2575,
                                    color:  Color(0xff007388),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left:  0,
                          top:  38,
                          child:
                          Align(
                            child:
                            SizedBox(
                              width:  266,
                              height:  41,
                              child:
                              FittedBox(
                                child: Text(
                                  'Monitoring System',
                                  style:  GoogleFonts.openSansCondensed (
                                    fontSize:  32,
                                    fontWeight:  FontWeight.w700,
                                    height:  1.2575,
                                    color:  Color(0xff007388),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            Container(
                              // emailiduseridTtU (4:26076)
                              margin:  EdgeInsets.fromLTRB(0, 0, 151, 10),
                              child:
                              FittedBox(
                                child: Text(
                                  'Email Id              ',
                                  style:   GoogleFonts.notoSans(
                                    fontSize:  18,
                                    fontWeight:  FontWeight.w400,
                                    height:  1.3625,
                                    color:  Color(0xff007288),
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              autofillHints: [AutofillHints.email],
                              controller: usermailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Type User E-mail',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              // emailiduseridTtU (4:26076)
                              margin:  EdgeInsets.fromLTRB(0, 0, 151, 10),
                              child:
                              FittedBox(
                                child: Text(
                                  'Password             ',
                                  style:   GoogleFonts.notoSans(
                                    fontSize:  18,
                                    // fontWeight:  FontWeight.w400,
                                    height:  1.3625,
                                    color:  Color(0xff007288),
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              autofillHints: [AutofillHints.password],
                              controller: passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                hintText: 'Type Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
//if internet connection problem after some times later loding will be off
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: MaterialButton(
                                onPressed: () async {
                                  TextInput.finishAutofillContext();
                                  if (_formKey.currentState?.validate() ?? false) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Loading(), // Show the spinner in the dialog
                                        );
                                      },
                                    );
                                    String email = usermailController.text;
                                    String password = passController.text;
                                    String? token = await login(email, password);
                                    Navigator.pop(context); // Close the dialog

                                    if (token != null) {

                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Dashboard(token: token, ID: ID)), (route) => false);
                                    } else {
                                      // Handle the case where token is null

                                    }
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.notoSans(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      height: 1.8,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                height: 50,
                                color: Color(0xff008be7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
