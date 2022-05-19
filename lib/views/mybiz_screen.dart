// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/ledger_screen.dart';
import 'package:tayal/views/notification_screen.dart';
import 'package:tayal/views/order_list_screen.dart';
import 'package:tayal/views/payment_statement_screen.dart';
import 'package:tayal/views/profile_screen.dart';
import 'package:tayal/views/referral_screen.dart';
import 'package:tayal/views/wallet_statement_screen.dart';
import 'package:tayal/widgets/bottom_appbar.dart';
import 'package:tayal/widgets/navigation_drawer_widget.dart';

class MyBizScreen extends StatefulWidget {
  const MyBizScreen({Key key}) : super(key: key);

  @override
  _MyBizScreenState createState() => _MyBizScreenState();
}

class _MyBizScreenState extends State<MyBizScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  List labels = [
    {
      "label": "Profile",
      "image": "assets/icons/profile_icon.png",
      "page": ProfileScreen()
    },
    {
      "label": "Order",
      "image": "assets/icons/order_icon.png",
      "page": OrderlistScreen()
    },
    {
      "label": "Ledger",
      "image": "assets/icons/ledger_icon.png",
      "page": LedgerStatementScreen(
        title: "Ledger",
      )
    },
    {
      "label": "Payments",
      "image": "assets/icons/payment_icon.png",
      "page": PaymentStatementScreen()
    },
    {
      "label": "Wallet",
      "image": "assets/icons/waller.png",
      "page": WalletStatementScreen()
    },
    {
      "label": "Help",
      "image": "assets/icons/help_icon.png",
      "page": HelpScreen()
    },
    {
      "label": "Referal",
      "image": "assets/icons/referal.png",
      "page": ReferralScreen()
    },
    {
      "label": "Notifications",
      "image": "assets/icons/notification_icon.png",
      "page": NotificationScreen()
    }
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: kBackgroundShapeColor,
      drawer: NavigationDrawerWidget(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CategoryScreen()));
          },
          backgroundColor: Colors.indigo,
          child: Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xffBCBEFD),
        child: MyBottomAppBar(),
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: SvgPicture.asset('assets/images/menu.svg',
                        fit: BoxFit.fill),
                  ),
                  const Text("My Biz",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 21,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                    child: SvgPicture.asset('assets/images/notifications.svg',
                        fit: BoxFit.fill),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15),
                                Image.asset('assets/icons/profile_icon.png',
                                    scale: 7),
                                SizedBox(width: 10.0),
                                const Text("Profile",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderlistScreen()));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15),
                                Image.asset('assets/icons/order_icon.png',
                                    scale: 7),
                                SizedBox(width: 10.0),
                                const Text("Orders",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LedgerStatementScreen(
                                      title: "Ledger",
                                    )));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15),
                                Image.asset('assets/icons/ledger_icon.png',
                                    scale: 7),
                                SizedBox(width: 10.0),
                                const Text("Ledger",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentStatementScreen()));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 15),
                                Image.asset('assets/icons/payment_icon.png',
                                    scale: 7),
                                const SizedBox(width: 10.0),
                                const Text("Payments",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReferralScreen()));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 15),
                                Image.asset('assets/icons/referral_icon.png',
                                    scale: 7),
                                const SizedBox(width: 10.0),
                                const Text("Referral",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen()));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15),
                                Image.asset('assets/icons/help_icon.png',
                                    scale: 7),
                                SizedBox(width: 10.0),
                                const Text("Help",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletStatementScreen()));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15),
                                Image.asset('assets/icons/wallet_icon.jpeg',
                                    scale: 7),
                                SizedBox(width: 10.0),
                                const Text("Wallet",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()));
                      },
                      child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.49,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Card(
                            elevation: 4.0,
                            color: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 8),
                                Image.asset(
                                    'assets/icons/notification_icon.png',
                                    scale: 7),
                                SizedBox(width: 10.0),
                                const Text("Notifications",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0)),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
