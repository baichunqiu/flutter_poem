import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ToastManager{
  static showIOS(String info) {
    Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
    );
  }
  static showAndroid(String info) {
    Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
    );
  }
}