import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/view_model/prescription_template_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/one_line_text.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrescriptionTemplateItem extends StatelessWidget {
  final PrescriptionTemplateModel data;

  final Function(PrescriptionTemplateModel) onSelected;

  PrescriptionTemplateItem(this.data, this.onSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneLineText(
            data.prescriptionTemplateName,
            style: MyStyles.inputTextStyle,
          ),
          SizedBox(
            height: 10,
          ),
          OneLineText(
            '疾病诊断：${data.clinicalDiagnosis}',
            style: MyStyles.labelTextStyle_12,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: OneLineText(
                  '药品信息：${data.drugRps.map((e) => e.drugName).toList().join(',')}',
                  style: MyStyles.labelTextStyle_12,
                ),
              ),
              AceButton(
                width: 80,
                height: 30,
                fontSize: 14,
                text: '确认选择',
                onPressed: () {
                  this.onSelected(data);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 处方模板列表
class PrescriptionTemplateList extends StatefulWidget {
  final Function(PrescriptionTemplateModel) onSelected;

  PrescriptionTemplateList({
    this.onSelected,
  });

  @override
  _PrescriptionTemplateListState createState() =>
      _PrescriptionTemplateListState();
}

class _PrescriptionTemplateListState extends State<PrescriptionTemplateList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ProviderWidget<PrescriptionTemplateViewModel>(
              model: PrescriptionTemplateViewModel(),
              onModelReady: (model) => model.initData(),
              builder: (context, model, child) {
                if (model.isError || model.isEmpty) {
                  return ViewStateEmptyWidget(onPressed: model.initData);
                }
                return SmartRefresher(
                  controller: model.refreshController,
                  header: ClassicHeader(),
                  footer: ClassicFooter(),
                  enablePullDown: false,
                  // onRefresh: model.refresh,
                  onLoading: model.loadMore,
                  enablePullUp: true,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      PrescriptionTemplateModel item = model.list[index];
                      return PrescriptionTemplateItem(item, widget.onSelected);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemCount: model.list.length,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          AceButton(
            text: '+ 添加模板',
            type: AceButtonType.secondary,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(RouteManager.PRESCRIPTION_TEMPLATE_ADD);
            },
          ),
        ],
      ),
    );
  }
}
