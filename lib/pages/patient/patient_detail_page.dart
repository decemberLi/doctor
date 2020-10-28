import 'package:doctor/pages/patient/view_model/patient_view_model.dart';
import 'package:doctor/pages/patient/widget/prescripion_list_item.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 随诊患者详情
class PatientDetailPage extends StatefulWidget {
  PatientDetailPage();

  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage>
    with AutomaticKeepAliveClientMixin {
  // 保持不被销毁
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var patientUserId = ModalRoute.of(context).settings.arguments;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('患者详情'),
      ),
      body: Container(
        color: ThemeColor.colorFFF3F5F8,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.zero,
        child: ProviderWidget<PatientDetailModel>(
          model: PatientDetailModel(patientUserId as int),
          onModelReady: (model) => model.initData(),
          builder: (context, model, child) {
            if (model.isError || model.isEmpty) {
              return ViewStateEmptyWidget(onPressed: model.initData);
            }
            return SmartRefresher(
              controller: model.refreshController,
              header: ClassicHeader(),
              footer: ClassicFooter(),
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              enablePullUp: model.list.isNotEmpty,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.asset(
                              'assets/images/avatar.png',
                              width: 62,
                              fit: BoxFit.fitWidth,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.patient?.patientName ?? '',
                                  style: MyStyles.boldTextStyle_20,
                                ),
                                Text(
                                  '${model.patient?.sexLabel ?? ''} | ${model.patient?.age ?? ''}岁',
                                  style: MyStyles.inputTextStyle_12,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                VerticalDivider(
                                  width: 20,
                                  thickness: 2,
                                  indent: 2,
                                  endIndent: 2,
                                  color: ThemeColor.primaryColor,
                                ),
                                Text(
                                  '诊疗记录',
                                  style: MyStyles.inputTextStyle,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        PrescriptionModel item = model.list[index];
                        return PrescripionListItem(item);
                      }, childCount: model.list?.length ?? 0),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
