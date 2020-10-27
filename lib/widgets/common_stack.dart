import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 通用背景
class CommonStack extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  /// 绝对定位的子组件
  final Positioned positionedChild;

  CommonStack({
    this.appBar,
    this.body,
    this.positionedChild,
  });

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
                child: Image.asset(
                  'assets/images/common_statck_bg.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
                width: MediaQuery.of(context).size.width,
                height: 232.0,
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
        if (positionedChild != null) positionedChild,
      ],
    );
  }
}
