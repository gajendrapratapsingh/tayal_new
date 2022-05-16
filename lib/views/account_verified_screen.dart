import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/login_screen.dart';
import 'package:tayal/views/selected_product_screen.dart';

class AccountVerifiedScreen extends StatefulWidget {
  const AccountVerifiedScreen({Key key}) : super(key: key);

  @override
  _AccountVerifiedScreenState createState() => _AccountVerifiedScreenState();
}

class _AccountVerifiedScreenState extends State<AccountVerifiedScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset('assets/images/back.svg', fit: BoxFit.fill),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                    Text("Login", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
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
                            child: Text("Your Account has been verified", style: TextStyle(color: Colors.black, fontStyle: FontStyle.normal, fontSize: 14)),
                          ),
                        ),
                        SizedBox(height: 50),
                        Container(
                          height: 300,
                          child: Image.asset('assets/images/login_main_image.png', fit: BoxFit.fill),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Thank you!", style: TextStyle(color: Colors.black, fontStyle: FontStyle.normal, fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0, right: 25.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Your data is being processed and you can already enjoy all features of the application", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontStyle: FontStyle.normal, fontSize: 15)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: size.width * 0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(29),
                            child: newElevatedButton(),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Let's go",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () async{
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
    );
  }
}
