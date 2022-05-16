// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/views/cart_screen.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/help_screen.dart';
import 'package:tayal/views/mybiz_screen.dart';
import 'package:tayal/views/subcategory_product_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController searchtextController = TextEditingController();

  List<dynamic> _searchResult = [];
  List<dynamic> _categorylist = [];

  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getcategory();

    _getCountBadge();
  }

  Future _getCountBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = int.parse(prefs.getString('cartcount'));

    /*String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + cartlist),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() != "0") {
      } else {
        setState(() {
          _counter = json.decode(response.body)['Response']['items'].length;
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundShapeColor,
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {},
        //     backgroundColor: Colors.indigo,
        //     child: Icon(Icons.add)),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   color: Color(0xffBCBEFD),
        //   child: Container(
        //       width: size.width,
        //       height: 70,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             InkWell(
        //               onTap: () {},
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/home.svg',
        //                       fit: BoxFit.fill),
        //                   Text("Home",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => MyBizScreen()));
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/mybiz.svg',
        //                       fit: BoxFit.fill),
        //                   Text("My Biz",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //             SizedBox.shrink(),
        //             InkWell(
        //               onTap: () {},
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/reward.svg',
        //                       fit: BoxFit.fill),
        //                   Text("Campaign",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => HelpScreen()));
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/icons/help.svg',
        //                       fit: BoxFit.fill),
        //                   Text("Help",
        //                       style: TextStyle(
        //                           color: Colors.indigo.shade500, fontSize: 12))
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       )),
        // ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _willPopCallback();
                        },
                        child: SvgPicture.asset('assets/images/back.svg',
                            fit: BoxFit.fill),
                      ),
                      //SizedBox(width: size.width * 0.17),
                      Text("Choose Category",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 21,
                              fontWeight: FontWeight.w600)),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Badge(
                            animationDuration: Duration(milliseconds: 10),
                            animationType: BadgeAnimationType.scale,
                            badgeContent: Text(
                              '$_counter',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: const Icon(Icons.shopping_basket,
                                color: Colors.grey, size: 28),
                          ),
                          onPressed: () {
                            if (_counter > 0) {
                              Get.offNamed('/cart');
                              //Get.off(CartScreen());
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                            } else {
                              showToast('Your cart is empty');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  /*Padding(
                     padding: EdgeInsets.only(left: 20, right: 20),
                     child: Card(
                       shape: RoundedRectangleBorder(
                         side: BorderSide(color: Colors.white, width: 1),
                         borderRadius: BorderRadius.circular(15),
                       ),
                       child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: 10),
                         child: Row(
                           children: [
                             SvgPicture.asset('assets/images/search.svg'),
                             SizedBox(width: 12),
                             Container(
                               width: size.width * 0.72,
                               alignment: Alignment.centerLeft,
                               child: TextField(
                                 decoration: InputDecoration(
                                       suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: (){
                                       setState(() {
                                         _searchResult.clear();
                                         _searchResult.addAll(_categorylist);
                                         searchtextController.text = "";
                                         FocusScope.of(context).unfocus();
                                       });
                                     },),
                                     border: InputBorder.none,
                                     hintText: "Search",
                                     hintStyle: TextStyle(fontSize: 18.0, color: Colors.indigo.shade100),
                                     focusColor: Colors.indigo
                                 ),
                                 controller: searchtextController,
                                 onChanged: (value){
                                    onSearchTextChanged(value);
                                 },
                               ),
                             )
                           ],
                         ),
                       ),
                     ),
                   ),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Card(
                      elevation: 10,
                      child: ListTile(
                        title: Text("All Category",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  //   child: Align(
                  //       alignment: Alignment.topLeft,
                  //       child: Text("All Category",
                  //           style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w700))),
                  // ),
                  Expanded(
                      child: _searchResult.length == 0
                          ? Center(
                              child: Container(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.indigo),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                padding: EdgeInsets.zero,
                                crossAxisCount: (MediaQuery.of(context).size.width / 180).floor(),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.85,
                                children: _searchResult
                                    .map((e) => InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubCategoryProductScreen(
                                                          categoryid: e['id']
                                                              .toString(),
                                                          categoryname:
                                                              e['category_name']
                                                                  .toString(),
                                                        )));
                                          },
                                          child: Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            borderOnForeground: true,
                                            shadowColor: Colors.teal,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 140,
                                                    width: 140,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image(
                                                          image: NetworkImage(
                                                              e['icon']
                                                                  .toString()),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 45,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          e['category_name']
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              letterSpacing: 1),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            )
                      // GridView.builder(
                      //     itemCount: _searchResult.length,
                      //     padding: EdgeInsets.zero,
                      //     gridDelegate:
                      //         const SliverGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisCount: 2,
                      //             crossAxisSpacing: 2.0,
                      //             mainAxisSpacing: 2.0),
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return InkWell(
                      //           onTap: () {
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         SubCategoryProductScreen(
                      //                           categoryid:
                      //                               _searchResult[index]
                      //                                       ['id']
                      //                                   .toString(),
                      //                           categoryname: _searchResult[
                      //                                       index]
                      //                                   ['category_name']
                      //                               .toString(),
                      //                         )));
                      //           },
                      //           child:

                      //           //  Column(
                      //           //   children: [

                      //           //     Card(
                      //           //       elevation: 2.0,
                      //           //       shape: RoundedRectangleBorder(
                      //           //         side: BorderSide(
                      //           //             color: Colors.grey, width: 0.5),
                      //           //         borderRadius:
                      //           //             BorderRadius.circular(5),
                      //           //       ),
                      //           //       child: Image.network(
                      //           //           _searchResult[index]['icon']
                      //           //               .toString(),
                      //           //           fit: BoxFit.fill),
                      //           //     ),
                      //           //     SizedBox(height: 4.0),
                      //           //     Text(
                      //           //         _searchResult[index]['category_name']
                      //           //             .toString(),
                      //           //         textAlign: TextAlign.center)
                      //           //   ],
                      //           // ),
                      //           );
                      //     },
                      //   )
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

  Future _getcategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + category),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['category'];
      setState(() {
        _searchResult.addAll(list);
        _categorylist.addAll(list);
      });
      //return list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isNotEmpty) {
      List dummyList = [];
      _categorylist.forEach((categoryDetail) {
        if (categoryDetail['category_name']
            .toString()
            .toUpperCase()
            .contains(text.toString().toUpperCase())) {
          dummyList.add(categoryDetail);
        }
      });
      setState(() {
        _searchResult.clear();
        _searchResult.addAll(dummyList);
      });
    } else {
      setState(() {
        FocusScope.of(context).unfocus();
        _searchResult.clear();
        _searchResult.addAll(_categorylist);
      });
    }
  }

  Future<bool> _willPopCallback() async {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
  }
}
