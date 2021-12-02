import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class DialogEntity {
  String title;
  Widget contentWidget;
  EdgeInsets contentPadding;
  Function onCancel;
  Function onOk;
  String cancelText;
  String okText;

  DialogEntity(
    this.title,
    this.contentWidget,
    this.onCancel,
    this.onOk, {
    this.cancelText = "取消",
    this.okText = "确定",
    this.contentPadding = const EdgeInsets.fromLTRB(0, 0, 0, 30.0),
  });
}

class AgreementDialog extends Dialog {
  final DialogEntity entity;

  AgreementDialog(this.entity, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(25, 16, 25, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                        child: Center(
                          child: Text(
                            this.entity.title,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: this.entity.contentPadding,
                        child: this.entity.contentWidget,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: OutlinedButton(
                                child: Text(this.entity.okText),
                                style: OutlinedButton.styleFrom(
                                  primary: const Color(0xFF000000),
                                  backgroundColor: ThemeColor.primaryColor,
                                  side: BorderSide(
                                    color: ThemeColor.primaryColor,
                                    width: 1,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                onPressed: () {
                                  this.entity.onOk();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Text(
                            this.entity.cancelText,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF888888),
                            ),
                          ),
                          onTap: () {
                            this.entity.onCancel();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
