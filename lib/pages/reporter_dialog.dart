import 'package:doctor/http/foundationSystem.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorConclusionParam {}

class DoctorConclusionModel {
  num createTime;
  String messageTitle;
  DoctorConclusionParam params;
}

bool _isDialogShowing = false;

void showWeekIfNeededReporter(BuildContext ctx) async {
  if (_isDialogShowing) {
    return;
  }
  API.shared.foundationSys.messageDoctorConclusion().then((value) async {
    if (value == null) {
      return;
    }

    if (value['readed'] ?? true) {
      return;
    }

    int messageId = value['messageId'];
    if (messageId == null) {
      return;
    }

    SharedPreferences refs = await SharedPreferences.getInstance();
    if (refs.getBool('$messageId') ?? false) {
      return;
    }
    _isDialogShowing = true;
    _showDialog(
        ctx,
        "您的${DateTime.fromMillisecondsSinceEpoch(value['params']['date'] ?? 0).month}月学习小结",
        value['params']['comments'],
        value['params']['viewUrl'],
        value['messageId']);
  }).catchError((dynamic error) {
    //Do nothing
    print(error);
  });
}

void _showDialog(
    BuildContext ctx, String title, String comment, String url, int messageId) {
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
                        title ?? '',
                        style: TextStyle(
                          color: ThemeColor.colorFF107BFD,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 26, bottom: 34, left: 20, right: 20),
                      child: Text(
                        "「${comment ?? ''} 」",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ThemeColor.colorFF107BFD,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: AceButton(
                        onPressed: () async {
                          _isDialogShowing = false;
                          Navigator.pop(context);
                          MedcloudsNativeApi.instance().openWebPage(url);
                          await API.shared.foundationSys
                              .messageUpdateStatus({'messageId': messageId});
                        },
                        text: "立即查收",
                        height: 44,
                        width: 152,
                      ),
                    ),
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
                onTap: () async {
                  _isDialogShowing = false;
                  SharedPreferences refs =
                      await SharedPreferences.getInstance();
                  refs.setBool('$messageId', true);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        },
      );
    },
  );
}
