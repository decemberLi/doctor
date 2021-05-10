import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:doctor/common/event/event_home_tab.dart';
import 'package:doctor/http/foundationSystem.dart';
import 'package:doctor/pages/login/login_by_chaptcha.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/provider/provider_manager.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http_manager/manager.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:doctor/http/foundationSystem.dart';

import 'utils/app_utils.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final EventBus eventBus = EventBus();
Set<String> userAuthCode = {'00010009', '00010010'};
String windowDeviceToken = "";
class RootWidget extends StatelessWidget {
  final showGuide;

  RootWidget(this.showGuide) {
    SessionManager.shared.addListener(() async{
      var context = NavigationService().navigatorKey.currentContext;
      debugPrint("RootWidget -> isLogin: ${SessionManager.shared.isLogin}");
      if (SessionManager.shared.isLogin) {
        Navigator.of(context).pushNamedAndRemoveUntil(RouteManager.HOME, (route)=>false);
      } else {
        var name = ModalRoute.of(context)?.settings?.name ?? "";
        await Navigator.of(context).pushNamedAndRemoveUntil(RouteManager.LOGIN_CAPTCHA, (route) => false);
      }
    });
    MedcloudsNativeApi.instance().addProcessor("receiveToken", (args) async{
      windowDeviceToken = args;
    });
    MedcloudsNativeApi.instance().addProcessor("uploadDeviceInfo",
        (args) async {
      MedcloudsNativeApi.instance().uploadDeviceInfo(args);
    });
    MedcloudsNativeApi.instance().addProcessor("wifiStatus", (args) async {
      if (AppUtils.sp.getBool(ONLY_WIFI) ?? true) {
        ConnectivityResult connectivityResult =
            await (Connectivity().checkConnectivity());
        return connectivityResult == ConnectivityResult.wifi;
      } else {
        return true;
      }
    });
    MedcloudsNativeApi.instance().addProcessor("getTicket", (args) async {
      return SessionManager.shared.session;
    });
    MedcloudsNativeApi.instance().addProcessor(
      "receiveNotification",
      (args) async {
        print('Received push message process event, arguments - > [$args]');
        var context = NavigationService().navigatorKey.currentContext;
        try {
          print('Received push message one');
          var obj = json.decode(args);
          var userID = obj["userId"];
          UserInfoViewModel model =
              Provider.of<UserInfoViewModel>(context, listen: false);
          print('Received push message two ${model.data.doctorUserId} -- $userID');
          if (userID != model.data.doctorUserId ||
              !SessionManager.shared.isLogin) {
            return;
          }
          print('Received push message two');
          var messageID = obj["messageId"];
          if (messageID != null) {
            API.shared.foundationSys.messageUpdateStatus({
              'messageId':messageID
            });
          }
          print('Received push message third');
          var type = obj["bizType"];
          if (type == "QUALIFICATION_AUTH") {
            print("the obj is ---- $obj");
            // 资质认证
            var authStatus = obj["authStatus"];
            if (authStatus == "FAIL") {
              print("the obj is ---- fail");
              Navigator.of(context).pushNamed(RouteManager.DOCTOR_AUTHENTICATION_PAGE);
            } else {
              print("the obj is ---- success");
              Navigator.of(context).pushNamed(RouteManager.DOCTOR_AUTH_STATUS_PASS_PAGE);
            }
            print("the obj is ---- end");
          } else if (type == "ASSIGN_STUDY_PLAN") {
            var template = obj['taskTemplate'];
            if (template == 'MEDICAL_SURVEY') {
              if (model.data.authStatus == 'PASS') {
                var learnPlanId = obj["learnPlanId"];
                Navigator.of(context).pushNamed(
                  RouteManager.LEARN_DETAIL,
                  arguments: {
                    'learnPlanId': learnPlanId,
                  },
                );
              }else{
                eventBus.fire(EventHomeTab.createWorkTopEvent());
                Navigator.of(context).popUntil(ModalRoute.withName(RouteManager.HOME));
              }
            }else{
              // 学习计划详情
              var learnPlanId = obj["learnPlanId"];
              Navigator.of(context).pushNamed(
                RouteManager.LEARN_DETAIL,
                arguments: {
                  'learnPlanId': learnPlanId,
                },
              );
            }
          } else if (type == "RELEARN") {
            // 学习计划详情
            var learnPlanId = obj["learnPlanId"];
            Navigator.of(context).pushNamed(
              RouteManager.LEARN_DETAIL,
              arguments: {
                'learnPlanId': learnPlanId,
              },
            );
          }else if (type == ""){

          }
        } catch (e) {}
      },
    );
    HttpManager.shared.onRequest = (options) async {
      debugPrint("$options");
      debugPrint("ticket:${SessionManager.shared.session}");
      options.headers["_ticketObject"] = SessionManager.shared.session;
      options.headers["_appVersion"] = await PlatformUtils.getAppVersion();
      options.headers["_appVersionCode"] = await PlatformUtils.getBuildNum();
      options.headers["_greyVersion"] = "1.9.5";
      options.headers["_requestId"] = DateTime.now().millisecondsSinceEpoch;
      if (Platform.isAndroid){
        options.headers['_platform'] = "Android";
      }else if (Platform.isIOS){
        options.headers['_platform']= "iOS";
      }
      debugPrint('Request headers -> ${options.headers}');

      return options;
    };
    HttpManager.shared.onResponse = (response) async {
      debugPrint("url - ${response.realUri} data - ${response.data}");
      Map<String, dynamic> data = response.data;
      String status = data["status"];
      print("the status is $status");
      if (status.toUpperCase() == "ERROR") {
        String errorCode = data["errorCode"];
        if (outLoginCodes.contains(errorCode) ||
            authFailCodes.contains(errorCode)) {
          SessionManager.shared.session = null;
        }
        if (userAuthCode.contains(errorCode)) {
          throw data;
        }
        throw data["errorMsg"] ?? "请求错误";
      }
      response.data = response.data["content"] ?? response.data;
      return response;
    };
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance.successWidget = Image.asset("assets/images/success.png");
    return RefreshConfiguration(
      hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
      child: MaterialApp(
        title: APP_NAME,
        navigatorObservers: [routeObserver],
        theme: ThemeData(
          primaryColor: ThemeColor.primaryColor,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            brightness: Brightness.light,
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          scaffoldBackgroundColor: ThemeColor.colorFFFFFF,
          buttonTheme: ButtonThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            buttonColor: ThemeColor.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 0),
          ),
          iconTheme: IconThemeData(color: ThemeColor.primaryColor),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          primaryColorBrightness: Brightness.light,
          primaryIconTheme: IconThemeData(color: ThemeColor.primaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          disabledColor: ThemeColor.secondaryGeryColor,
        ),
        localizationsDelegates: [
          RefreshLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          // const Locale('en'),
          const Locale('zh'),
        ],
        navigatorKey: NavigationService().navigatorKey,
        routes: RouteManager.routes,
        initialRoute: showGuide['showGuide']
            ? RouteManager.GUIDE
            : SessionManager.shared.isLogin
                ? RouteManager.HOME
                : RouteManager.LOGIN_CAPTCHA,
        builder: (BuildContext context, Widget child) {
          /// 确保 loading 组件能覆盖在其他组件之上.
          return FlutterEasyLoading(
            child: MultiProvider(
              providers: providers,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
