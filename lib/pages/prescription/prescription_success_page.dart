import 'package:doctor/pages/login/model/login_info.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_qr_code.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor/http/dtp.dart';
import 'package:http_manager/manager.dart';

class PrescriptionSuccessPage extends StatefulWidget {
  @override
  _PrescriptionSuccessPageState createState() =>
      _PrescriptionSuccessPageState();
}

class _PrescriptionSuccessPageState extends State<PrescriptionSuccessPage> {
  int backfocus = 0; //点击返回按钮状态，第二次点击直接返回

  /// 去修改密码弹窗
  Future<bool> _showGoToModifyPasswordDialog() {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('提示'),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("系统检测到您还未设置新密码，为了您的账户安全，请重新设置!"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "取消",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text(
                "去设置",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                PrescriptionViewModel model =
                    Provider.of<PrescriptionViewModel>(context, listen: false);
                model.resetData();
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteManager.SET_NEW_PWD,
                    ModalRoute.withName(RouteManager.HOME));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String prescriptionNo = ModalRoute.of(context).settings.arguments as String;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('处方创建成功'),
        ),
        body: Container(
          color: ThemeColor.colorFFF3F5F8,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 22,
                      bottom: 28,
                    ),
                    child: Consumer<PrescriptionViewModel>(
                      builder: (_, model, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            child,
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              model.data.prescriptionPatientName ?? '',
                              style: MyStyles.boldTextStyle_20,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${model.data.prescriptionPatientSexLabel ?? ''} | ${model.data.prescriptionPatientAge ?? ''}岁',
                              style: MyStyles.boldTextStyle_12,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            PrescriptionQRCode(prescriptionNo),
                            SizedBox(
                              height: 34,
                            ),
                            AceButton(
                              type: AceButtonType.outline,
                              text: '查看处方详情',
                              width: 140,
                              height: 36,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  RouteManager.PRESCRIPTION_DETAIL,
                                  arguments: prescriptionNo,
                                );
                              },
                              fontSize: 14,
                            ),
                          ],
                        );
                      },
                      child: Image.asset(
                        'assets/images/avatar.png',
                        width: 62,
                        height: 62,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 20, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '把处方传递给患者',
                        style: MyStyles.labelTextStyle_12,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '方法1:请患者用微信扫描二维码',
                        style: MyStyles.labelTextStyle_12,
                      ),
                      Text(
                        '方法2:点击页面底部随诊患者按钮发给已绑定患者',
                        style: MyStyles.labelTextStyle_12,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                AceButton(
                  text: '发给随诊患者',
                  onPressed: () async {
                    var check =
                        await API.shared.dtp.checkPrescriptionBeforeBind(prescriptionNo);
                    if (check) {
                      Navigator.of(context).pushNamed(
                        RouteManager.PATIENT,
                        arguments: prescriptionNo,
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        PrescriptionViewModel model =
            Provider.of<PrescriptionViewModel>(context, listen: false);
        if (backfocus == 1) {
          //第二次点击返回直接退出页面
          // Navigator.pop(context);
          model.resetData();
          Navigator.popUntil(context, ModalRoute.withName(RouteManager.HOME));
        } else {
          backfocus = backfocus + 1;
          LoginInfoModel loginInfo = LoginInfoModel.shared;
          if (loginInfo.modifiedPassword != true) {
            bool go = await _showGoToModifyPasswordDialog();
            if (!go) {
              // Navigator.pop(context);
              model.resetData();
              Navigator.popUntil(
                  context, ModalRoute.withName(RouteManager.HOME));
            }
          } else {
            model.resetData();
            Navigator.popUntil(context, ModalRoute.withName(RouteManager.HOME));
          }
        }

        return;
      },
    );
  }
}
