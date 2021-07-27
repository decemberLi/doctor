import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/medication/view_model/medication_view_model.dart';
import 'package:doctor/pages/medication/widgets/medication_page_list_item.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 选择药品页面
class MedicationPage extends StatefulWidget {
  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // 保持不被销毁
  @override
  bool get wantKeepAlive => true;
  bool _showSheet = false;
  bool _canChangeSheet = true;
  Animation<double> _animation;
  AnimationController _controller;
  Animation<double> _alphaAnimation;

  // MedicationViewModel _model = MedicationViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      MedicationViewModel _model =
          Provider.of<MedicationViewModel>(context, listen: false);
      List<DrugModel> obj =
          ModalRoute.of(context).settings.arguments as List<DrugModel>;
      _model.initCart(obj);
      _model.initData();
    });
    _initSheetAnimation();
    super.initState();
  }

  @override
  void dispose() {
    // _model.dispose();
    super.dispose();
  }

  Widget _body() {
    return Consumer<MedicationViewModel>(
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
                    RouteManagerOld.MEDICATION_DETAIL,
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
    );
  }

  _initSheetAnimation() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    var cur = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _animation = Tween(begin: 60.0, end: 400.0).animate(cur)
      ..addListener(
        () {
          setState(() {});
        },
      )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.dismissed) {
            setState(() {
              _showSheet = false;
            });
          }
          if (status == AnimationStatus.forward ||
              status == AnimationStatus.reverse) {
            _canChangeSheet = false;
          } else {
            _canChangeSheet = true;
          }
        },
      );
    _alphaAnimation = Tween(begin: 0.0, end: 0.33).animate(cur);
  }

  /// 显示已添加列表
  Widget _sheet(int count) {
    var content = Consumer<MedicationViewModel>(
      builder: (context, model, child) {
        var list = ListView.separated(
          itemBuilder: (context, index) {
            DrugModel item = model.cartList[index];
            return MedicationListItem(
              item,
              showEdit: true,
              showExtra: true,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Color(0xff222222).withOpacity(0.1),
              height: 1,
            );
          },
          itemCount: model.cartList.length,
        );
        ViewStateEmptyWidget();
        var empty = Container(
          color: Colors.white,
          child: Column(
            children: [
              Spacer(),
              Expanded(
                child: Image.asset("assets/images/empty.png"),
              ),
              Container(
                height: 5,
              ),
              Expanded(
                child: Text(
                  "暂无药品添加信息",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xff888888).withOpacity(0.7),
                  ),
                ),
              ),
              Spacer(),
              // Text("222"),
            ],
          ),
        );
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.only(left: 26, right: 26),
          height: _animation.value, //
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "添加列表",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff222222),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                color: Color(0xff222222).withOpacity(0.1),
                height: 1,
              ),
              Expanded(child: count == 0 ? empty : list),
            ],
          ),
        );
      },
    );
    return Stack(
      children: [
        Opacity(
          opacity: _alphaAnimation.value,
          child: GestureDetector(
            onTap: () {
              _showOrHiddenSheet(count);
            },
            child: Container(
              color: Color(0xff000000),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: content,
        )
      ],
    );
  }

  _showOrHiddenSheet(int count) {
    if (!_canChangeSheet) return;
    if (!_showSheet) {
      _showSheet = !_showSheet;
      _controller.forward();
    } else {
      _controller.animateBack(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var model = Provider.of<MedicationViewModel>(context);
    var count = model.cartList.length ?? 0;
    return Scaffold(
      appBar: CoverAppBar(
        _alphaAnimation.value,
        () {
          _showOrHiddenSheet(count);
        },
      ),
      body: Stack(
        children: [
          _body(),
          if (_showSheet) _sheet(count),
        ],
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
                        type: AceButtonType.secondary,
                        color: ThemeColor.primaryColor,
                        textColor: Colors.white,
                        width: 90,
                        height: 30,
                        text: '完成添加',
                        onPressed: () {
                          if (model?.cartList?.length != null &&
                              model.cartList.length > 5) {
                            EasyLoading.showToast('最多只能选择5种药品');
                            return;
                          }
                          List resultList = [];
                          for (var each in model.cartList) {
                            resultList.add(DrugModel.fromJson(each.toJson()));
                          }
                          Navigator.pop(context, resultList);
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
        clipBehavior: Clip.none,
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
              _showOrHiddenSheet(count);
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
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}

class CoverAppBar extends StatelessWidget with PreferredSizeWidget {
  final double opacity;
  final Function() dismiss;

  CoverAppBar(this.opacity, this.dismiss);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(
          title: Text('云药房'),
          elevation: 1,
        ),
        if (opacity > 0)
          Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () {
                this.dismiss();
              },
              child: Container(
                color: Color(0xff000000),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
