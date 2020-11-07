import 'package:doctor/pages/medication/view_model/medication_view_model.dart';
import 'package:doctor/pages/medication/widgets/medication_add_btn.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/indocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

/// 药品详情页
class MedicationDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int drugId = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('药品详情'),
          elevation: 0,
          bottom: PreferredSize(
            child: Container(
              color: ThemeColor.colorFFF3F5F8,
              height: 48,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                color: ThemeColor.colorFFF3F5F8,
                child: TabBar(
                  isScrollable: true,
                  labelColor: ThemeColor.primaryColor,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: ThemeColor.colorFF222222,
                  // indicator: CircleTabIndicator(
                  //     color: ThemeColor.primaryColor, radius: 12),
                  // indicator: ShapeDecoration(
                  //   // color: ThemeColor.primaryColor,
                  //   shape: UnderlineInputBorder(
                  //     borderSide:
                  //         BorderSide(width: 2, color: ThemeColor.primaryColor),
                  //     borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(12.0),
                  //         topRight: Radius.circular(12.0)),
                  //   ),
                  // ),
                  indicatorPadding: EdgeInsets.symmetric(vertical: 0),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: ThemeColor.primaryColor,
                  tabs: [
                    Container(
                      height: 20,
                      child: Tab(
                        text: '介绍',
                      ),
                    ),
                    Container(
                      height: 20,
                      child: Tab(
                        text: '说明书',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            preferredSize: const Size.fromHeight(40.0),
          ),
        ),
        body: Container(
          color: ThemeColor.colorFFF3F5F8,
          child: ProviderWidget<MedicationDetailViewModel>(
            model: MedicationDetailViewModel(drugId),
            onModelReady: (model) => model.initData(),
            builder: (context, model, child) {
              return TabBarView(
                children: [
                  MedicationIntroduce(),
                  MedicationIntruction(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MedicationDetailCard extends StatelessWidget {
  final Widget child;
  MedicationDetailCard({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Card(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
          child: child,
        ),
      ),
    );
  }
}

class MedicationIntroduce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationDetailViewModel>(
      builder: (context, model, child) {
        bool morePics =
            model.data != null ? model.data.pictures.length > 1 : false;
        return Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              MedicationDetailCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 260,
                      child: Swiper(
                        autoplay: morePics,
                        loop: morePics,
                        itemBuilder: (BuildContext context, int index) {
                          if (model.data == null) {
                            return Container();
                          }
                          return Image.network(
                            model.data.pictures[index],
                            fit: BoxFit.fitWidth,
                          );
                        },
                        itemCount: model.data?.pictures?.length ?? 0,
                        pagination: SwiperPagination(
                          alignment: Alignment.bottomRight,
                          builder: FractionPaginationBuilder(
                            fontSize: 12,
                            activeFontSize: 12,
                            activeColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      model.data?.drugName ?? '',
                      style: MyStyles.inputTextStyle,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                ),
                                margin: EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: ThemeColor.colorFFFD4B40,
                                  ),
                                ),
                                child: Text(
                                  'RX',
                                  style: MyStyles.redTextStyle,
                                ),
                              ),
                              Icon(
                                Icons.description_outlined,
                                size: 20,
                                color: ThemeColor.colorFF222222,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '说明书',
                                style: MyStyles.inputTextStyle_12,
                              ),
                            ],
                          ),
                          Consumer<MedicationViewModel>(builder:
                              (context, MedicationViewModel viewModel, child) {
                            return MedicationAddBtn(
                              viewModel.list.firstWhere(
                                  (data) => model.drugId == data.drugId),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              MedicationDetailCard(
                child: Column(
                  children: [
                    FormItem(
                      label: '参考均价：',
                      value: '￥${model.data?.drugPrice ?? ''}',
                      padding: EdgeInsets.symmetric(vertical: 20),
                      borderDirection: FormItemBorderDirection.bottom,
                    ),
                    FormItem(
                      label: '生产厂家：',
                      value: model.data?.producer ?? '',
                      padding: EdgeInsets.symmetric(vertical: 20),
                      borderDirection: FormItemBorderDirection.bottom,
                    ),
                    FormItem(
                      label: '包装规格：',
                      value: model.data?.drugSize ?? '',
                      padding: EdgeInsets.only(top: 20),
                      borderDirection: FormItemBorderDirection.none,
                    ),
                  ],
                ),
              ),
              MedicationDetailCard(
                child: Column(
                  children: [
                    FormItem(
                      label: '用法用量：',
                      value: '${model.data?.useInfo ?? ''}',
                      padding: EdgeInsets.symmetric(vertical: 20),
                      borderDirection: FormItemBorderDirection.bottom,
                    ),
                    FormItem(
                      label: '适应症：',
                      value: '',
                      padding: EdgeInsets.symmetric(vertical: 20),
                      borderDirection: FormItemBorderDirection.bottom,
                    ),
                    FormItem(
                      label: '不良反应：',
                      value: '',
                      padding: EdgeInsets.only(top: 20),
                      borderDirection: FormItemBorderDirection.none,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MedicationIntruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationDetailViewModel>(
        builder: (context, model, child) {
      return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16),
        child: MedicationDetailCard(
          child: Column(
            children: [
              FormItem(
                label: '药品名称：',
                value: '${model.data?.drugName ?? ''}',
                padding: EdgeInsets.symmetric(vertical: 20),
                borderDirection: FormItemBorderDirection.bottom,
              ),
              FormItem(
                label: '商品名：',
                value: '',
                padding: EdgeInsets.symmetric(vertical: 20),
                borderDirection: FormItemBorderDirection.bottom,
              ),
              FormItem(
                label: '英文名：',
                value: '',
                padding: EdgeInsets.symmetric(vertical: 20),
                borderDirection: FormItemBorderDirection.bottom,
              ),
              FormItem(
                label: '规格：',
                value: '',
                padding: EdgeInsets.symmetric(vertical: 20),
                borderDirection: FormItemBorderDirection.bottom,
              ),
              FormItem(
                label: '剂型：',
                value: model.data?.drugType ?? '',
                padding: EdgeInsets.only(top: 20),
                borderDirection: FormItemBorderDirection.none,
              ),
            ],
          ),
        ),
      );
    });
  }
}
