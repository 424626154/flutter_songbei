
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showToast(BuildContext context, String text){
    //    Toast.show(text, context,
//        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    Fluttertoast.showToast(msg:text,backgroundColor: Colors.black87);
  }
}