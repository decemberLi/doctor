import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 通用背景
class CommonStack extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  CommonStack({this.appBar, this.body});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          child: Column(
            children: [
              Container(
                color: Color(0xFF3AA7FF),
                alignment: Alignment.topCenter,
                // child: Image.asset(
                //   'assets/images/logo.png',
                //   fit: BoxFit.cover,
                //   width: MediaQuery.of(context).size.width,
                // ),
                width: MediaQuery.of(context).size.width,
                height: 186.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: ThemeColor.colorFFF3F5F8,
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
              ),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: this.appBar,
          body: this.body,
        ),
      ],
    );
  }
}
