import 'package:doctor/pages/medication/view_model/medication_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/form_item.dart';
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
                height: 40,
                child: TabBar(
                  labelColor: ThemeColor.primaryColor,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: ThemeColor.colorFF222222,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: ThemeColor.primaryColor,
                  tabs: [
                    Tab(
                      text: '介绍',
                    ),
                    Tab(
                      text: '说明书',
                    ),
                  ],
                ),
              ),
              preferredSize: const Size.fromHeight(40.0)),
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
        return Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              MedicationDetailCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 260,
                      child: Swiper(
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return new Image.network(
                            "http://via.placeholder.com/350x150",
                            fit: BoxFit.fill,
                          );
                        },
                        itemCount: 3,
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
                          AceButton(
                            width: 90,
                            height: 30,
                            text: '加入处方',
                            onPressed: () {},
                          ),
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
