import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/prescription/prescription_page.dart';
import 'package:doctor/pages/prescription/service/service.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_detail.dart';
import 'package:doctor/pages/prescription/widgets/prescription_qr_code.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 处方详情页面
class PrescriptionDetailPage extends StatefulWidget {
  @override
  _PrescriptionDetailPageState createState() => _PrescriptionDetailPageState();
}

class _PrescriptionDetailPageState extends State<PrescriptionDetailPage> {
  /// 查看处方二维码弹窗
  void _showQrCodeDialog(String prescriptionNo) {
    showDialog(
      context: context,
      barrierDismissible: true, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: Icon(
                Icons.close,
                color: ThemeColor.secondaryGeryColor,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          titlePadding: EdgeInsets.all(8),
          contentPadding:
              EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PrescriptionQRCode(prescriptionNo),
              Text(
                '扫一扫获取处方信息',
                style: MyStyles.primaryTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 36),
              AceButton(
                type: AceButtonType.outline,
                text: '发给随诊患者',
                width: 120,
                height: 36,
                onPressed: () async {
                  var check = await checkPrescriptionBeforeBind(prescriptionNo);
                  if (check) {
                    var res = await Navigator.of(context).pushNamed(
                      RouteManager.PATIENT,
                      arguments: prescriptionNo,
                    );
                    if (res != null) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                fontSize: 14,
              ),
            ],
          ),
        );
      },
    );
  }

  /// 修改按钮
  Widget _buildEditBtn() {
    return Positioned(
      bottom: 50,
      width: MediaQuery.of(context).size.width,
      child: Container(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer2<PrescriptionDetailModel, PrescriptionViewModel>(
              builder: (_, model, prescriptionViewModel, __) {
                if (model.data?.status == 'REJECT') {
                  return AceButton(
                    textColor: Colors.white,
                    text: '去修改处方',
                    onPressed: () async {
                      prescriptionViewModel.setData(model.data, callBack: () {
                        // Navigator.of(context)
                        //     .popUntil(ModalRoute.withName(RouteManager.HOME));
                      });
                      bool updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrescriptionPage(
                            title: '处方修改',
                            showActicons: false,
                          ),
                        ),
                      );
                      prescriptionViewModel.resetData();
                      if (updated) {
                        model.initData();
                      }
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var prescriptionNo = ModalRoute.of(context).settings.arguments;
    return ProviderWidget<PrescriptionDetailModel>(
      model: PrescriptionDetailModel(prescriptionNo as String),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        Widget body;
        List<Widget> actions = [];
        Widget headerWidget = Container();
        if (model.isError) {
          body = ViewStateEmptyWidget(onPressed: model.initData);
        } else {
          if (model.data?.status == 'REJECT') {
            headerWidget = Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Text(
                '未通过原因：${model.data?.reason ?? ''}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          if (model.data?.status == 'EXPIRE') {
            headerWidget = Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Text(
                '处方过期时间：${model.data?.expireTimeText ?? ''}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          body = Column(
            children: [
              headerWidget,
              Expanded(
                child: PerscriptionDetail(
                  model.data,
                  bottom: _buildEditBtn(),
                ),
              ),
            ],
          );
          actions.add(TextButton(
            onPressed: () {
              _showQrCodeDialog(model.data.prescriptionNo);
            },
            child: Text(
              '查看二维码',
              style: TextStyle(color: Colors.white),
            ),
          ));
        }

        return CommonStack(
          appBar: AppBar(
            title: Text(
              "处方详情",
              style: TextStyle(color: Colors.white),
            ),
            actions: actions,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: body,
        );
      },
    );
  }
}
