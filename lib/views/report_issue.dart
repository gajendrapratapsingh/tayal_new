// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/components/loader.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ReportIssues extends StatefulWidget {
  @override
  _ReportIssuesState createState() => _ReportIssuesState();
}

class _ReportIssuesState extends State<ReportIssues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      body: Stack(
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
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/images/back.svg',
                            fit: BoxFit.fill)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                    Text("Issues List",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 21,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(10),
                //     child: ListView.separated(
                //         itemCount: helplist.length,
                //         padding: EdgeInsets.zero,
                //         separatorBuilder: (BuildContext context, int index) =>
                //             const Divider(color: Colors.blue),
                //         itemBuilder: (BuildContext context, int index) {
                //           return Card(
                //             child: ExpandableNotifier(
                //                 child: ExpandablePanel(
                //                     header: Padding(
                //                       padding: const EdgeInsets.all(8.0),
                //                       child: Text(
                //                           helplist[index]['question']
                //                               .toString(),
                //                           style: TextStyle(
                //                               fontWeight: FontWeight.bold,
                //                               fontSize: 16,
                //                               color: Colors.blue)),
                //                     ),
                //                     expanded: Padding(
                //                       padding: const EdgeInsets.all(8.0),
                //                       child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                               helplist[index]['created_at']
                //                                   .toString()
                //                                   .split(" ")[0],
                //                               style: TextStyle(
                //                                   fontWeight: FontWeight.bold)),
                //                           Divider(
                //                             thickness: 1,
                //                             height: 30,
                //                           ),
                //                           Text(
                //                             helplist[index]['answer']
                //                                 .toString(),
                //                             textAlign: TextAlign.justify,
                //                           )
                //                         ],
                //                       ),
                //                     ))),
                //           );

                //         }),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: InkWell(
        onTap: () {
          showOrderTracking();
        },
        child: Container(
          height: 55,
          // width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.indigo,
          ),
          child: const Text("Raise Ticket",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
      ),
    );
  }

  String attachmentPath = "";
  TextEditingController title = TextEditingController();
  TextEditingController details = TextEditingController();
  Future<void> showOrderTracking() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                    onPressed: () async {
                                      FilePickerResult result =
                                          await FilePicker.platform.pickFiles();

                                      if (result != null) {
                                        setState(() {
                                          attachmentPath =
                                              result.files.single.path;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.attachment),
                                    label: Text("Attachment")),
                                attachmentPath.isEmpty
                                    ? SizedBox()
                                    : Text("File Attached"),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          attachmentPath = "";
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              autofocus: true,
                              controller: title,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: "Title"),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: details,
                              maxLines: 3,
                              autofocus: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: "Report Issue"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                showLaoding(context);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String mytoken =
                                    prefs.getString('token').toString();
                                print(BASE_URL + raisedTicket);
                                var request = http.MultipartRequest(
                                    'POST', Uri.parse(BASE_URL + raisedTicket));
                                request.headers.addAll({
                                  'Accept': 'application/json',
                                  'Authorization': 'Bearer $mytoken',
                                  // 'Content-Type': 'application/json',
                                });

                                request.fields["title"] = title.text.toString();
                                request.fields["query_text"] =
                                    details.text.toString();
                                print(attachmentPath);
                                if (attachmentPath.isNotEmpty) {
                                  request.files.add(http.MultipartFile(
                                      'image',
                                      File(attachmentPath)
                                          .readAsBytes()
                                          .asStream(),
                                      await File(attachmentPath).length(),
                                      filename: "image" +
                                          p.extension(attachmentPath)));
                                } else {
                                  request.fields['image'] = "";
                                }

                                print(request.fields);
                                print(request.files.first.filename);
                                var response = await request.send();

                                var respStr =
                                    await response.stream.bytesToString();

                                print(respStr);
                                // print(
                                //     jsonDecode(respStr).toString() + " code2");
                                Navigator.of(context).pop();
                                // Navigator.of(context).pop();
                                if (jsonDecode(respStr)['ErrorCode'] == 0) {
                                  Fluttertoast.showToast(msg: "Ticket Raised");
                                }
                              },
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(29.0),
                                    border: Border.all(
                                        color: Colors.indigo, width: 1)),
                                child: Text("SUBMIT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ),
                          ]),
                    ),
                  ));
            }));
  }
}
