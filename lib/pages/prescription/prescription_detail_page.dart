import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_detail.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        if (model.isError) {
          body = ViewStateEmptyWidget(onPressed: model.initData);
        } else {
          body = PerscriptionDetail(model.data);
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
        );
      },
    );
  }
}
