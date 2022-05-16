import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/views/dashboard_screen.dart';

class ThankuScreen extends StatefulWidget {

  String orderid;
  ThankuScreen({this.orderid});

  @override
  _ThankuScreenState createState() => _ThankuScreenState(orderid);

}

class _ThankuScreenState extends State<ThankuScreen> {

  String orderid;
  _ThankuScreenState(this.orderid);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
         backgroundColor: Colors.white,
         body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                       InkWell(
                         onTap: (){
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
                         },
                         child: SvgPicture.asset('assets/images/back.svg', fit: BoxFit.fill),
                       )
                    ],
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/images/confirmation.png', fit: BoxFit.fill),
                        const SizedBox(height: 10),
                        const Text("Thank you!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 21)),
                        const SizedBox(height: 10),
                        const Text("Your purchase is confirmed", style: TextStyle(color: Colors.black, fontSize: 16)),
                        const SizedBox(height: 20),
                        const Text("Your order id", style: TextStyle(color: Colors.black, fontSize: 14)),
                        Text('$orderid', style: TextStyle(color: Colors.indigo, fontSize: 12, decoration: TextDecoration.underline))
                      ],
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: _willPopCallback,
    );
  }

  Future<bool> _willPopCallback() async {
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
  }
}
