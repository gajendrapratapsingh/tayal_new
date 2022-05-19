import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/themes/constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:tayal/views/profile_screen.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key key}) : super(key: key);

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool _loading = false;
  String referralcode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<ProfileResponse>> temp = _getprofile();
    temp.then((value) {
      setState(() {
        referralcode = value[0].referralCode.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Stack(
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
                          _willPopCallback();
                        },
                        child: SvgPicture.asset('assets/images/back.svg',
                            fit: BoxFit.fill),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                      const Text("Referral",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 21,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Card(
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, top: 8.0, bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("My Referral Code",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        referralcode == "" ||
                                                referralcode == null
                                            ? Text("")
                                            : Text(referralcode,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14))
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _onShare(context, referralcode);
                                      },
                                      icon: Icon(Icons.share,
                                          color: Colors.grey, size: 24)),
                                  IconButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                                text: referralcode))
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  backgroundColor:
                                                      Colors.indigo,
                                                  content: Text(
                                                      "Referral code copied",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))));
                                        });
                                      },
                                      icon: Icon(Icons.copy_outlined,
                                          color: Colors.grey, size: 24))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.separated(
                          itemCount: 10,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                  color: Colors.grey, height: 1, thickness: 1),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Text("Name:",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(width: 5.0),
                                          Text("Gaurav Singh",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400))
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: const [
                                          Text("Mobile:",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(width: 5.0),
                                          Text("9540174604",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400))
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Text("Date:",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(width: 5.0),
                                          Text("22-11-2022",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400))
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: const [
                                          Text("Points:",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(width: 5.0),
                                          Text("800.00",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400))
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onShare(BuildContext context, String referralcode) async {
    final box = context.findRenderObject() as RenderBox;
    await Share.share("My Referrral code is : $referralcode",
        subject: "Referral Code",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<List<ProfileResponse>> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + profile),
        headers: {'Authorization': 'Bearer $mytoken'});
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list =
          list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<bool> _willPopCallback() async {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }
}
