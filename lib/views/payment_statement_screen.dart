// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/wallet_tab_views/payment_statement_detail_screen.dart';
import 'package:tayal/wallet_tab_views/transaction_list_screen.dart';
import 'package:tayal/wallet_tab_views/wallet_statement_detail_screen.dart';

class PaymentStatementScreen extends StatefulWidget {
  const PaymentStatementScreen({Key key}) : super(key: key);

  @override
  _PaymentStatementScreenState createState() => _PaymentStatementScreenState();
}

class _PaymentStatementScreenState extends State<PaymentStatementScreen>
    with SingleTickerProviderStateMixin {
  String mobile = "";
  String walletblnc = "";
  double pendingTotal = 0;
  TabController _tabController;

  List lastTenTrans = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<ProfileResponse>> temp = _getprofile();
    temp.then((value) {
      setState(() {
        mobile = value[0].mobile.toString();
        walletblnc = value[0].userWallet.toString();
      });
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _lastTenTransaction().then((value) => setState(() {
          lastTenTrans.addAll(value);
        }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
          children: [
            Container(
              height: 145,
              color: Colors.indigo,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white)),
                        Text("Payment",
                            style: TextStyle(color: Colors.white, fontSize: 16))
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.white),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.48,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                const Text("Mobile Number",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text('$mobile',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.04,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                            child: VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.48,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Pending Balance",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text("\u20B9 " + pendingTotal.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.indigo,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.white,
                labelColor: Colors.white,
                controller: _tabController,
                tabs: [
                  Tab(
                    text: "PENDING PAYMENTS",
                  ),
                  Tab(
                    text: "COMPLETED PAYMENTS",
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                lastTenTrans.length == 0
                    ? Center(
                        child: Text("Date not found"),
                      )
                    : ListView.separated(
                        itemCount: lastTenTrans.length,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(height: 1, color: Colors.grey),
                        itemBuilder: (BuildContext context, int index) {
                          if (lastTenTrans.isEmpty ||
                              lastTenTrans.length == 0) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.indigo));
                          } else {
                            return ListTile(
                              title: Text(
                                  lastTenTrans[index]['created_at'].toString(),
                                  style: TextStyle(
                                      color: Colors.indigo.shade400,
                                      fontSize: 16)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Order Id - ' +
                                          lastTenTrans[index]['order_id']
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  // Text(
                                  //     'Payment Mode - ' +
                                  //         lastTenTrans[index]['payment_method'],
                                  //     style: TextStyle(
                                  //         color: Colors.grey, fontSize: 12)),
                                  Text(
                                      'Status - ' +
                                          lastTenTrans[index]['payment_status']
                                              .toString()
                                              .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              onTap: () {
                                if (lastTenTrans[index]['checked'] == true) {
                                  setState(() {
                                    lastTenTrans[index]['checked'] = false;
                                  });
                                } else {
                                  setState(() {
                                    lastTenTrans[index]['checked'] = true;
                                  });
                                }
                              },
                              minLeadingWidth: 2,
                              leading: lastTenTrans[index]['checked']
                                  ? Icon(
                                      Icons.check_box,
                                      color: Colors.grey,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.grey,
                                    ),
                              trailing: Text(
                                  '\u20B9 ' +
                                      lastTenTrans[index]['amount'].toString(),
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            );
                          }
                        },
                      ),
                PaymentStatementTabScreen()
              ],
            ))
          ],
        ),
        bottomSheet: _tabController.index == 0
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 70,
                  width: double.infinity,
                  color: Colors.indigo,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            selectAll = !selectAll;
                          });
                          if (selectAll) {
                            lastTenTrans.forEach((element) {
                              setState(() {
                                element['checked'] = true;
                              });
                            });
                          } else {
                            lastTenTrans.forEach((element) {
                              setState(() {
                                element['checked'] = false;
                              });
                            });
                          }
                        },
                        icon: selectAll
                            ? Icon(
                                Icons.check_box,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.white,
                              ),
                        label: Text("Select All",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: Text("Pay Now",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ),
                    ],
                  ),
                ))
            : SizedBox());
  }

  bool selectAll = true;
  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + profile),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      print(response.body);
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list =
          list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<List> _lastTenTransaction() async {
    List data = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + txnstatement),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      List temp = jsonDecode(response.body)['Response']['order_id'];

      temp.forEach((element) {
        if (element['payment_status'] == "pending") {
          element['checked'] = true;
          data.add(element);

          pendingTotal =
              pendingTotal + double.tryParse(element['amount'].toString());
        }
      });

      return data;
    }
    return [];
  }
}
