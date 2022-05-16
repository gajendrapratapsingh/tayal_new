import 'package:flutter/material.dart';
import 'package:tayal/helper/exit_confirmation_dialog.dart';
import 'package:tayal/helper/logout_confirmation_dialog.dart';



class DialogHelper {

  static exit(context) => showDialog(context: context, builder: (context) => ExitConfirmationDialog());
  static logout(context) => showDialog(context: context, barrierDismissible: false, builder: (context) => LogoutConfirmationDialog());

}