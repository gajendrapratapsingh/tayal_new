// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;

class OrderDetailScreen extends StatefulWidget {
  String orderid;
  OrderDetailScreen({this.orderid});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState(orderid);
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String orderid;
  _OrderDetailScreenState(this.orderid);

  Future _myorderdetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myorderdetail = _getorderdetail(orderid);
    _gettrackingDetails(orderid);
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  ReceivePort _port = ReceivePort();
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  String _saveDir;
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _setPath(String filepath) async {
    // if (await Permission.storage.request().isGranted) {
    print(filepath);
    final externalDir = await getApplicationDocumentsDirectory();
    print(externalDir);
    String fileName = DateTime.now().toString() + ".pdf";
    final id = await FlutterDownloader.enqueue(
        url: filepath,
        savedDir: externalDir.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
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
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/images/back.svg',
                            fit: BoxFit.fill),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.10),
                      Text("Order Detail",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 21,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                      height: size.height * 0.76,
                      width: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        children: [
                          Column(
                            children: <Widget>[
                              FutureBuilder(
                                  future: _myorderdetail,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            child: Card(
                                              elevation: 0,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Order on ${snapshot.data['created_at'].toString()}",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 10)),
                                                    const SizedBox(height: 5.0),
                                                    Text(
                                                        "Order Status : ${snapshot.data['order_status'].toString()}",
                                                        style: TextStyle(
                                                            color:
                                                            Colors.indigo,
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500)),
                                                    SizedBox(height: 5.0),
                                                    Row(
                                                      children: [
                                                        snapshot.data['payment_mode']
                                                            .toString() ==
                                                            "Cash On Delivery"
                                                            ? Image.asset(
                                                            'assets/images/cash_pay.png',
                                                            scale: 2)
                                                            : Image.asset(
                                                            'assets/images/online_pay.png',
                                                            scale: 2),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            "${snapshot.data['payment_mode'].toString()}",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontSize: 12))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showOrderTracking(snapshot
                                                  .data['order_status']
                                                  .toString());
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              child: Card(
                                                elevation: 0,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("Order History", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w700)),
                                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.indigo.shade400, size: 20)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Card(
                                              color: Colors.grey[50],
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "${snapshot.data['items'].length} items",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontSize: 10)),
                                                        const SizedBox(
                                                            width: 15),
                                                        Expanded(
                                                            child: Text(
                                                                "Order id: ${snapshot.data['order_number'].toString()}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                    10))),
                                                        Container(
                                                          height: 30,
                                                          width: 80,
                                                          alignment:
                                                          Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color:
                                                              Colors.indigo,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  5)),
                                                          child: Text("reorder",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                  10)),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      height: 30,
                                                      width: size.width * 0.45,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(5),
                                                          border: Border.all(
                                                              color:
                                                              Colors.indigo,
                                                              width: 1)),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 5.0,
                                                            right: 5.0),
                                                        child: Row(
                                                          children: const [
                                                            Icon(
                                                                Icons
                                                                    .analytics_outlined,
                                                                color: Colors
                                                                    .indigo,
                                                                size: 12),
                                                            SizedBox(width: 5),
                                                            Text(
                                                                "Download summary",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .indigo,
                                                                    fontSize:
                                                                    12))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: double.infinity,
                                                      child: ListView.separated(
                                                          itemCount: snapshot
                                                              .data['items']
                                                              .length,
                                                          padding:
                                                          EdgeInsets.zero,
                                                          shrinkWrap: true,
                                                          separatorBuilder:
                                                              (BuildContext
                                                          context,
                                                              int
                                                              index) =>
                                                              Divider(
                                                                height: 1,
                                                                color: Colors
                                                                    .grey[
                                                                300],
                                                              ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsets
                                                                    .all(5),
                                                                child: Row(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          10),
                                                                      child:
                                                                      Container(
                                                                        height:
                                                                        80,
                                                                        width:
                                                                        80,
                                                                        child:
                                                                        CachedNetworkImage(
                                                                          imageUrl: snapshot
                                                                              .data['items'][index]['product_image']
                                                                              .toString(),
                                                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                              Center(child: CircularProgressIndicator(value: downloadProgress.progress, color: Colors.indigo)),
                                                                          errorWidget: (context, url, error) =>
                                                                              Image.asset('assets/images/no_image.jpg'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                        10),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text("${snapshot.data['items'][index]['product_name'].toString()}",
                                                                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                                            SizedBox(width: 7),
                                                                            Text("\u20B9 ${snapshot.data['items'][index]['offer_price'].toString()}",
                                                                                style: TextStyle(color: Colors.black, fontSize: 12))
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                            5.0),
                                                                        Text(
                                                                            "Quantity : ${snapshot.data['items'][index]['quantity'].toString()}",
                                                                            style:
                                                                            TextStyle(color: Colors.grey, fontSize: 12)),
                                                                        SizedBox(
                                                                            height:
                                                                            5.0),
                                                                        Row(
                                                                          children: [
                                                                            Text("\u20B9 ${snapshot.data['items'][index]['price'].toString()}",
                                                                                style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                                                                            SizedBox(width: 15),
                                                                            Text("\u20B9 ${snapshot.data['items'][index]['offer_price'].toString()} x ${snapshot.data['items'][index]['quantity'].toString()}",
                                                                                style: TextStyle(color: Colors.black, fontSize: 12)),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Card(
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 20,
                                                      width: double.infinity,
                                                      color:
                                                      Colors.grey.shade100,
                                                      child: Text(
                                                          "Payment Summary",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                              Colors.grey,
                                                              fontSize: 12))),
                                                  Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text("Total",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontSize: 14)),
                                                        Text(
                                                            "\u20B9 ${snapshot.data['total'].toString()}",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontSize: 14))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: const [
                                                        Text("Delivery charges",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontSize: 14)),
                                                        Text("\u20B9 0.0",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontSize: 14))
                                                      ],
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: Divider(
                                                        height: 1,
                                                        color: Colors.grey),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "Final paid amount",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                        Text(
                                                            "\u20B9 ${snapshot.data['total'].toString()}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.indigo));
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ))
                ],
              )),
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 45,
                color: Colors.indigo,
                alignment: Alignment.center,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_call, color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Text("customer support",
                        style: TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future _getorderdetail(String orderid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "order_id": orderid,
    };
    var response = await http.post(Uri.parse(BASE_URL + orderdetail),
        body: body, headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      return data;
      /*setState(() {
         _orderlistdata.addAll(list);
      });*/
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _gettrackingDetails(String orderid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      // "order_number": orderid,
      "order_number": "DL20000059"
    };
    var response = await http.post(Uri.parse(BASE_URL + ordertimeline),
        body: body, headers: {'Authorization': 'Bearer $mytoken'});
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      setState(() {
        orderTimeliveData = jsonDecode(response.body)['Response'];
      });
    }
  }

//  "order_placed_at": "2022-05-12 15:40:17",
//         "accepted_at": "",
//         "invoice": {
//             "invoiced_at": "12-May-2022 09:10:17 PM",
//             "invoice_url": "https://dev.techstreet.in/tayal/public/print/invoice/invoice6281f10e8cf57DL20000059.pdf",
//             "invoice_remark": "Invoice- TCIN00001"
//         },
//         "cancelled_at": "",
//         "rejected_at": "",
//         "shipping": {
//             "shipped_at": "",
//             "shipping_doc_url": "",
//             "shipping_remark": ""
//         },
//         "completed_at": ""

  Map orderTimeliveData = {};
  List listItems = [
    {"label": "Compeleted", "id": "completed_at"},
    {"label": "Shipped", "id": "shipping"},
    {"label": "Rejected", "id": "rejected_at"},
    {"label": "Cancelled", "id": "cancelled_at"},
    {"label": "Invoice", "id": "invoice"},
    {"label": "Accepted", "id": "accepted_at"},
    {"label": "Added", "id": "order_placed_at"},
  ];
  Future<void> showOrderTracking(orderStatus) async {
    Size size = MediaQuery.of(context).size;
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order No. : ' + orderid.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        Text(
                          'Current Status : ' + orderStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 0,
                          ),
                          itemCount: listItems.length,
                          itemBuilder: (context, index) {
                            String label = "";
                            String time = "";
                            String remarks = "";
                            String url = "";

                            switch (listItems[index]['id'].toString()) {
                              case "order_placed_at":
                                label = listItems[index]['label'].toString();
                                time = orderTimeliveData[
                                listItems[index]['id'].toString()]
                                    .toString();
                                url = "";
                                remarks = "";

                                break;
                              case "accepted_at":
                                label = listItems[index]['label'].toString();
                                time = orderTimeliveData[
                                listItems[index]['id'].toString()]
                                    .toString();
                                url = "";
                                remarks = "";
                                break;
                              case "invoice":
                                label = listItems[index]['label'].toString();
                                time = orderTimeliveData[listItems[index]['id']
                                    .toString()]['invoiced_at']
                                    .toString();

                                url = orderTimeliveData[listItems[index]['id']
                                    .toString()]['invoice_url']
                                    .toString();
                                remarks = orderTimeliveData[
                                listItems[index]['id'].toString()]
                                ['invoice_remark']
                                    .toString();
                                break;
                              case "cancelled_at":
                                label = listItems[index]['label'].toString();
                                time = orderTimeliveData[
                                listItems[index]['id'].toString()]
                                    .toString();
                                url = "";
                                remarks = "";
                                break;
                              case "rejected_at":
                                label = listItems[index]['label'].toString();
                                time = orderTimeliveData[
                                listItems[index]['id'].toString()]
                                    .toString();
                                url = "";
                                remarks = "";
                                break;
                              case "shipping":
                                label = listItems[index]['label'].toString();
                                time = orderTimeliveData[listItems[index]['id']
                                    .toString()]['shipped_at']
                                    .toString();
                                url = orderTimeliveData[listItems[index]['id']
                                    .toString()]['shipping_doc_url']
                                    .toString();
                                remarks = orderTimeliveData[
                                listItems[index]['id'].toString()]
                                ['shipping_remark']
                                    .toString();
                                break;
                              case "completed_at":
                                label = listItems[index]['label'].toString();
                                time = orderTimeliveData[
                                listItems[index]['id'].toString()]
                                    .toString();
                                url = "";
                                remarks = "";
                                break;
                            }

                            return time.isEmpty
                                ? SizedBox()
                                : Stack(
                              children: [
                                Positioned(
                                  left: 20,
                                  child: new Container(
                                    height: size.height * 0.7,
                                    width: 1.0,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                // Positioned(
                                //     left: 20,
                                //     // top: 60,
                                //     child: DottedLine(
                                //       direction: Axis.vertical,
                                //       lineLength: 70,
                                //       lineThickness: 5,
                                //       dashRadius: 100,
                                //       dashLength: 4.0,
                                //       dashColor: Color(0xffF3442C),
                                //       dashGapLength: 4.0,
                                //       dashGapColor: Colors.transparent,
                                //       dashGapRadius: 100,
                                //     )),
                                Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(50, 20, 40, 20),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(label,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.w600)),
                                      remarks.isEmpty
                                          ? SizedBox()
                                          : Text(remarks.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w400)),
                                      url.isEmpty
                                          ? SizedBox()
                                          : InkWell(
                                        onTap: () {
                                          _setPath(url);
                                        },
                                        child: Text("Download",
                                            style:
                                            TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                color: Colors
                                                    .blue)),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    bottom: url.isEmpty ? -30 : 10,
                                    left: -40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Container(
                                        height: 40.0,
                                        width: 40.0,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.check,
                                            color: Color(0xffF3442C),
                                          ),
                                          onTap: () async {},
                                        ),
                                        decoration: new BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                "assets/icons/order_icon.jpg",
                                              ),
                                              fit: BoxFit.fill,
                                              scale: 1),
                                          // borderRadius:
                                          //     BorderRadius.circular(50),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    right: 20,
                                    top: 25,
                                    child: Text(
                                        time
                                            .replaceFirst(" ", "\n")
                                            .replaceAll("-", " "),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w600))),
                              ],
                            );
                          })),
                ])));
  }
}
