import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/wallet_tab_views/transaction_list_screen.dart';
import 'package:tayal/wallet_tab_views/wallet_statement_detail_screen.dart';

class PaymentStatementScreen extends StatefulWidget {
  const PaymentStatementScreen({Key key}) : super(key: key);

  @override
  _PaymentStatementScreenState createState() => _PaymentStatementScreenState();
}

class _PaymentStatementScreenState extends State<PaymentStatementScreen>
    with SingleTickerProviderStateMixin {
  String mobile;
  String walletblnc;

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
                              const Text("Wallet Balance",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Text("\u20B9 $walletblnc",
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
                  text: "LAST 10 TRANSACTIONS",
                ),
                Tab(
                  text: "DETAIL STATEMENT",
                )
              ],
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              // ListView.separated(
              //   itemCount: lastTenTrans.length,
              //   padding: EdgeInsets.zero,
              //   separatorBuilder: (BuildContext context, int index) =>
              //       const Divider(height: 1, color: Colors.grey),
              //   itemBuilder: (BuildContext context, int index) {
              //     if (lastTenTrans.isEmpty || lastTenTrans.length == 0) {
              //       return Center(
              //           child: CircularProgressIndicator(color: Colors.indigo));
              //     } else {
              //       return ListTile(
              //         title: Text('${_txnlist[index]['created_at'].toString()}',
              //             style: TextStyle(
              //                 color: Colors.indigo.shade400, fontSize: 16)),
              //         subtitle: Text(
              //             '${_txnlist[index]['description'].toString()}',
              //             style: TextStyle(color: Colors.grey, fontSize: 12)),
              //         trailing: _txnlist[index]['transaction_type']
              //                     .toString() ==
              //                 "credit"
              //             ? Text(
              //                 '\u20B9 ${_txnlist[index]['update_balance'].toString()} Cr',
              //                 style:
              //                     TextStyle(color: Colors.green, fontSize: 12))
              //             : Text(
              //                 '\u20B9 ${_txnlist[index]['update_balance'].toString()} Dr',
              //                 style:
              //                     TextStyle(color: Colors.red, fontSize: 12)),
              //       );
              //     }
              //   },
              // ),
              WalletStatementTabScrren()
            ],
          ))
        ],
      ),
    );
  }

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + txnstatement),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['Response']['order_id'];
    }
    return [];
  }
}
