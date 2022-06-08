import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/widgets/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notificationList = [];
  bool isLoading = true;
  final controller = ScrollController();

  Future notificationListAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL + notification),
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({"page": count.toString()}));
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          notificationList = json.decode(response.body)['Response']['data'];
          totalPageCount = int.parse(
              json.decode(response.body)['Response']['total'].toString());
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  int count = 1;
  int totalPageCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationListAPI();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() {
          count++;
        });
        if (count <= totalPageCount) {
          notificationListAPI();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      drawer: NavigationDrawerWidget(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset('assets/images/back.svg'),
                    ),
                    SizedBox(width: size.width * 0.09),
                    const Text("Notifications",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 21,
                            fontWeight: FontWeight.bold)),
                    // Image.asset('assets/images/setting.png', fit: BoxFit.fill),
                  ],
                ),
                Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : notificationList.length == 0
                            ? Center(
                                child: Text("No Notification"),
                              )
                            : ListView(
                                controller: controller,
                                padding: EdgeInsets.zero,
                                children: notificationList
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 2, 8, 2),
                                          child: Column(
                                            children: [
                                              Text(
                                                e['created_at'] == null
                                                    ? ""
                                                    : e['created_at']
                                                        .toString(),
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              Card(
                                                child: ListTile(
                                                  title: Text(
                                                      e['title'].toString()),
                                                  subtitle: Text(
                                                      e['body'].toString()),
                                                  leading: e['image'] == null
                                                      ? Image.asset(
                                                          "assets/images/no_image.jpg")
                                                      : Image.network(
                                                          e['image'].toString(),
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
