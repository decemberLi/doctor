import 'package:common_utils/common_utils.dart';
import 'package:doctor/common/constants.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/agreement_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor/http/developer.dart';

var kIsAgree = '_isAgree';
var kLocalAgreementVersion = '_localAgreementVersion';

agreementDialog(BuildContext context) async {
  bool isAgreed = false;
  var remoteVersion = await obtainAgreementVersion();
  var refs = await SharedPreferences.getInstance();
  String localVersion = refs.getString(kLocalAgreementVersion);
  isAgreed = refs.getBool(kIsAgree) ?? false;
debugPrint('--------------------${(localVersion == remoteVersion) && isAgreed}');
  if ((localVersion == remoteVersion) && isAgreed) {
    debugPrint('用户已经同意过服务协议');
    return;
  }
  Future.delayed(Duration.zero, () {
    var data = DialogEntity(
        '用户协议和隐私条款',
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    "亲爱的用户，欢迎您使用易学术App我们非常重视您的个人信息和隐私保护，为了更好的保障您的个人权益，在您使用我们的产品前，请审慎阅读最新更新的",
                style: TextStyle(
                  color: const Color(0xFF444444),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: "《隐私协议》",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    MedcloudsNativeApi.instance().openWebPage(processPrivacyAgreementHost());
                  },
              ),
              TextSpan(
                text: "和",
                style: TextStyle(
                  color: const Color(0xFF444444),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: "《用户协议》",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    MedcloudsNativeApi.instance().openWebPage(processUserAgreementHost());
                  },
              ),
            ],
          ),
        ), () {
      exit(0);
    }, () async {
      // appContext.storage.setBool('isAgree', true);
      await refs.setBool(kIsAgree, true);
      await refs.setString(kLocalAgreementVersion, remoteVersion);
      Navigator.of(context).pop();
    }, cancelText: '不同意', okText: '同意并继续');
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AgreementDialog(data);
      },
    );
  });
}

Future<String> obtainAgreementVersion() async {
  var ret = await await API.shared.developer.agreementVersion();
  var records = ret["records"] as List;
  if (records != null && records.isNotEmpty) {
    var item = records[0];
    return item["value"];
  }
  return '';
}

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
              MedcloudsNativeApi.instance().openWebPage(processUserAgreementHost());
            },
          ),
          GestureDetector(
            child: _itemWidget('隐私协议'),
            onTap: () {
              MedcloudsNativeApi.instance().openWebPage(
                processPrivacyAgreementHost(),
              );
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
