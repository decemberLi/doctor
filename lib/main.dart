import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/login/login_page.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String session = SessionManager().getSession();
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primaryColor: ThemeColor.primaryColor,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            textTheme: TextTheme(
                headline6: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        scaffoldBackgroundColor: ThemeColor.colorFFFFFF,
        buttonTheme: ButtonThemeData(buttonColor: ThemeColor.primaryColor),
        iconTheme: IconThemeData(color: ThemeColor.primaryColor),
        primaryIconTheme: IconThemeData(color: ThemeColor.primaryColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: NavigationService().navigatorKey,
      routes: RouteManager.routes,
      home: session == null ? LoginPage() : HomePage(),
      builder: (BuildContext context, Widget child) {
        /// 确保 loading 组件能覆盖在其他组件之上.
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
