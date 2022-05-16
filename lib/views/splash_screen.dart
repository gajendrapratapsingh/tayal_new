import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/views/account_verified_screen.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/intro_screen.dart';
import 'package:tayal/views/login_screen.dart';
import 'package:tayal/views/mobile_login_screen.dart';
import 'package:tayal/views/otp_screen.dart';
import 'package:tayal/views/profile_screen.dart';
import 'package:tayal/views/selected_product_screen.dart';
import 'package:tayal/views/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _loggedIn = false;
  final splashDelay = 3;

  String loginsuccess = "";

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
    _loadWidget();
  }

  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getString('visited');
    if (_isLoggedIn.toString() == "true") {
      setState(() {
        _loggedIn = true;
      });
    } else {
      setState(() {
        _loggedIn = false;
      });
    }
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginsuccess = prefs.getString('loginsuccess');
    });
    //Get.off(homeOrLog());
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => homeOrLog()));
  }

  Widget homeOrLog() {
    if (this._loggedIn) {
      return IntroScreen();
    } else {
      if(loginsuccess == "true"){
         return DashBoardScreen();
      }
      else{
        return LoginScreen();
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
           child: Image.asset('assets/images/logo_image.png', fit: BoxFit.fill, scale: 1)
        ),
    );
  }
}
