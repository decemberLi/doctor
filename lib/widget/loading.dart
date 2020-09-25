import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  static BuildContext ctx;
  static bool isLoading = false;

  static void showLoading({BuildContext context}) {
    if (!isLoading) {
      isLoading = true;
      BuildContext _ctx = context ?? ctx;
      print(_ctx);
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: 'aaa',
          transitionDuration: const Duration(milliseconds: 150),
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return Align(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.black54,
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
          }).then((v) {
        isLoading = false;
      });
    }
  }

  static void hideLoading({BuildContext context}) {
    if (isLoading) {
      BuildContext _ctx = context ?? ctx;
      Navigator.of(_ctx).pop();
    }
  }
}
