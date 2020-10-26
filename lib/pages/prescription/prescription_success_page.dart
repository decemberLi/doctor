import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrescriptionSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('处方创建成功'),
        ),
        body: Container(
          color: ThemeColor.colorFFF3F5F8,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(16),
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
                            height: 20,
                          ),
                          // Image.asset(
                          //   'assets/images/company.png',
                          //   width: 162,
                          //   height: 162,
                          // ),
                          FutureBuilder(
                              future: model.prescriptionQRCode,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return Image.network(
                                    snapshot.data,
                                    width: 162,
                                    height: 162,
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.fitWidth,
                                  );
                                }
                                return Container(
                                  width: 162,
                                  height: 162,
                                );
                              }),

                          // Image.asset(
                          //   'assets/images/company.png',
                          //   width: 162,
                          //   height: 162,
                          // ),
                          SizedBox(
                            height: 34,
                          ),
                          AceButton(
                            type: AceButtonType.outline,
                            text: '查看处方详情',
                            width: 120,
                            height: 36,
                            onPressed: null,
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
                      '方法2:点击页面底部随症患者按钮发给已绑定患者',
                      style: MyStyles.labelTextStyle_12,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              AceButton(
                text: '发给随诊患者',
                onPressed: () {
                  // Navigator.of(context)
                  //     .pushNamed(RouteManager.PATIENT, arguments: '2432342');
                  Navigator.of(context).pushNamed(RouteManager.PATIENT);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
