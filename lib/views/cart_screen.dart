import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/loader.dart';
import 'package:tayal/models/cartlistdata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/change_address.dart';
import 'package:tayal/views/checkout_screen.dart';
import 'package:tayal/views/payment_options_screen.dart';
import 'package:tayal/views/product_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String totalprice = "0.0";
  String address = "";
  String userwallet = "";
  String cashback = "";
  int totalitems = 0;

  String nodata = "";
  List mainData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCartData();

    _getCartBadge();
  }

  void _getCartBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalitems = int.parse(prefs.getString('cartcount'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundShapeColor,
        body: nodata == "" || nodata == null
            ? Stack(
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
                                _willPopCallback();
                              },
                              child: SvgPicture.asset('assets/images/back.svg',
                                  fit: BoxFit.fill),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.14),
                            const Text("My Cart",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 5.0),
                          child: Card(
                            color: Colors.indigo.shade100,
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          color: Colors.black, size: 20),
                                      SizedBox(width: 2),
                                      Expanded(child: Text("Deliver to:")),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 25,
                                          width: 90,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              border: Border.all(
                                                  color: Colors.indigo,
                                                  width: 1)),
                                          child: GestureDetector(
                                            child: Text(
                                              address != null
                                                  ? 'Change'
                                                  : 'Add New',
                                              style: const TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 11,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChangeAddressPage()));
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: address == null || address == ""
                                          ? Text("")
                                          : Text(
                                              address.toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12)))
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Cart Items',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                            child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: size.height * 0.10),
                                child: ListView.separated(
                                    itemCount: mainData.length,
                                    padding: EdgeInsets.zero,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(
                                                height: 3, color: Colors.grey),
                                    itemBuilder: (context, index) {
                                      return itemContainer(
                                          index,
                                          mainData,
                                          mainData[index]['id'].toString(),
                                          mainData[index]['cart_id'].toString(),
                                          mainData[index]['product_name']
                                              .toString(),
                                          mainData[index]['product_image']
                                              .toString(),
                                          mainData[index]['quantity']
                                              .toString(),
                                          mainData[index]['amount'].toString(),
                                          mainData[index]['offer_price']
                                              .toString(),
                                          mainData[index]['short_description']
                                              .toString(),
                                          (parse(parse(mainData[index]
                                                              ['group_price']
                                                          .toString())
                                                      .body
                                                      .text)
                                                  .documentElement
                                                  .text)
                                              .toString());
                                    })))
                      ],
                    ),
                  ),
                  Positioned(
                      left: 10,
                      right: 10,
                      bottom: 20,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentOptionsScreen(
                                      payableAmount: totalprice,
                                      walletAmount: userwallet,
                                      cashBack: cashback)));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.indigo,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                totalitems.toString() == "1"
                                    ? Text(totalitems.toString() + " Item",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ))
                                    : Text(totalitems.toString() + " Items",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                const SizedBox(width: 10),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: VerticalDivider(
                                      width: 2, color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    totalprice.toString() != null
                                        ? "\u20B9 $totalprice"
                                        : 0.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                                const Text("Proceed to pay",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5),
                                const Icon(Icons.arrow_forward_ios_rounded,
                                    color: Colors.white, size: 16)
                              ],
                            ),
                          ),
                        ),
                      ))
                ],
              )
            : Stack(
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
                                _willPopCallback();
                              },
                              child: SvgPicture.asset('assets/images/back.svg',
                                  fit: BoxFit.fill),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.14),
                            const Text("My Cart",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: size.height,
                      width: size.width,
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Container(
                              height: 90,
                              width: 90,
                              child:
                                  Image.asset('assets/images/empty_cart.png'),
                            ),
                            SizedBox(height: 10),
                            Text(nodata.toString().toUpperCase(),
                                textAlign: TextAlign.center)
                          ])))
                ],
              ),
      ),
      onWillPop: _willPopCallback,
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Proceed",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckOutScreen(
                      address: address,
                      amount: totalprice,
                    )));
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget itemContainer(
      int index,
      List data,
      String id,
      String cardid,
      String productname,
      String productimage,
      String qty,
      String rate,
      String offerprice,
      String description,
      String groupprice) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
      child: Container(
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    //color: Colors.blue.shade200,
                    border: Border.all(),

                    //     image: DecorationImage(
                    //         image: NetworkImage(productimage),
                    //         fit: BoxFit.fitWidth),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      productimage,
                      scale: 8,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // child: Container(
                //   width: 80,
                //   height: 80,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //     //color: Colors.blue.shade200,
                //     border: Border.all(),

                //     image: DecorationImage(
                //         image: NetworkImage(productimage),
                //         fit: BoxFit.fitWidth),
                //   ),
                // ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productname,
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Row(
                        children: [
                          Text(
                              "\u20B9 " +
                                  mainData[index]['offer_price'].toString(),
                              maxLines: 2,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                          SizedBox(
                            width: 10,
                          ),
                          Text("\u20B9 " + mainData[index]['rate'].toString(),
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough)),
                        ],
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Text(groupprice,
                          maxLines: 2,
                          style: TextStyle(color: Colors.black, fontSize: 10))),
                ],
              ),
              // Expanded(
              //     child: Text("x" + data[index]['quantity'].toString(),
              //         style: const TextStyle(
              //             color: Colors.black,
              //             fontSize: 14,
              //
              // fontWeight: FontWeight.w700))),
              SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Text("\u20B9 " + data[index]['amount'].toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showLaoding(context);
                              setState(() {
                                data[index]['quantity'] = (int.parse(qty) - 1).toString();
                              });
                              _addtocart(
                                      data[index]['id'].toString(),
                                      data[index]['offer_price'].toString(),
                                      data[index]['quantity'].toString(),
                                      data[index]['amount'].toString())
                                  .then((value) {
                                _getCartData();
                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(25 / 2),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.remove,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text("$qty", style: TextStyle(color: Colors.black, fontSize: 14)),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              if(data[index]['quantity'] < data[index]['avaliable_stock']){
                                showLaoding(context);
                                setState(() {
                                  data[index]['quantity'] = (int.parse(qty) + 1).toString();
                                });
                                _addtocart(
                                    data[index]['id'].toString(),
                                    data[index]['offer_price'].toString(),
                                    data[index]['quantity'].toString(),
                                    data[index]['amount'].toString())
                                    .then((value) {
                                  _getCartData();
                                  Navigator.of(context).pop();
                                });
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 1, milliseconds: 500),
                                        backgroundColor: Colors.red,
                                        content: Text('Stock not available', style: TextStyle(color: Colors.white))
                                    )
                                );
                              }
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(25 / 2),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          secondaryActions: <Widget>[
            Container(
              height: 100,
              color: Colors.red,
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () {
                    showAlertDialog(context, cardid.toString());
                  },
                  icon: Icon(Icons.delete_outline,
                      color: Colors.white, size: 32)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + cartlist),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() != "0") {
        setState(() {
          nodata = json.decode(response.body)['ErrorMessage'].toString();
          prefs.setString('cartcount', "0");
        });
      } else {
        setState(() {
          totalprice =
              json.decode(response.body)['Response']['total_price'].toString();
          address =
              json.decode(response.body)['Response']['address'].toString();
          userwallet =
              json.decode(response.body)['Response']['user_wallet'].toString();
          cashback = (parse(parse(json
                          .decode(response.body)['Response']['pay_now_bonus']
                          .toString())
                      .body
                      .text)
                  .documentElement
                  .text)
              .toString();
          //totalitems = json.decode(response.body)['Response']['items'].length;
        });
        Iterable list = json.decode(response.body)['Response']['items'];
        setState(() {
          mainData.clear();
          mainData = list;
          //print(mainData[1]);
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<bool> _addtocart(
      String id, String offerprice, String quantity, String rate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "product_id": id,
      "offer_price": offerprice,
      "rate": (double.parse(rate) * 1).toInt(),
      "quantity": quantity
    };
    var response = await http.post(Uri.parse(BASE_URL + addcart),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    print(jsonEncode({
      "product_id": id,
      "offer_price": offerprice,
      "rate": (double.parse(rate) * 1).toInt(),
      "quantity": quantity
    }));
    // if (response.statusCode == 200) {
    //   print(response.body);

    // } else {
    //   print(response.body);
    //   throw Exception('Failed to get data due to ${response.body}');
    // }
    print(response.body);
    if (json.decode(response.body)['ErrorCode'].toString() == "0") {
      setState(() {
        prefs.setString('cartcount', json.decode(response.body)['Response']['count'].toString());
        totalitems = int.parse(json.decode(response.body)['Response']['count'].toString());
      });
    } else {
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)['ErrorMessage'].toString());
    }
    return true;
  }

  showAlertDialog(BuildContext context, String itemid) {
    Widget cancelButton = FlatButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.pop(context);
        _deleteitemfromCart(itemid);
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Item"),
      content: const Text("Are you sure to delete this item from cart?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _deleteitemfromCart(String itemid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    final body = {
      "cart_id": itemid,
    };
    var response = await http.post(Uri.parse(BASE_URL + cartitemdelete),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      print(response.body);
      if (json.decode(response.body)['ErrorMessage'].toString() == "success") {
        showToast('Item deleted successfully from cart');
        setState(() {
          _getCartData();
          totalprice = json.decode(response.body)['Response']['total_price'].toString();
          totalitems = json.decode(response.body)['Response']['count'];
          prefs.setString('cartcount', json.decode(response.body)['Response']['count'].toString());
        });
      }
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<bool> _willPopCallback() async {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CategoryScreen()));
  }
}
