import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:doctor/common/event/event_home_tab.dart';
import 'package:doctor/http/foundationSystem.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/activity_detail.dart';
import 'package:doctor/pages/activity/widget/activity_resource_detail.dart';
import 'package:doctor/pages/login/login_by_chaptcha.dart';
import 'package:doctor/pages/message/message_list_page.dart';
import 'package:doctor/pages/user/setting/update/app_repository.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';
import 'package:doctor/pages/user/setting/update/app_update_info.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/cache_learn_detail_video_helper.dart';
import 'package:doctor/provider/provider_manager.dart';
import 'package:doctor/root_widget.all.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http_manager/manager.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:doctor/http/foundationSystem.dart';
import 'package:doctor/pages/activity/activity_research.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

import 'model/ucenter/doctor_detail_info_entity.dart';
import 'utils/app_utils.dart';
import './widgets/YYYEasyLoading.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final EventBus eventBus = EventBus();
Set<String> userAuthCode = {'00010009', '00010010'};
String windowDeviceToken = "";

@RouteMain()
class RootWidget extends StatelessWidget {
  final showGuide;

  RootWidget(this.showGuide) {
    SessionManager.shared.addListener(() async {
      var context = NavigationService().navigatorKey.currentContext;
      debugPrint("RootWidget -> isLogin: ${SessionManager.shared.isLogin}");
      if (SessionManager.shared.isLogin) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteManagerOld.HOME, (route) => false);
      } else {
        var name = ModalRoute.of(context)?.settings?.name ?? "";
        await Navigator.of(context).pushNamedAndRemoveUntil(
            RouteManagerOld.LOGIN_CAPTCHA, (route) => false);
      }
    });
    MedcloudsNativeApi.instance().addProcessor("receiveToken", (args) async {
      windowDeviceToken = args;
    });
    MedcloudsNativeApi.instance().addProcessor("uploadDeviceInfo",
        (args) async {
      MedcloudsNativeApi.instance().uploadDeviceInfo(args);
    });
    MedcloudsNativeApi.instance().addProcessor("uploadFile", (args) async {
      return jsonEncode(await OssService.uploadBatchToOss(
          await ImageHelper.compressImageBatch(jsonDecode(args))));
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
          var message = json.decode(args);
          var messageId = message["messageId"];
          var url = message["url"];
          var userId = int.parse(message["userId"]);

          UserInfoViewModel model =
              Provider.of<UserInfoViewModel>(context, listen: false);
          if (userId != model.data.doctorUserId ||
              !SessionManager.shared.isLogin) {
            return;
          }
          if (messageId != null && (!TextUtil.isEmpty(messageId))) {
            API.shared.foundationSys
                .messageUpdateStatus({'messageId': messageId});
          }
          if (!TextUtil.isEmpty(url)) {
            RouteManager.push(context, url);
          }
        } catch (e) {}
      },
    );
    MedcloudsNativeApi.instance().addProcessor("clearVideo", (args) {
      var context = NavigationService().navigatorKey.currentContext;
      DoctorDetailInfoEntity userInfo =
          Provider.of<UserInfoViewModel>(context, listen: false).data;
      var userId = userInfo.doctorUserId;
      CachedLearnDetailVideoHelper.cleanVideoCache(userId);
      return;
    });
    HttpManager.shared.onRequest = (options) async {
      debugPrint("$options");
      debugPrint("ticket:${SessionManager.shared.session}");
      options.headers["_ticketObject"] = SessionManager.shared.session;
      options.headers["_appVersion"] = await PlatformUtils.getAppVersion();
      options.headers["_appVersionCode"] = await PlatformUtils.getBuildNum();
      options.headers["_greyVersion"] = "1.9.5";
      options.headers["_requestId"] = DateTime.now().millisecondsSinceEpoch;
      if (Platform.isAndroid) {
        options.headers['_platform'] = "Android";
      } else if (Platform.isIOS) {
        options.headers['_platform'] = "iOS";
      }
      debugPrint('Request headers -> ${options.headers}');

      return options;
    };
    HttpManager.shared.onResponse = (response) {
      debugPrint("url - ${response.realUri} data - ${response.data}");
      Map<String, dynamic> data = response.data;
      String status = data["status"];
      print("the status is $status");
      if (status.toUpperCase() == "ERROR") {
        String errorCode = data["errorCode"];
        if (outLoginCodes.contains(errorCode) ||
            authFailCodes.contains(errorCode)) {
          SessionManager.shared.session = null;
        } else if (errorCode == "00010012") {
          var context = NavigationService().navigatorKey.currentContext;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("${data["errorMsg"]}"),
                  actions: [
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("去更新"),
                      onPressed: () async {
                        Navigator.pop(context);
                        EasyLoading.instance.flash(() async {
                          AppUpdateInfo updateInfo =
                              await AppRepository.checkVersion();
                          AppUpdateHelper.update(context, updateInfo);
                        });
                      },
                    ),
                  ],
                );
              });
        }
        if (userAuthCode.contains(errorCode)) {
          throw data;
        }
        throw NetError(data["errorMsg"] ?? "请求错误");
      }
      response.data = response.data["content"] ?? response.data;
      return response;
    };
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance.successWidget =
        Image.asset("assets/images/success.png");
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
        routes: {...RouteManagerOld.routes, ...routes()},
        initialRoute: showGuide['showGuide']
            ? RouteManagerOld.GUIDE
            : SessionManager.shared.isLogin
                ? RouteManagerOld.HOME
                : RouteManagerOld.LOGIN_CAPTCHA,
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
