import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/mybiz_screen.dart';
import 'package:tayal/views/notification_screen.dart';
import 'package:tayal/views/product_screen.dart';
import 'package:tayal/widgets/navigation_drawer_widget.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<ProfileResponse>> temp = _getprofile();
    temp.then((value) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', value[0].username.toString());
      prefs.setString('email', value[0].email.toString());
      prefs.setString('mobile', value[0].mobile.toString());
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CategoryScreen()));
      }, backgroundColor: Colors.indigo, child: Icon(Icons.add)),
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
                      onTap: (){
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: SvgPicture.asset('assets/images/menu.svg', fit: BoxFit.fill),
                    ),
                    //SizedBox(width: MediaQuery.of(context).size.width * 0.11),
                    Text("My Dashboard", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
                    //SizedBox(width: MediaQuery.of(context).size.width * 0.11),
                    GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationScreen()));
                        },
                      child: SvgPicture.asset('assets/images/notifications.svg', fit: BoxFit.fill),
                    )
                  ],
                 ),
                 Expanded(
                     child: ListView(
                       shrinkWrap: true,
                       padding: EdgeInsets.zero,
                       scrollDirection: Axis.vertical,
                       children: [
                         Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.only(top: 5.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: const [
                                   Card(
                                     elevation: 4.0,
                                     child: Padding(
                                       padding: EdgeInsets.all(6.0),
                                       child: Text("Month", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                     ),
                                   ),
                                   Card(
                                     elevation: 4.0,
                                     color: Colors.indigo,
                                     child: Padding(
                                       padding: const EdgeInsets.all(6.0),
                                       child: Text("Week", style: TextStyle(color: Colors.white, fontSize: 12)),
                                     ),
                                   ),
                                   Card(
                                     elevation: 4.0,
                                     child: Padding(
                                       padding: const EdgeInsets.all(6.0),
                                       child: Text("Year", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             SizedBox(height: 10),
                             Text("My Total orders", style: TextStyle(color: Colors.grey, fontSize: 14)),
                             SizedBox(height: 5),
                             Text("\u20B9 56456.465", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
                             SizedBox(height: 10),
                             Container(
                               height: 45,
                               width: 120,
                               child: Card(
                                 elevation: 4.0,
                                 child: Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         SvgPicture.asset('assets/images/polygon.svg', fit: BoxFit.cover),
                                         SizedBox(width: 4.0),
                                         Text("\u20B9 987.65", style: TextStyle(color: Colors.indigo, fontSize: 10))
                                       ],
                                     )
                                 ),
                               ),
                             ),
                             SizedBox(height: 20),
                             Padding(
                               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                               child: Container(
                                 height: 120,
                                 width: double.infinity,
                                 child: Text(""),
                               ),
                             ),
                             SizedBox(height: 10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Padding(
                                   padding: EdgeInsets.only(top: 10, left: 7),
                                   child: Card(
                                     shape: RoundedRectangleBorder(
                                       side: BorderSide(color: Colors.white70, width: 1),
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Padding(
                                       padding: EdgeInsets.only(left: 5.0, top: 10, bottom: 10, right: 50),
                                       child: Row(
                                         children: [
                                           SvgPicture.asset('assets/images/bonus_points.svg', fit: BoxFit.fill),
                                           SizedBox(width: 7.0),
                                           Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: const [
                                               Text("Bonus Points", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                               Text("\u20B9 8633.862", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500))
                                             ],
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                                 Padding(
                                   padding: EdgeInsets.only(top: 10, right: 7),
                                   child: Card(
                                     shape: RoundedRectangleBorder(
                                       side: BorderSide(color: Colors.white70, width: 1),
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Padding(
                                       padding: EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 30),
                                       child: Row(
                                         children: [
                                           SvgPicture.asset('assets/images/txn_points.svg'),
                                           SizedBox(width: 7.0),
                                           Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: const [
                                               Text("Transaction Points", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                               Text("\u20B9 8633.862", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500))
                                             ],
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 )
                               ],
                             ),
                             SizedBox(height: 10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Padding(
                                   padding: EdgeInsets.only(left: 7, top: 5),
                                   child: Card(
                                     shape: RoundedRectangleBorder(
                                       side: BorderSide(color: Colors.white70, width: 1),
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Padding(
                                       padding: EdgeInsets.only(left: 5.0, top: 10, bottom: 10, right: 15),
                                       child: Row(
                                         children: [
                                           SvgPicture.asset('assets/images/outstanding_blnc.svg'),
                                           SizedBox(width: 7.0),
                                           Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text("Outstanding Balance", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                               Text("\u20B9 8633.862", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500))
                                             ],
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                                 Padding(
                                   padding: EdgeInsets.only(top: 5, right: 7),
                                   child: Card(
                                     shape: RoundedRectangleBorder(
                                       side: BorderSide(color: Colors.white70, width: 1),
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Padding(
                                       padding: EdgeInsets.only(left: 5.0, top: 10, bottom: 10, right: 15),
                                       child: Row(
                                         children: [
                                           SvgPicture.asset('assets/images/pending_order.svg'),
                                           SizedBox(width: 7.0),
                                           Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text("Pending Order Values", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                               Text("\u20B9 8633.862", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500))
                                             ],
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 )
                               ],
                             ),
                             SizedBox(height: 10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Padding(
                                   padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 20),
                                   child: Text("Recent Order", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                                 ),
                                 Padding(
                                   padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 20),
                                   child: Text("See all", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                                 ),
                               ],
                             ),
                             Padding(
                                 padding: EdgeInsets.only(left: 15 , right: 15, bottom: 30),
                                 child: Card(
                                   color: Colors.grey.shade50,
                                   shape: RoundedRectangleBorder(
                                     side: BorderSide(color: Colors.grey.shade50, width: 1),
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                   child: Padding(
                                     padding: EdgeInsets.all(10),
                                     child: Row(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                           SvgPicture.asset('assets/images/order.svg', fit: BoxFit.fill),
                                           SizedBox(width: 15),
                                           Expanded(
                                               child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Text("Dripple Pro", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                   SizedBox(height: 5),
                                                   Text("23 March", style: TextStyle(color: Colors.grey, fontSize: 16))
                                                 ],
                                               ),
                                           ),
                                           Text("-432433.8", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500))

                                       ],
                                     ),
                                   ),
                                 )
                             )
                           ],
                         )
                       ],
                     )
                 )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ProfileResponse>> _getprofile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL+profile),
        headers : {'Authorization': 'Bearer $mytoken'}
    );
    if (response.statusCode == 200)
    {
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list = list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
