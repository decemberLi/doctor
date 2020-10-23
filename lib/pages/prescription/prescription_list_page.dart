import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_list_item.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 处方记录列表
class PrescriptionListPage extends StatefulWidget {
  PrescriptionListPage();

  @override
  _PrescriptionListPageState createState() => _PrescriptionListPageState();
}

class _PrescriptionListPageState extends State<PrescriptionListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('处方记录'),
      ),
      body: Container(
        color: ThemeColor.colorFFF3F5F8,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.zero,
        child: ProviderWidget<PrescriptionListViewModel>(
          model: PrescriptionListViewModel(),
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
              enablePullUp: true,
              child: ListView.builder(
                itemCount: model.list.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  PrescriptionModel item = model.list[index];
                  return GestureDetector(
                    child: PrescriptionListLitem(item),
                    onTap: () {
                      print(333);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
