import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future SuccessDialog({required String title, int seconds = 2}) {
  return AwesomeDialog(
    dismissOnBackKeyPress: true,
    dismissOnTouchOutside: false,
    context: Get.context!,
    dialogType: DialogType.success,
    animType: AnimType.rightSlide,
    title: '\n\n$title\n',
    // body: Image.asset('assets/images/delete.png'),
    autoHide: Duration(seconds: seconds),
  ).show();
}

Future ConFirmDialog({required String title, required VoidCallback onConfirm}) {
  return AwesomeDialog(
    dismissOnBackKeyPress: true,
    dismissOnTouchOutside: false,
    context: Get.context!,
    dialogType: DialogType.warning,
    animType: AnimType.rightSlide,
    title: '\n\n$title\n',
    // body: Image.asset('assets/images/delete.png'),
    btnCancelOnPress: () {},
    btnOkOnPress: onConfirm,
  ).show();
}
