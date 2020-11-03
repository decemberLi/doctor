import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/medication/view_model/medication_view_model.dart';
import 'package:doctor/pages/medication/widgets/medication_page_list_item.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  // MedicationViewModel _model = MedicationViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      MedicationViewModel _model =
          Provider.of<MedicationViewModel>(context, listen: false);
      List<DrugModel> obj =
          ModalRoute.of(context).settings.arguments as List<DrugModel>;
      _model.initCart(obj);
      if (_model.list.isEmpty) {
        _model.initData();
      }
    });
    // MedicationViewModel _model =
    //     Provider.of<MedicationViewModel>(context, listen: false);
    // _model.initData();
    super.initState();
  }

  @override
  void dispose() {
    // _model.dispose();
    super.dispose();
  }

  // 显示已添加列表
  Future<void> _showCartSheet() {
    return CommonModal.showBottomSheet(
      context,
      title: '添加列表',
      child: Consumer<MedicationViewModel>(
        builder: (context, model, child) {
          // print(model.cartList);
          return Container(
            child: ListView.separated(
              itemBuilder: (context, index) {
                DrugModel item = model.cartList[index];
                return MedicationListItem(
                  item,
                  showEdit: true,
                  showExtra: true,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: model.cartList.length,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return ChangeNotifierProvider<MedicationViewModel>.value(
    //   value: _model,
    //   child:
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('云药房'),
        elevation: 1,
      ),
      // body: Selector<MedicationViewModel, List>(
      //   selector: (BuildContext _, MedicationViewModel model) => model.list,
      //   builder: (BuildContext _, List list, Widget __) {
      //     if (_model.isError) {
      //       return ViewStateErrorWidget(
      //           error: _model.viewStateError, onPressed: _model.initData);
      //     }
      //     if (_model.isEmpty) {
      //       return ViewStateEmptyWidget(onPressed: _model.initData);
      //     }
      //     return SmartRefresher(
      //       controller: _model.refreshController,
      //       header: ClassicHeader(),
      //       footer: ClassicFooter(),
      //       onRefresh: _model.refresh,
      //       onLoading: _model.loadMore,
      //       enablePullUp: true,
      //       child: ListView.separated(
      //         itemBuilder: (context, index) {
      //           return Selector<MedicationViewModel, DrugModel>(
      //             selector: (BuildContext _, MedicationViewModel model) =>
      //                 model.list[index],
      //             builder: (BuildContext _, dynamic data, Widget __) {
      //               DrugModel item = data;
      //               return MedicationListItem(item);
      //             },
      //           );
      //         },
      //         separatorBuilder: (BuildContext context, int index) {
      //           return Divider();
      //         },
      //         itemCount: _model.list.length,
      //         padding: EdgeInsets.all(16),
      //       ),
      //     );
      //   },
      // ),
      body: Consumer<MedicationViewModel>(
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
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteManager.MEDICATION_DETAIL,
                      arguments: item.drugId,
                    );
                  },
                  child: MedicationListItem(
                    item,
                  ),
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
      bottomNavigationBar: Consumer<MedicationViewModel>(
        builder: (context, model, child) {
          return BottomAppBar(
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
                      Text(
                        '合计：',
                      ),
                      Text(
                        '${MoneyUtil.changeF2YWithUnit(model.totalPrice.toInt(), unit: MoneyUnit.YUAN)}',
                        style: MyStyles.redTextStyle.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      AceButton(
                        width: 90,
                        height: 30,
                        text: '完成添加',
                        onPressed: () {
                          Navigator.pop(context, model.cartList);
                        },
                      ),
                    ],
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end, //均分底部导航栏横向空间
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        overflow: Overflow.visible,
        children: [
          FloatingActionButton(
            backgroundColor: Color(0xFFFDA705),
            //悬浮按钮
            child: Text(
              'RX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              _showCartSheet();
            },
          ),
          Positioned(
            top: -8,
            right: -12,
            child: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ThemeColor.colorFFFD4B40,
                shape: BoxShape.circle,
              ),
              child: Consumer<MedicationViewModel>(
                  builder: (context, model, child) {
                return Text(
                  '${model.cartList.length ?? ''}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
