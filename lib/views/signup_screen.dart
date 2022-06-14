import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tayal/network/api.dart';
import 'package:tayal/themes/constant.dart';
import 'package:tayal/views/mobile_login_screen.dart';
import 'package:tayal/views/otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProgressDialog pr;

  String name,
      phone,
      businessname,
      gstno,
      address,
      panno,
      referralcode,
      agentcode,
      pincode,
      email;
  String uploadphoto = "Upload Photo";
  String uploadgst = "Upload GST Certificate";
  String uploadlicense = "Upload Agriculture License";
  String uploadpan = "Upload Pan Card";
  String uploadphotopath;
  String uploadgstpath;
  String uploadpanpath = "";
  String uploadlicensepath;

  bool _showCursor = true;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  GlobalKey<FormState> form = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
        });
        if (_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Please check your internet connection.",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
        }
        break;
      default:
        setState(() {
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      progress: 80.0,
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(color: Colors.indigo)),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w100),
    );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundShapeColor,
      appBar: AppBar(
        backgroundColor: appbarcolor,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              "assets/images/back.png",
              scale: 20,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text("Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  children: [
                    Form(
                      key: form,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                name = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              decoration: const InputDecoration(
                                  hintText: "Name", border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                phone = value;
                                if (value.length == 10) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              maxLength: 10,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  hintText: "Mobile No.",
                                  counterText: "",
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                businessname = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              decoration: const InputDecoration(
                                  hintText: "Business Name",
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                email = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) {
                                FocusScope.of(context).unfocus();
                              },
                              cursorColor: kPrimaryColor,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  hintText: "Email", border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                gstno = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              decoration: const InputDecoration(
                                  hintText: "GST No.",
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                panno = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              decoration: const InputDecoration(
                                  hintText: "Pan No.",
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                address = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: "Address",
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 3),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: TextFormField(
                              onChanged: (value) {
                                pincode = value;
                                if (value.length == 6) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              maxLength: 6,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "Pin Code",
                                  counterText: "",
                                  border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 3),
                                  width: size.width * 0.44,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(29),
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1.5)),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      referralcode = value;
                                    },
                                    cursorColor: kPrimaryColor,
                                    decoration: const InputDecoration(
                                        hintText: "Referral Code",
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 3),
                                  width: size.width * 0.44,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(29),
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1.5)),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      agentcode = value;
                                    },
                                    cursorColor: kPrimaryColor,
                                    decoration: const InputDecoration(
                                        hintText: "Agent Code",
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _showDocPicker(context, "uploadphoto");
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 13),
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(29),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    uploadphotopath.toString() == "" ||
                                            uploadphotopath.toString() == "null"
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundImage: FileImage(
                                                File(uploadphotopath)),
                                          ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: Text(uploadphoto,
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16)),
                                    ),
                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              _showDocPicker(context, "uploadgst");
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 13),
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(29),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    uploadgstpath.toString() == "" ||
                                            uploadgstpath.toString() == "null"
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                FileImage(File(uploadgstpath)),
                                          ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: Text(uploadgst,
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16)),
                                    ),
                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              _showDocPicker(context, 'uplaodlicense');
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 13),
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(29),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.5)),
                                child: Row(
                                  children: [
                                    uploadlicensepath.toString() == "" ||
                                            uploadlicensepath.toString() ==
                                                "null"
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundImage: FileImage(
                                                File(uploadlicensepath)),
                                          ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: Text(uploadlicense,
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16)),
                                    ),
                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              _showDocPicker(context, 'uploadpan');
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 13),
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(29),
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.5)),
                                child: Row(
                                  children: [
                                    uploadpanpath.toString() == "" ||
                                            uploadpanpath.toString() == "null"
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                FileImage(File(uploadpanpath)),
                                          ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.60,
                                        child: Text(uploadpan,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16))),
                                  ],
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
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
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDocPicker(context, String type) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {
                        _docimgFromGallery(type);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _docimgFromCamera(type);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _docimgFromCamera(String type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (type == "uploadphoto") {
      setState(() {
        uploadphotopath = photo.path;
        uploadphoto = photo.path.split('/').last;
      });
    } else if (type == "uploadgst") {
      setState(() {
        uploadgstpath = photo.path;
        uploadgst = photo.path.split('/').last;
      });
    } else if (type == "uplaodlicense") {
      setState(() {
        uploadlicensepath = photo.path;
        uploadlicense = photo.path.split('/').last;
      });
    } else {
      setState(() {
        uploadpanpath = photo.path;
        uploadpan = photo.path.split('/').last;
      });
    }
  }

  _docimgFromGallery(String type) async {
    final ImagePicker _picker = ImagePicker();
    XFile image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    print(image.path);
    if (type == "uploadphoto") {
      setState(() {
        uploadphotopath = image.path;
        uploadphoto = image.path.split('/').last;
      });
    } else if (type == "uploadgst") {
      setState(() {
        uploadgstpath = image.path;
        uploadgst = image.path.split('/').last;
      });
    } else if (type == "uplaodlicense") {
      setState(() {
        uploadlicensepath = image.path;
        uploadlicense = image.path.split('/').last;
      });
    } else {
      setState(() {
        uploadpanpath = image.path;
        uploadpan = image.path.split('/').last;
      });
    }
  }

  void _register(
      String name,
      String phone,
      String businessname,
      String gstno,
      String address,
      String panno,
      String referralcode,
      String agentcode,
      String uploadphotopath,
      String pincode,
      String emailid,
      String uploadgstpath,
      String uploadlicensepath,
      String uploadpanpath) async {
    pr.show();
    var requestMulti =
        http.MultipartRequest('POST', Uri.parse(BASE_URL + register));
    requestMulti.fields["name"] = name.toString();
    //requestMulti.fields["phone"] = "8010013798";
    requestMulti.fields["phone"] = phone.toString();
    requestMulti.fields["business_name"] = businessname.toString();
    requestMulti.fields["gst_no"] = gstno.toString();
    requestMulti.fields["address"] = address.toString();
    requestMulti.fields["pan_no"] = panno.toString();
    requestMulti.fields["referral_code"] = referralcode.toString();
    requestMulti.fields["agent_code"] = agentcode.toString();
    requestMulti.fields["pincode"] = pincode.toString();
    requestMulti.fields["email_id"] = emailid.toString();

    requestMulti.files.add(
        await http.MultipartFile.fromPath('upload_photo', uploadphotopath));
    requestMulti.files.add(await http.MultipartFile.fromPath(
        'upload_gst_certificate', uploadgstpath));
    requestMulti.files.add(await http.MultipartFile.fromPath(
        'upload_agriculture_license', uploadlicensepath));
    requestMulti.files.add(
        await http.MultipartFile.fromPath('upload_pancard', uploadpanpath));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          print(responseString);
          var jsonData = jsonDecode(responseString);
          if (jsonData['ErrorCode'].toString() != "0") {
            pr.hide();
            // showToast(jsonData['Response'].toString());
          } else {
            pr.hide();
            // showToast(jsonData['Response'].toString());
            _sendOtp(phone);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MobileLoginScreen()));
          }
        } catch (e) {
          pr.show();
        }
      });
    });
  }

  Future _sendOtp(String phone) async {
    var res = await http.post(
      Uri.parse(BASE_URL + sendotp),
      body: {
        "phone": phone,
      },
    );
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      if (data['ErrorCode'].toString() == "100") {
        showToast("OTP Sent");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                    phone: phone,
                    otp: data['Response']['otp'].toString().trim(),
                    type: "signup")));
      } else {}
    }
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Sign Up",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Please check your internet connection.",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
        } else {
          if (!form.currentState.validate()) {
            showToast("Fill Required Fields");
          } else if (uploadphotopath == null) {
            showToast("Please upload your profile photo");
            return;
          } else if (uploadgstpath == null) {
            showToast("Please upload GST certificate");
            return;
          } else if (uploadlicensepath == null) {
            showToast("Please upload Agriculture license");
            return;
          } else if (uploadpanpath == null) {
            showToast("Please upload pan card");
            return;
          } else {
            print("ok");
            _register(
                name,
                phone,
                businessname,
                gstno,
                address,
                panno,
                referralcode,
                agentcode,
                uploadphotopath,
                pincode,
                email,
                uploadgstpath,
                uploadlicensepath,
                uploadpanpath);
          }
        }
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}
