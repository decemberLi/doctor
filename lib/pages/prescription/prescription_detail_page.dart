import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/prescription/prescription_page.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_detail.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
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
  @override
  Widget build(BuildContext context) {
    var prescriptionNo = ModalRoute.of(context).settings.arguments;
    return ProviderWidget<PrescriptionDetailModel>(
      model: PrescriptionDetailModel(prescriptionNo as String),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        Widget body;
        List<Widget> actions = [];
        Widget reson = Container();
        if (model.isError) {
          body = ViewStateEmptyWidget(onPressed: model.initData);
        } else {
          if (model.data?.status == 'REJECT') {
            reson = Container(
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

          body = Column(
            children: [
              reson,
              Expanded(child: PerscriptionDetail(model.data)),
            ],
          );
          actions.add(TextButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(RouteManager.PRESCRIPTION_LIST);
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
          positionedChild: Positioned(
            bottom: 100,
            width: MediaQuery.of(context).size.width,
            child: Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<PrescriptionViewModel>(
                      builder: (_, prescriptionViewModel, __) {
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
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
