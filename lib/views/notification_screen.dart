import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/widgets/navigation_drawer_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset('assets/images/back.svg'),
                    ),
                    const Text("Notifications", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
                    Image.asset('assets/images/setting.png', fit: BoxFit.fill),
                  ],
                ),
                SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                      itemCount: 5,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context,int index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset('assets/images/setting.png', fit: BoxFit.fill),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10.0),
                                          Text("Offers", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 10.0),
                                          Text("hgdsagdgasdgasgdgsadhgsagd", maxLines: 3, style: TextStyle(color: Colors.grey, fontSize: 13)),
                                          SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              Icon(Icons.arrow_forward, size: 24, color: Colors.grey),
                                              SizedBox(width: 6.0),
                                              Text("a minute ago", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500))
                                            ],
                                          ),
                                          SizedBox(height: 4.0),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
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
