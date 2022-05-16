import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/models/profiledata.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name, mobile, email, profileimage, address;

  var focusNode = FocusNode();

  bool _loading = false;
  String _profilepath = "";
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<ProfileResponse>> temp = _getprofile();
    temp.then((value) {
      setState(() {
        profileimage = value[0].profileImage.toString();
        name = value[0].username.toString();
        mobile = value[0].mobile.toString();
        email = value[0].email.toString();
        address = value[0].address.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundShapeColor,
        body: ModalProgressHUD(
          color: Colors.indigo,
          inAsyncCall: _loading,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: (){
                            _willPopCallback();},
                          child: SvgPicture.asset('assets/images/back.svg', fit: BoxFit.fill),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                        Text("Profile", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 21, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.center,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10.0),
                                            InkWell(
                                              onTap:(){
                                                _showProfilePicker(context);
                                              },
                                              child: _profilepath.toString() == "" || _profilepath.toString() == "null" ? ClipRRect(
                                                borderRadius: BorderRadius.circular(40),
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  child: profileimage == "" || profileimage == null ? Image.asset('assets/images/logo_user.png', fit: BoxFit.fill) : Image.network(profileimage, fit: BoxFit.fill),
                                                ),
                                              ) : ClipRRect(
                                                borderRadius: BorderRadius.circular(40),
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(_profilepath)))
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15.0),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                                              child: name == "" || name == null ? Text("") : Text(name, style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                    )
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          FocusScope.of(context).requestFocus(focusNode);
                                        });
                                      },
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: Colors.white, width: 1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.edit_outlined, color: Colors.black, size: 24),
                                                SizedBox(width: 5.0),
                                                Text("Edit Profile", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500))
                                              ],
                                            ),
                                          )
                                      ),
                                    )
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Name", style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                                    ),
                                    TextField(
                                        keyboardType: TextInputType.text,
                                        //focusNode: focusNode,
                                        decoration: InputDecoration(
                                          hintText: name == "" || name == null ? "" : name,
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                        ),
                                      onChanged: (value){
                                          setState(() {
                                            name = value.toString();
                                          });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Phone Number", style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                                    ),
                                    TextField(
                                        keyboardType: TextInputType.number,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          hintText: mobile == "" || mobile == null ? "" : mobile,
                                          //suffix: Text("Edit", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                        )
                                    ),
                                    const SizedBox(height: 20),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Email", style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                                    ),
                                    TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: email == "" || email == null ? "" : email,
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                        ),
                                      onChanged: (value){
                                          setState(() {
                                            email = value.toString();
                                          });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Address", style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: address == "" || address == null ? "" : address,
                                        //suffix: Text("Change", style: TextStyle(fontSize: 14)),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue),
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          address = value.toString();
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      width: size.width * 0.9,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(29),
                                        child: newElevatedButton(),
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: _willPopCallback,
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: (){
        if(_profilepath.toString() == "" || _profilepath.toString() == null){
          showToast("Please select your profile picture");
        }
        else{
          _updateprofile();
        }

      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future<List<ProfileResponse>> _getprofile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    var response = await http.post(Uri.parse(BASE_URL+profile),
        headers : {'Authorization': 'Bearer $mytoken'}
    );
    if (response.statusCode == 200)
    {
      Iterable list = json.decode(response.body)['Response'];
      List<ProfileResponse> _list = list.map((m) => ProfileResponse.fromJson(m)).toList();
      return _list;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<List<ProfileResponse>> _updateprofile() async{
    print(name);
    print(email);
    print(address);
    setState(() {
       _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mytoken = prefs.getString('token').toString();
    print(json.encode({
      "name" : name,
      "email" : email,
      "business_name": "",
      "gst_no": "",
      "address": address,
      "pan_no": "",
      "upload_photo" : "",
      "upload_gst_certificate": "",
      "upload_agriculture_license": "",
      "upload_pancard" : ""
    }));
    var requestMulti = http.MultipartRequest('POST', Uri.parse(BASE_URL+updateprofile));
    requestMulti.headers['authorization'] = 'Bearer $mytoken';
    requestMulti.fields["name"] = name;
    requestMulti.fields["address"] = address;
    requestMulti.fields["email"] = email;

    requestMulti.fields["upload_gst_certificate"] = "";
    requestMulti.fields["upload_agriculture_license"] = "";
    requestMulti.fields["upload_pancard"] = "";


    requestMulti.files.add(await http.MultipartFile.fromPath('upload_photo', _profilepath));
    //requestMulti.files.add(await http.MultipartFile.fromPath('upload_gst_certificate', ""));
    //requestMulti.files.add(await http.MultipartFile.fromPath('upload_agriculture_license', ""));
    //requestMulti.files.add(await http.MultipartFile.fromPath('upload_pancard', ""));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          if(jsonData['ErrorMessage'] == "success"){
            showToast("Profile updated successfully");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen()));
            setState(() {
               _loading = false;
            });
          }
          else{
            showToast("Failed");
            setState(() {
              _loading = false;
            });
          }
        } catch (e) {}
      });
    });

  }

  void _showProfilePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        _profileimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _profileimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  _profileimgFromCamera() async{
    final ImagePicker _picker = ImagePicker();
    final XFile photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if(photo.path == "" || photo.path == null){
      setState(() {
        _profilepath = photo.path;
      });
    }
  }

  _profileimgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    print(image.path);
    setState(() {
      _profilepath = image.path;
    });
    print(_profilepath);
  }

  Future<bool> _willPopCallback() async {
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
  }
}
