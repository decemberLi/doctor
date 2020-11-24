import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/view_model/prescription_template_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
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
    String drugInfo = data.drugRps
        .map((e) => '${e.drugName}*${e.quantity}')
        .toList()
        .join(',');
    return Container(
      color: Colors.white,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
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
                Text(
                  '临床诊断：${data.clinicalDiagnosis}',
                  style: MyStyles.labelTextStyle_12,
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    Text(
                      '药品信息：',
                      style: MyStyles.labelTextStyle_12,
                    ),
                    Text(
                      '$drugInfo',
                      style: MyStyles.labelTextStyle_12,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          AceButton(
            width: 80,
            height: 30,
            fontSize: 14,
            type: AceButtonType.secondary,
            color: ThemeColor.primaryColor,
            textColor: Colors.white,
            text: '确认选择',
            onPressed: () {
              this.onSelected(data);
            },
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
      child: ProviderWidget<PrescriptionTemplateViewModel>(
        model: PrescriptionTemplateViewModel(),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          Widget list = Container();
          if (model.isError || model.isEmpty) {
            list = ViewStateEmptyWidget(
              onPressed: model.initData,
              message: '暂无处方模板，快去添加吧',
            );
          } else {
            list = SmartRefresher(
              controller: model.refreshController,
              header: ClassicHeader(),
              footer: ClassicFooter(),
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              enablePullUp: true,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  PrescriptionTemplateModel item = model.list[index];
                  return GestureDetector(
                    child: PrescriptionTemplateItem(item, widget.onSelected),
                    onTap: () {
                      _openPrescriptTemplatePage(
                          context, model, item, 'modify');
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemCount: model.list.length,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: list,
              ),
              SizedBox(
                height: 10,
              ),
              AceButton(
                text: '+ 添加模板',
                type: AceButtonType.secondary,
                onPressed: () {
                  _openPrescriptTemplatePage(context, model, null, 'add');
                },
              ),
              SizedBox(
                height: 16,
              ),
            ],
          );
        },
      ),
    );
  }

  Future _openPrescriptTemplatePage(
      BuildContext context,
      PrescriptionTemplateViewModel model,
      PrescriptionTemplateModel item,
      String action) async {
    await Navigator.of(context).pushNamed(
      RouteManager.PRESCRIPTION_TEMPLATE_ADD,
      arguments: {
        'action': action,
        'data': item,
      },
    );
    model.initData();
  }
}
