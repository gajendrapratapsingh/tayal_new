import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/account_verified_screen.dart';
import 'package:tayal/views/dashboard.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/select_catagory.dart';

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
  String fcmToken = "";
  OTPTextEditController controller;
  OTPInteractor _otpInteractor;

  TextEditingController otpControll = TextEditingController();

  void listenSMS() async {
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));

    controller = OTPTextEditController(
      codeLength: 4,
      autoStop: true,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          print(code);
          String OTP = code.replaceAll(new RegExp(r'[^0-9]'), '');
          print(OTP.toString());

          setState(() {
            otpControll.text = "";
            userotp = "";
            otpControll.text = OTP.toString();
            userotp = OTP.toString();
          });
          clickSubmit();
          final exp = RegExp(r'(\d{4})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        // strategies: [
        //   // SampleStrategy(),
        // ],
      );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value.toString();
        print(fcmToken);
      });
    });
    initConnectivity();
    listenSMS();
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
        if (_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Please check your internet connection.",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
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
      appBar: AppBar(
        backgroundColor: appbarcolor,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              "assets/images/back.png",
              scale: 20,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text("Verification",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  //     SvgPicture.asset('assets/images/back.svg',
                  //         fit: BoxFit.fill),
                  //   ],
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 5.0, right: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("We sent you an sms code",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 5.0, right: 25.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Text("On number:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                      SizedBox(width: 5.0),
                                      Text(
                                        "+91 $phone",
                                        style: TextStyle(
                                            color: Colors.indigo, fontSize: 12),
                                      )
                                    ],
                                  ))),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 60.0,
                                  top: 80.0,
                                  right: 60.0,
                                  bottom: 10.0),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  // activeFillColor: Colors.white,
                                ),
                                cursorColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                // enableActiveFill: true,

                                controller: otpControll,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {},
                                onChanged: (value) {},
                              )
                              // OtpTextField(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              //   numberOfFields: 4,
                              //   borderWidth: 2,
                              //   enabledBorderColor: Color(0xffD6BBFB),
                              //   focusedBorderColor: Colors.indigo,
                              //   disabledBorderColor: Color(0xffD6BBFB),
                              //   keyboardType: TextInputType.phone,
                              //   borderColor: Color(0xffD6BBFB),
                              //   //set to true to show as box or false to show as dash
                              //   showFieldAsBox: true,
                              //   textStyle: TextStyle(
                              //       fontSize: 15, fontWeight: FontWeight.bold),
                              //   fieldWidth: 50,

                              //   onCodeChanged: (String code) {
                              //     //handle validation or checks here
                              //     setState(() {
                              //       userotp = code;
                              //     });
                              //   },
                              //   //runs when every textfield is filled
                              //   onSubmit: (String code) {
                              //     setState(() {
                              //       userotp = code;
                              //     });
                              //   }, // end onSubmit
                              //   autoFocus: true,
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     _textFieldOTP(first: true, last: false),
                              //     _textFieldOTP(first: false, last: false),
                              //     _textFieldOTP(first: false, last: false),
                              //     _textFieldOTP(first: false, last: true),
                              //   ],
                              // ),
                              ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60.0,
                                top: 20.0,
                                right: 60.0,
                                bottom: 10.0),
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
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                userotp = "";
                                otpControll.text = "";
                              });
                              if (type == "login") {
                                _sendloginotp(phone);
                              } else {
                                _sendregisterotp(phone);
                              }
                            },
                            child: const Padding(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 10.0),
                                child: Text("Re-Send OTP.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 12))),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //     left: size.width * 0.20,
            //     bottom: 15,
            //     right: size.width * 0.20,
            //     child: Text("Terms of use & Privacy Policy",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //             color: Colors.grey.shade500,
            //             fontSize: 14.0,
            //             fontWeight: FontWeight.w700)))
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
              if (value.isEmpty) {
                setState(() {
                  userotp = "";
                });
              } else {
                setState(() {
                  userotp = userotp + value;
                });
                print(userotp);
              }
              // print(value);
              // if (value.length == 1 && last == false) {
              //   FocusScope.of(context).nextFocus();
              // }
              // if (value.length == 0 && first == false) {
              //   FocusScope.of(context).previousFocus();
              // }
              // if (userotp == null || userotp == "") {
              //   setState(() {
              //     userotp = value;
              //   });
              // } else {
              //   setState(() {
              //     userotp = userotp + value;
              //   });
              // }
            },
            showCursor: true,
            readOnly: false,
            cursorColor: Colors.indigo,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 1,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 2.0),
                counter: Offstage(),
                hintText: "",
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  void clickSubmit() async {
    if (_connectionStatus.toString() == ConnectivityResult.none.toString()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Please check your internet connection.",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red));
    } else {
      _verifyotp(phone, userotp, fcmToken);
    }
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        clickSubmit();
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _verifyotp(String phone, String otp, String fcm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    var res = await http.post(
      Uri.parse(BASE_URL + verifyotp),
      body: {"phone": phone, "otp": otp, "fcm": fcm.toString()},
    );
    print({"phone": phone, "otp": otp, "fcm": fcm.toString()});
    print(res.body);
    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      var data = json.decode(res.body);
      print(jsonDecode(res.body)['register_category_count']);
      print(jsonDecode(res.body)['user_category']);
      print(jsonDecode(res.body)['show_category_selection']);
      prefs.setString('show_category_selection',
          jsonDecode(res.body)['show_category_selection'].toString());
      if (data['ErrorCode'].toString() == "0") {
        showToast(data['Response'].toString());
        prefs.setString('token', data['token'].toString());

        if (type == "login") {
          prefs.setString('loginsuccess', "true");

          if (jsonDecode(res.body)['show_category_selection']) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SelectCatagory()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          }
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SelectCatagory()));
        }
      } else {}
    }
  }

  Future _sendloginotp(String phone) async {
    setState(() {
      _loading = true;
    });
    var res = await http.post(
      Uri.parse(BASE_URL + loginsendotp),
      body: {
        "phone": phone,
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      var data = json.decode(res.body);
      print(data);
      if (data['ErrorCode'].toString() == "100") {
        showToast("OTP Sent");
        listenSMS();
      }
    } else {
      setState(() {
        _loading = false;
      });
      showToast('Sorry! Error occured');
    }
  }

  Future _sendregisterotp(String phone) async {
    var res = await http.post(
      Uri.parse(BASE_URL + sendotp),
      body: {
        "phone": phone,
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      if (data['ErrorCode'].toString() == "100") {
        showToast("OTP Sent");
        listenSMS();
      } else {}
    }
  }
}

class SampleStrategy extends OTPStrategy {
  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => 'Your code is 5432',
    );
  }
}
