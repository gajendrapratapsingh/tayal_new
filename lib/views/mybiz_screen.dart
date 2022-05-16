import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/ledger_screen.dart';
import 'package:tayal/views/notification_screen.dart';
import 'package:tayal/views/order_list_screen.dart';
import 'package:tayal/views/profile_screen.dart';
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
                    onTap: (){},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/home.svg', fit: BoxFit.fill),
                        Text("Home")
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBizScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/mybiz.svg', fit: BoxFit.fill),
                        Text("My Biz")
                      ],
                    ),
                  ),
                  SizedBox.shrink(),
                  InkWell(
                    onTap: (){},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/reward.svg', fit: BoxFit.fill),
                        Text("Campaign")
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/help.svg', fit: BoxFit.fill),
                        Text("Help")
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
      body: Stack(
        children: [
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
                    const Text("My Biz", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
                    SvgPicture.asset('assets/images/notifications.svg',
                        fit: BoxFit.fill),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                        },
                        child: Container(
                          height: size.height * 0.12,
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                          ),
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
                                  Image.asset('assets/icons/profile_icon.png', scale: 7),
                                  SizedBox(width: 10.0),
                                  Text("Profile", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize: 17.0)),

                              ],
                            ),
                          )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderlistScreen()));
                        },
                        child: Container(
                            height: size.height * 0.12,
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
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
                                  Image.asset('assets/icons/order_icon.png', scale: 7),
                                  SizedBox(width: 10.0),
                                  Text("Orders", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                ],
                              ),
                            )
                        ),
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
                        onTap : (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerStatementScreen()));
                        },
                        child: Container(
                            height: size.height * 0.12,
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
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
                                  Image.asset('assets/icons/ledger_icon.png', scale: 7),
                                  SizedBox(width: 10.0),
                                  Text("Ledger", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                ],
                              ),
                            )
                        ),
                      ),
                      InkWell(
                        onTap : (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerStatementScreen()));
                        },
                        child: Container(
                            height: size.height * 0.12,
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
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
                                  Image.asset('assets/icons/payment_icon.png', scale: 7),
                                  SizedBox(width: 10.0),
                                  Text("Payments", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                ],
                              ),
                            )
                        ),
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
                        onTap : (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WalletStatementScreen()));
                        },
                        child: Container(
                            height: size.height * 0.12,
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
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
                                  Image.asset('assets/icons/referral_icon.png', scale: 7),
                                  SizedBox(width: 10.0),
                                  Text("Referral", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                ],
                              ),
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
                        },
                        child: Container(
                            height: size.height * 0.12,
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
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
                                  Image.asset('assets/icons/help_icon.png', scale: 7),
                                  SizedBox(width: 10.0),
                                  Text("Help", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize: 17.0)),
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                    },
                    child: Container(
                        height: size.height * 0.12,
                        width: size.width * 0.50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                        ),
                        child: Card(
                          elevation: 4.0,
                          color: Colors.indigo.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Image.asset('assets/icons/notification_icon.png', scale: 7),
                              SizedBox(width: 10.0),
                              Text("Notifications", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize: 17.0)),
                            ],
                          ),
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
