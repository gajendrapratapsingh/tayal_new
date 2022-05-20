// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tayal/network/api.dart';

class Conversation extends StatefulWidget {
  String query_id;
  Conversation({this.query_id});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  Map chat = {};
  List conversion = [];
  Future<void> getChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response =
        await http.post(Uri.parse(BASE_URL + fetchqueryconversation), headers: {
      'Authorization': 'Bearer $mytoken'
    }, body: {
      "query_id": widget.query_id.toString(),
    });
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        chat = jsonDecode(response.body)['Response'];
        conversion = jsonDecode(response.body)['Response']['comments'];
      });
    }
  }

  TextEditingController message = TextEditingController();

  bool attachment = false;
  bool showCamera = false;
  String filePath = "";
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text("Chat")),
      body: SafeArea(
        child: ListView(
          // reverse: true,
          scrollDirection: Axis.vertical,
          // defaultPosition: DefaultScrollPosition.bottom,
          children: conversion
              .map((e) => Align(
                    alignment: e['user_type_id'].toString() == "3"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: e['user_type_id'].toString() == "3"
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(0))
                                : BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(10))),
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e['comment_text'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            height: showCamera || attachment ? 160 : 80,
            child: Column(
              children: [
                showCamera
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                      icon: Icon(Icons.camera),
                                      onPressed: () async {
                                        final XFile result =
                                            await _picker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 80,
                                          maxHeight: 480,
                                          maxWidth: 640,
                                        );
                                        if (result != null) {
                                          setState(() {
                                            showCamera = false;
                                            attachment = true;
                                            filePath = result.path.toString();
                                          });
                                        }
                                      },
                                      label: Text("Camera")),
                                  TextButton.icon(
                                      icon: Icon(Icons.photo),
                                      onPressed: () async {
                                        final XFile result =
                                            await _picker.pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 80,
                                          maxHeight: 480,
                                          maxWidth: 640,
                                        );
                                        if (result != null) {
                                          setState(() {
                                            showCamera = false;
                                            attachment = true;
                                            filePath = result.path.toString();
                                          });
                                        }
                                      },
                                      label: Text("Galary")),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showCamera = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ))
                                ],
                              )),
                        ),
                      )
                    : SizedBox(),
                attachment
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: Image.file(File(filePath))),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      attachment = false;
                                      filePath = "";
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                Container(
                  color: Colors.grey[300],
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  showCamera = !showCamera;
                                  if (attachment) {
                                    setState(() {
                                      attachment = false;
                                    });
                                  }
                                });
                              },
                              child: Icon(
                                Icons.attachment,
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: InkWell(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String mytoken =
                                      prefs.getString('token').toString();
                                  var request = http.MultipartRequest(
                                      'POST',
                                      Uri.parse(
                                          BASE_URL + postqueryconversation));
                                  request.headers.addAll({
                                    'Accept': 'application/json',
                                    'Authorization':
                                        'Bearer ' + mytoken.toString(),
                                  });

                                  request.fields['query_id'] =
                                      widget.query_id.toString();
                                  request.fields['comment_text'] =
                                      message.text.toString();

                                  if (filePath != "") {
                                    request.files.add(
                                        await http.MultipartFile.fromPath(
                                            'image', filePath));
                                  }
                                  print(request.fields);
                                  // print(request.files);

                                  var response = await request.send();
                                  var respStr =
                                      await response.stream.bytesToString();
                                  print("test-----" + respStr);
                                  setState(() {
                                    message.text = "";
                                    attachment = false;
                                  });
                                  getChat();
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                )),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
