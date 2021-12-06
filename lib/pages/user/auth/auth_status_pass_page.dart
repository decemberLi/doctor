import 'package:doctor/http/ucenter.dart';
import 'package:doctor/model/ucenter/auth_platform.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/pdf_Viewer_adapter.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:provider/provider.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

import '../ucenter_view_model.dart';

@RoutePage(name: "auth_status_pass_page")
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
    UserInfoViewModel userModel = Provider.of<UserInfoViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('医师身份认证'),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 150),
          width: double.infinity,
          child: Column(
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
              ),
              if(userModel.isIdentityAuthPassedByChannel(AuthPlatform.channelGolden))
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 100,bottom: 30),
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
                    PdfViewerAdapter.openFile(ret,title:'协议');
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _getPdfFileUrl() async {
    return await API.shared.ucenter.queryContractUrl();
  }
}
