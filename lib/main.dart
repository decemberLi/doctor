import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/login/login_page.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String session = SessionManager().getSession();
    return RefreshConfiguration(
      hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
      child: MaterialApp(
        title: APP_NAME,
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
          buttonTheme: ButtonThemeData(buttonColor: ThemeColor.primaryColor),
          iconTheme: IconThemeData(color: ThemeColor.primaryColor),
          primaryIconTheme: IconThemeData(color: ThemeColor.primaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
        home: session == null ? LoginPage() : HomePage(),
        builder: (BuildContext context, Widget child) {
          /// 确保 loading 组件能覆盖在其他组件之上.
          return FlutterEasyLoading(child: child);
        },
      ),
    );
  }
}
