import 'package:flutter/material.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/authUtlity.dart';
import 'package:water_quality_monitoring_system/RegistrationUser/registration.dart';
import 'package:water_quality_monitoring_system/dashboard.dart';
import 'package:water_quality_monitoring_system/login.dart';
import 'package:water_quality_monitoring_system/profile.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/token.dart';

void main() async {
  /*var initialRoute = 'login';
  final  token = await AuthUtility.checkToken();
 // var value = await storage.read(key: 'token');


  if (token) {
    initialRoute = 'home';
  }
  else{
    initialRoute = 'login';
  }*/
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      whichPageShouldGo(context);

  }

  late bool isLogin;
  late bool isToken;
  late bool isID;
  late String T;
  late String ID;
  Future<void> whichPageShouldGo(BuildContext context) async {


  if(mounted){

      isLogin = await AuthUtility.checkIfUserLoggedIn();
      isToken = await AuthUtility.checkToken();
      isID = await AuthUtility.checkID();
      T = await AuthUtility.getToken();
      ID = await AuthUtility.getID();


    print("-------------------------------------------");
    print("State Id : $ID");
    print("State Token : $T");
    print("State Login : $isLogin");
    print("State Token : $isToken");
    print("State ID : $isID");

    if (isLogin && isToken && isID) {
      setState(() {
        loading = true;
        tokenValue.token = T;
      });
    }
    else{
      setState(() {
        loading = false;
      });
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Quality Monitoring System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       home: loading?Dashboard(token: T, ID: ID):WelcomePage(title: 'Welcome'),

       routes: {
        '/Profile': (context) => Profile(),
        '/Logout': (context) => WelcomePage(title: "title"),
      },

    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.title});

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Container(
          decoration:  BoxDecoration (

            image:  DecorationImage (
              fit:  BoxFit.cover,
              image: const AssetImage("assets/images/background.png"),
            ),
          ),
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children:  [
              Container(

                margin:  EdgeInsets.fromLTRB(0, 0, 0, 18),
                child:
                FittedBox(
                  child: Text(
                    'WELCOME TO ',
                    style:  GoogleFonts.openSansCondensed (
                      fontSize:  46,
                      fontWeight:  FontWeight.w700,
                      height:  1.2575,
                      color:  Color(0xffffffff) ,
                    ),
                  ),
                ),
              ),
              Container(

                margin:  EdgeInsets.fromLTRB(0, 0, 0, 19),
                width:  87.77,
                height:  81.44,
                child:
                Image.asset(
                  'assets/images/fish.png',
                  width:  87.77,
                  height:  81.44,
                ),
              ),

              Container(

                margin:  EdgeInsets.fromLTRB(0, 0, 0, 45),
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
                                color:  Color(0xffffffff),
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
                                color:  Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StartButton(buttonName: "Login",page: LoginPage()),
                  StartButton(buttonName: "Registration",page: RegistrationForm()),
                ],

              )
            ],
          ),
        ),
      ),
    );
  }
}
