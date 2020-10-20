import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:doctor/pages/prescription/view_model/medication_view_model.dart';
import 'package:doctor/pages/prescription/widgets/medication_add_sheet.dart';
import 'package:doctor/pages/prescription/widgets/medication_page_list_item.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 选择药品页面
class MedicationPage extends StatefulWidget {
  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage>
    with AutomaticKeepAliveClientMixin {
  // 保持不被销毁
  @override
  bool get wantKeepAlive => true;

  // 显示药品添加弹窗
  Future<void> _showAddToCartSheet(DrugModel item) {
    return CommonModal.showBottomSheet(
      context,
      title: '药品用法用量',
      height: 560,
      child: MedicationAddSheet(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('云药房'),
        elevation: 1,
      ),
      body: ProviderWidget<MedicationViewModel>(
        model: MedicationViewModel(),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          if (model.isError) {
            return ViewStateErrorWidget(
                error: model.viewStateError, onPressed: model.initData);
          }
          if (model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: model.initData);
          }
          return SmartRefresher(
            controller: model.refreshController,
            header: ClassicHeader(),
            footer: ClassicFooter(),
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            enablePullUp: true,
            child: ListView.separated(
              itemBuilder: (context, index) {
                DrugModel item = model.list[index];
                return MedicationListItem(
                  item,
                  onAdd: (DrugModel item) {
                    this._showAddToCartSheet(item);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: model.list.length,
              padding: EdgeInsets.all(16),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          children: [
            SizedBox(), //按钮位置空出
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Text('共计：1盒'),
                  SizedBox(
                    width: 10,
                  ),
                  AceButton(
                    width: 90,
                    height: 30,
                    text: '完成添加',
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end, //均分底部导航栏横向空间
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFDA705),
        //悬浮按钮
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
