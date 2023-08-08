import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';

class SuccessDialog {
  static show(BuildContext context, {String? title, Function()? btnOkOnPress}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      title: title ?? appLang(context)!.success,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}
