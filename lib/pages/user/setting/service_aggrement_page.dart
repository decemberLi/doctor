import 'package:doctor/common/constants.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceAgreementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        elevation: 0,
        title: Text('服务协议'),
      ),
      body: Column(
        children: [
          GestureDetector(
            child: _itemWidget('用户协议'),
            onTap: () {
              MedcloudsNativeApi.instance().openWebPage(userAgreement);
            },
          ),
          GestureDetector(
            child: _itemWidget('隐私协议'),
            onTap: () {
              MedcloudsNativeApi.instance().openWebPage(privacyAgreement,);
            },
          ),
        ],
      ),
    );
  }

  _itemWidget(String text) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(right: 18),
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 24),
            child: Text(
              text,
              style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
              textAlign: TextAlign.left,
            ),
          )),
          Icon(
            Icons.arrow_forward_ios,
            color: ThemeColor.colorFF000000,
            size: 12,
          )
        ],
      ),
    );
  }
}
