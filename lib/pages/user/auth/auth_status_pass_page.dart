import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_file_preview/flutter_file_preview.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';

class AuthStatusPassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String authStatusNotice = '';
    Widget contentWidget = Container();
    String assets = '';
    var style = TextStyle(
      fontSize: 14,
      color: ThemeColor.colorFF999999,
    );
    assets = 'assets/images/auth_pass.png';
    authStatusNotice = '医师身份认证已通过';
    contentWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('您可以开始做医师身份认证学习任务啦', textAlign: TextAlign.center, style: style),
      ],
    );

    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('医师资质认证'),
        elevation: 1,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 150),
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  assets,
                  width: 64,
                  height: 66,
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Text(
                    authStatusNotice,
                    style: TextStyle(
                      fontSize: 18,
                      color: ThemeColor.colorFF222222,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 28, left: 50, right: 50),
                  child: contentWidget,
                )
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: const Color(0xFF107BFD)))),
                    child: Text(
                      '查看我的电子合同',
                      style: TextStyle(
                          fontSize: 12, color: const Color(0xFF107BFD)),
                    ),
                  ),
                ),
                onTap: () {
                  EasyLoading.instance.flash(() async {
                    var ret = await _getPdfFileUrl();
                    FlutterFilePreview.openFile(ret,
                        title: '协议', context: context, onLoadFinished: () {
                    });
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _getPdfFileUrl() async {
    return await API.shared.ucenter.queryContractUrl();
  }
}
