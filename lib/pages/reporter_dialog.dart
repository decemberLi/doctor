import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showWeekIfNeededReporter(BuildContext ctx) {
  showDialog(
      context: ctx,
      builder: (context) {
        return WillPopScope(
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 68),
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 27),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icon_ envelope.png',
                          width: 100,
                          height: 93,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "您的1月学习小结",
                            style: TextStyle(
                              color: ThemeColor.colorFF107BFD,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 26, bottom: 34, left: 10, right: 10),
                          child: Text(
                            "「业精于勤，荒于嬉」",
                            style: TextStyle(
                              color: ThemeColor.colorFF107BFD,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeColor.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  color: Color(0x663aa7ff),
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            height: 44,
                            width: 152,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "立即查收",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onTap: () {
                            // TODO ....
                          },
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 36),
                      child: Image.asset(
                        'assets/images/close.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            onWillPop: () {
              return Future.value(false);
            });
      });
}
