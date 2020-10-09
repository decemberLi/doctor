import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AceButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteManager.TEST);
            },
            text: '测试页'),
      ),
    );
  }
}
