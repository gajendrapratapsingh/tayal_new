// ignore_for_file: prefer_const_constructors

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
  List<String> helplist = [
    "Getting Started with Tayal App",
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
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/images/back.svg',
                            fit: BoxFit.fill)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                    Text("Help",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 21,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                      itemCount: helplist.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(color: Colors.blue),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.80,
                                child: Text(helplist[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.black)
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 90,
            child: InkWell(
              onTap: () {
                showOrderTracking();
              },
              child: Container(
                height: 55,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(29.0)),
                child: const Text("Report and Issue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ),
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 20,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 55,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(29.0),
                    border: Border.all(color: Colors.indigo, width: 1)),
                child: Text("Close",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showOrderTracking() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.attachment),
                            label: Text("Attachment")),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLines: 5,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Report Issue"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29.0),
                            border: Border.all(color: Colors.indigo, width: 1)),
                        child: Text("SUBMIT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ),
                  ]),
            )));
  }
}
