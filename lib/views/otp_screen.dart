import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/account_verified_screen.dart';
import 'package:tayal/views/dashboard_screen.dart';

class OtpScreen extends StatefulWidget {

  String phone;
  String otp;
  String type;
  OtpScreen({this.phone, this.otp, this.type});

  @override
  _OtpScreenState createState() => _OtpScreenState(phone, otp, type);
}

class _OtpScreenState extends State<OtpScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userotp;

  String phone;
  String otp;
  String type;
  _OtpScreenState(this.phone, this.otp, this.type);

  bool _loading = false;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
        });
        if(_connectionStatus.toString() == ConnectivityResult.none.toString()){
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please check your internet connection.", style: TextStyle(color: Colors.white)),backgroundColor: Colors.red));
        }
        break;
      default:
        setState(() {
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset('assets/images/back.svg',
                          fit: BoxFit.fill),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Verification",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16)),
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.only(left: 15.0,  top: 5.0, right: 25.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("We sent you an SMS code",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0,  top: 5.0, right: 25.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                 children: [
                                    Text("On number:", style: TextStyle(color: Colors.black, fontSize: 12)),
                                    SizedBox(width: 5.0),
                                    Text("+91 $phone", style: TextStyle(color: Colors.indigo, fontSize: 12),)
                                 ],
                              )
                           )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60.0, top: 80.0, right: 60.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _textFieldOTP(first: true, last: false),
                                _textFieldOTP(first: false, last: false),
                                _textFieldOTP(first: false, last: false),
                                _textFieldOTP(first: false, last: true),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60.0, top: 20.0, right: 60.0, bottom: 10.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: size.width * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: newElevatedButton(),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                               if(type == "login"){
                                 _sendloginotp(phone);
                               }
                               else{
                                 _sendregisterotp(phone);
                               }
                            },
                            child: const Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                                child: Text("Code not received?", textAlign: TextAlign.center, style: TextStyle(color: Colors.indigo, fontSize: 12))
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                left: size.width * 0.20,
                bottom: 15,
                right: size.width * 0.20,
                child: Text("Terms of use & Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700)))
          ],
        ),
      ),
    );
  }

  Widget _textFieldOTP({bool first, last}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.14,
      alignment: Alignment.center,
      child: Card(
        elevation: 4.0,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: TextField(
            autofocus: true,
            onChanged: (value) {
              print(value);
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.length == 0 && first == false) {
                FocusScope.of(context).previousFocus();
              }
              if(userotp == null || userotp == ""){
                setState(() {
                   userotp = value;
                });
              }
              else{
                setState(() {
                  userotp = userotp+value;
                });
              }
              print(userotp);
            },
            showCursor: true,
            readOnly: false,
            cursorColor: Colors.indigo,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 2.0),
              counter: Offstage(),
              hintText: "0",
              border: InputBorder.none
            ),
          ),
        ),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: (){
        if(_connectionStatus.toString() == ConnectivityResult.none.toString()){
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please check your internet connection.", style: TextStyle(color: Colors.white)),backgroundColor: Colors.red));
        }
        else{
          _verifyotp(phone, otp);
          /*if(userotp != otp){
            print(userotp);
            print(otp);
            showToast("Please enter valid otp");
            return;
          }
          else{
            _verifyotp(phone, otp);
          }*/
        }

      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _verifyotp(String phone, String otp) async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    setState(() {
       _loading = true;
    });
    var res = await http.post(Uri.parse(BASE_URL + verifyotp),
      body: {
        "phone": phone,
        "otp" : otp
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      var data = json.decode(res.body);
      if(data['ErrorCode'].toString() == "0"){
        showToast(data['Response'].toString());
        prefs.setString('token', data['token'].toString());
        if(type == "login"){
          prefs.setString('loginsuccess', "true");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountVerifiedScreen()));
        }
      }
      else{}
    }
  }

  Future _sendloginotp(String phone) async {
    setState(() {
      _loading = true;
    });
    var res = await http.post(Uri.parse(BASE_URL + loginsendotp),
      body: {
        "phone": phone,
      },
    );
    if(res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      var data = json.decode(res.body);
      print(data);
      if(data['ErrorCode'].toString() == "100"){
        showToast("OTP : ${data['Response']['otp'].toString().trim()}");
      }
    }
    else{
      setState(() {
        _loading = false;
      });
      showToast('Sorry! Error occured');
    }
  }

  Future _sendregisterotp(String phone) async {
    var res = await http.post(Uri.parse(BASE_URL + sendotp),
      body: {
        "phone": phone,
      },
    );
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      if(data['ErrorCode'].toString() == "100"){
        showToast("OTP : ${data['Response']['otp'].toString().trim()}");
      }
      else{}
    }
  }

}
