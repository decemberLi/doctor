// import 'package:doctor/route/route_manager.dart';
import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/learn_detail_item_wiget.dart';

// * @Desc: 计划详情页  */
class LearnDetailPage extends StatefulWidget {
  LearnDetailPage({Key key}) : super(key: key);

  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LearnDetailPage> {
  bool _isExpanded = true;

  List get formList => [
        {'field': 'taskTemplate', 'label': '学习计划类型'},
        {'field': 'companyName', 'label': '来自企业'},
        {'field': 'representName', 'label': '医学信息推广专员'},
        {
          'field': 'createTime',
          'label': '收到学习计划日期',
        }
      ];

  Widget typeDecoratedBox(String type) {
    Color rendColor = ThemeColor.color72c140;
    if (type == 'VIDEO') {
      rendColor = ThemeColor.color5d9df7;
    } else if (type == 'QUESTIONNAIRE') {
      rendColor = ThemeColor.colorefaf41;
    }
    return DecoratedBox(
        decoration: BoxDecoration(color: rendColor),
        child: Padding(
          // 分别指定四个方向的补白
          padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
          child: Text(MAP_RESOURCE_TYPE[type],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              )),
        ));
  }

  // 头部计划信息
  Widget planTopList(LearnDetailItem data) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content;
    String fieldText = '开始学习'; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in formList) {
      if (item['field'] == 'taskTemplate') {
        fieldText = TASK_TEMPLATE[data.taskTemplate];
      }
      if (item['field'] == 'companyName') {
        fieldText = data.companyName;
      }
      if (item['field'] == 'representName') {
        fieldText = data.representName;
      }
      if (item['field'] == 'createTime') {
        fieldText =
            DateUtil.formatDateMs(data.createTime, format: 'yyyy年MM月dd HH:mm');
      }
      tiles.add(new Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ThemeColor.colorFFF3F5F8),
            ),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(item['label'],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    )),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Text(
                    fieldText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ])));
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
        );
    return content;
  }

  // 提交按钮
  String _aceText(type, reLearn) {
    String text = reLearn ? '重传讲课视频' : '提交学习计划';
    if (type == 'DOCTOR_LECTURE') {
      text = '上传讲课视频';
    }
    return text;
  }

  // 如何录制讲课视频
  Widget _buildLookCourse(data) {
    // 文本字段（`TextField`）组件，允许用户使用硬件键盘或屏幕键盘输入文本。
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('当前完成度：${data.learnProgress}%',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: ThemeColor.primaryColor,
          )),
      if (data.taskTemplate == 'DOCTOR_LECTURE')
        GestureDetector(
          child: Text(
            '如何录制讲课视频？',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: ThemeColor.primaryColor,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid),
          ),
          onTap: () {
            EasyLoading.showToast('如何录制讲课视频？');
            print('111');
          },
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    int arguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('学习计划详情'),
      ),
      body: ProviderWidget<LearnDetailViewModel>(
        model: LearnDetailViewModel(arguments),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Container();
          }
          if (model.isError || model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: model.initData);
          }
          var data = model.data;
          return Container(
              color: ThemeColor.colorFFF3F5F8,
              child: Container(
                alignment: Alignment.topCenter,
                color: ThemeColor.colorFFF3F5F8,
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                                title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: ThemeColor.primaryColor,
                                      ),
                                    ]),
                                leading: Text('学习计划信息',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: ThemeColor.primaryColor,
                                    )),
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                }),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: ThemeColor.colorFFF3F5F8),
                                  ),
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('学习计划名称',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          data.taskName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.right,
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ])),
                            Column(
                                children:
                                    _isExpanded ? [planTopList(data)] : []),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(children: [
                                _buildLookCourse(data),
                              ]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AceButton(
                              text: _aceText(data.taskTemplate, data.reLearn),
                              onPressed: () => {
                                if (data.taskTemplate == 'DOCTOR_LECTURE')
                                  {
                                    Navigator.of(context).pushNamed(
                                        RouteManager.LEARN_UPLOAD_RECORD,
                                        arguments: {
                                          'resourceId': data.resources ??
                                              data.resources[0].resourceId,
                                          'learnPlanId': data.learnPlanId,
                                          'doctorName': data.doctorName,
                                          'taskName': data.taskName
                                        })
                                  }
                                else
                                  {EasyLoading.showToast('暂未开放')},
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        child: Container(
                            // margin: EdgeInsets.only(bottom: 12),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text('资料列表',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: ThemeColor.primaryColor,
                                )))),
                    Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: PlanDetailList(data)),
                  ],
                ),
              ));
        },
      ),
    );
  }
}