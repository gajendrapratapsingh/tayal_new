// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/ledger_screen.dart';
import 'package:tayal/views/notification_screen.dart';
import 'package:tayal/views/order_list_screen.dart';
import 'package:tayal/views/payment_statement_screen.dart';
import 'package:tayal/views/profile_screen.dart';
import 'package:tayal/views/referral_screen.dart';
import 'package:tayal/views/wallet_statement_screen.dart';
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
          onPressed: () {},
          backgroundColor: Colors.indigo,
          child: Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xffBCBEFD),
        child: Container(
            width: size.width,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashBoardScreen()),
                          (route) => false);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/home.svg',
                            fit: BoxFit.fill),
                        Text("Home")
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyBizScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/mybiz.svg',
                            fit: BoxFit.fill),
                        Text("My Biz")
                      ],
                    ),
                  ),
                  SizedBox.shrink(),
                  InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/reward.svg',
                            fit: BoxFit.fill),
                        Text("Campaign")
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HelpScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/help.svg',
                            fit: BoxFit.fill),
                        Text("Help")
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
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
                  SvgPicture.asset('assets/images/notifications.svg',
                      fit: BoxFit.fill),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.9,
                  physics: ClampingScrollPhysics(),
                  children: labels
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => e['page']));
                          },
                          child: Container(
                              // height: size.height * 0.12,
                              // width: size.width * 0.50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Card(
                                elevation: 4.0,
                                color: Colors.indigo.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 15),
                                      Image.asset(e['image'].toString(),
                                          scale: 7),
                                      SizedBox(width: 10.0),
                                      Text(e['label'],
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
