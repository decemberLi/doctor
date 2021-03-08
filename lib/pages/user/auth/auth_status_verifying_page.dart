import 'package:doctor/common/event/event_home_tab.dart';
import 'package:doctor/root_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthStatusVerifyingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String authStatusNotice = '';
    Widget contentWidget = Container();
    String assets = '';
    var style = TextStyle(
      fontSize: 14,
      color: ThemeColor.colorFF999999,
    );
    authStatusNotice = '医师身份认证审核中';
    contentWidget = Text('您提交的信息将会在1-3个工作日内审核完成届时审核结果会通知到您',
        textAlign: TextAlign.center, style: style);
    assets = 'assets/images/ayth_verify.png';
    return WillPopScope(
        child: Scaffold(
          backgroundColor: ThemeColor.colorFFF3F5F8,
          appBar: AppBar(
            title: Text('医师资质认证'),
            elevation: 1,
            leading: Text(''),
          ),
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 150),
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      assets,
                      width: 64,
                      height: 66,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      child: Text(
                        authStatusNotice,
                        style: TextStyle(
                          fontSize: 18,
                          color: ThemeColor.colorFF222222,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 28, left: 50, right: 50),
                      child: contentWidget,
                    )
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 24),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 26),
                            child: AceButton(
                              width: double.infinity,
                              type: AceButtonType.primary,
                              text: "返回工作台",
                              onPressed: () async {
                                eventBus.fire(EventHomeTab.createWorkTopEvent());
                                Navigator.popUntil(context,
                                    ModalRoute.withName(RouteManager.HOME));
                              },
                            ),
                          ),
                        ),
                        Container(width: 24),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 26),
                            child: AceButton(
                              width: double.infinity,
                              type: AceButtonType.primary,
                              text: "去逛逛",
                              onPressed: () async {
                                eventBus.fire(EventHomeTab.createDoctorCircleEvent());
                                Navigator.popUntil(context,
                                    ModalRoute.withName(RouteManager.HOME));
                              },
                            ),
                          ),
                        ),
                        Container(width: 24),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        });
  }
}
