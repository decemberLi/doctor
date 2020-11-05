import 'package:doctor/http/session_manager.dart';
// import 'package:doctor/pages/login/login_page.dart';
import 'package:doctor/pages/splash/splash.dart';
import 'package:doctor/provider/provider_manager.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await AppUtils.init();
  await SessionManager.init();
  dynamic version = await PlatformUtils.getAppVersion();
  var reference = await SharedPreferences.getInstance();
  var lastVerson = reference.getString('version');
  if (lastVerson == null || lastVerson != version) {
    reference.setString('version', version);
  }
  bool showGuide = lastVerson != version;
  runApp(MyApp({'showGuide': showGuide}));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  final showGuide;
  MyApp(this.showGuide);
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
      child: MaterialApp(
        title: APP_NAME,
        navigatorObservers: [routeObserver],
        theme: ThemeData(
          primaryColor: ThemeColor.primaryColor,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
            textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          scaffoldBackgroundColor: ThemeColor.colorFFFFFF,
          buttonTheme: ButtonThemeData(
            buttonColor: ThemeColor.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 0),
          ),
          iconTheme: IconThemeData(color: ThemeColor.primaryColor),
          cardTheme: CardTheme(
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
          const Locale('en'),
          const Locale('zh'),
        ],
        navigatorKey: NavigationService().navigatorKey,
        routes: RouteManager.routes,
        initialRoute:
            showGuide['showGuide'] ? RouteManager.GUIDE : RouteManager.HOME,
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
