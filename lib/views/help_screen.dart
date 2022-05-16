import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/themes/constant.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  List<String> helplist = ["Getting Started with Tayal App",
    "Is it safe to connect my bank account with Tayal App",
    "Can't connect? Switching to?",
    "All about currencies",
    "Hot to create an AUTOMATIC RULE?",
    "How do I create a Budget?",
    "How to add a Credit Card?"
  ];

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
                    Text("Help", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                      itemCount: helplist.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.blue),
                      itemBuilder: (BuildContext context,int index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                          child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                SizedBox(
                                  width: size.width * 0.80,
                                  child: Text(helplist[index], style: TextStyle(color: Colors.black, fontSize: 16)),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black)
                             ],
                          ),
                        );
                      }
                  ),
                )
              ],
            ),
          ),
          Positioned(
              left: 25,
              right: 25,
              bottom: 90,
              child: Container(
                 height: 55,
                 width: double.infinity,
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(29.0)
                 ),
                 child: const Text("Report and Issue", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 20,
            child: Container(
              height: 55,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29.0),
                  border: Border.all(color: Colors.indigo, width: 1)
              ),
              child: Text("Close", textAlign: TextAlign.center, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),

        ],
      ),
    );
  }
}
