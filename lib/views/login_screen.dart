import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/components/OrDivider.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/otp_screen.dart';
import 'package:tayal/views/selected_product_screen.dart';
import 'package:tayal/views/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String phoneNumber = "";
  int phonemaxLength = 10;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                        },
                        child: SvgPicture.asset('assets/images/back.svg'),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                      Text("Login", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Align(
                               alignment: Alignment.topLeft,
                               child: Text("Welcome Back", style: TextStyle(color: Colors.black, fontStyle: FontStyle.normal, fontSize: 28, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Sign in to continue", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.normal, fontSize: 16)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              child: Card(
                                elevation: 5,
                                shape:  RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: size.width * 0.28,
                                      child: CountryCodePicker(
                                        onChanged: (value){
                                        },
                                        initialSelection: 'IN',
                                        favorite: ['+91', 'IN'],
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: true,
                                        enabled: true,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                      child: VerticalDivider(
                                        thickness: 1,
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: TextField(
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Phone Number",
                                          ),
                                          onChanged: (value) {
                                            phoneNumber = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /*Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(color: Colors.grey.shade400, width: 1.5)
                            ),
                            child: TextField(
                              onChanged: (value){},
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                  hintText: "User Name",
                                  border: InputBorder.none
                              ),
                            ),
                          ),*/
                          /*Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(color: Colors.grey.shade400, width: 1.5)
                            ),
                            child: TextField(
                              onChanged: (value){},
                              obscureText: _checkpwdvisibility,
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none,
                                  suffixIcon: _checkpwdvisibility == true ? IconButton(onPressed: (){}, icon: Icon(Icons.visibility, size: 24)) : IconButton(onPressed: (){}, icon: Icon(Icons.visibility_off, size: 24))
                              ),
                            ),
                          ),*/
                          /*Padding(
                            padding: const EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Forget Password?", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.normal, fontSize: 16)),
                            ),
                          ),*/
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: size.width * 0.9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(29),
                              child: newElevatedButton(),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 5, top: 25, right: 5, bottom: 10),
                              child: OrDivider(),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(29),
                                  border: Border.all(color: Colors.grey.shade400, width: 1)
                              ),
                              child: Text("Sign up with Email", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                            ),
                          ),
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
                child: Text("Terms of use & Privacy Policy", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500, fontSize: 14.0, fontWeight: FontWeight.w700))
            )
          ],
        ),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text("Log in", style: TextStyle(color: Colors.white, fontSize: 18)),
      onPressed: (){
        if(phoneNumber.toString().trim().length == 0 || phoneNumber.toString().trim().length != 10){
          showToast("Enter valid mobile number");
        }
        else{
          _sendOtp(phoneNumber);
        }

      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _sendOtp(String phone) async {
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(
          phone : phone,
          otp : data['Response']['otp'].toString().trim(),
          type : "login"
        )));
      }
      else if(data['ErrorCode'].toString() == "902"){
         showToast('Your Account is under review yet.');
      }
      else{
        showToast('User not exists');
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
      }
    }
    else{
      setState(() {
        _loading = false;
      });
      showToast('Sorry! Error occured');
    }
  }
}
