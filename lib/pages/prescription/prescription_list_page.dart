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

const FROM_PRESCRIPTION_HISTORY = '_prescription_history';
const FROM_PRESCRIPTION_QUICKLY = '_prescription_quickly';

/// 处方记录列表
class PrescriptionListPage extends StatefulWidget {
  final String from;

  PrescriptionListPage({this.from = FROM_PRESCRIPTION_HISTORY});

  bool get isQuickCratePrescription => from == FROM_PRESCRIPTION_QUICKLY;

  @override
  _PrescriptionListPageState createState() => _PrescriptionListPageState();
}

class _PrescriptionListPageState extends State<PrescriptionListPage> {
  final PrescriptionListViewModel _model = PrescriptionListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.isQuickCratePrescription ? '选择处方记录' : '处方记录'),
        bottom: PreferredSize(
          preferredSize: Size(343, 60),
          child: Container(
            height: 56,
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 10),
            child: Theme(
              data: new ThemeData(primaryColor: Colors.white),
              child: TextField(
                onSubmitted: (text) {
                  _model.queryKey = text;
                  _model.refresh(init: true);
                  _model.refreshController
                      .requestRefresh(duration: Duration(microseconds: 1));
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0),
                  fillColor: Color(0XFFF3F5F8),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    //未选中时候的颜色
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  hintText: '搜索患者姓名或药品名称',
                  hintStyle: TextStyle(color: Color(0xff999999)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xff999999),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: ThemeColor.colorFFF3F5F8,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.zero,
        child: ProviderWidget<PrescriptionListViewModel>(
          model: _model,
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
                      if (widget.isQuickCratePrescription) {
                        Navigator.pop(context, item);
                        return;
                      }
                      Navigator.of(context).pushNamed(
                        RouteManagerOld.PRESCRIPTION_DETAIL,
                        arguments: item.prescriptionNo,
                      );
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
