import 'dart:ffi';

import 'package:doctor/pages/doctors/tab_indicator.dart';
import 'package:doctor/pages/message/model/message_list_entity.dart';
import 'package:doctor/pages/message/view_model/message_list_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessagePromotionList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessagePromotionListState();
  }
}

class _MessagePromotionListState extends State<MessagePromotionList> {
  final _list = ["学习计划", "互动消息"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    var content = Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text("学术推广"),
        elevation: 0,
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            width: width,
            height: 40,
            child: TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _list.map((e) => Text(e)).toList(),
              indicator: LinearGradientTabIndicatorDecoration(
                  borderSide: BorderSide(width: 4.0, color: Colors.white),
                  insets: EdgeInsets.only(left: 7, right: 7)),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.colorFF222222,
                  fontSize: 16),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: ThemeColor.colorFF444444,
                  fontSize: 16),
            ),
          ),
          Container(
            height: 0.5,
            color: Color(0xffeeeeee),
          ),
          Expanded(
              child: Container(
            child: TabBarView(children: [
              _SubCollectList(
                  type: "LEAN_PLAN",
                  itemBuilder: (context, item, model) {
                    return _MessageStudyCell(
                      item,
                      onTap: (data) {
                        model.mark('${data.messageId}');
                        if (data.params == null ||
                            data.params['learnPlanId'] == null) {
                          return;
                        }
                        Navigator.pushNamed(context, RouteManager.LEARN_DETAIL,
                            arguments: {
                              'learnPlanId': data.params['learnPlanId'],
                            });
                      },
                    );
                  }),
              _SubCollectList(
                  type: "INTERACTIVE",
                  itemBuilder: (context, item, model) {
                    return _InteractiveCell(
                      item,
                      onTap: (data) {
                        model.mark('${data.messageId}');
                        Navigator.of(context).pushNamed(
                            RouteManager.RESOURCE_DETAIL,
                            arguments: {
                              "resourceId": data.params['resourceId'],
                              "learnPlanId": data.params['learnPlanId'],
                              'from': 'MESSAGE_CENTER'
                            });
                      },
                    );
                  }),
            ]),
          ))
        ],
      )),
    );
    return DefaultTabController(length: _list.length, child: content);
  }
}

class _SubCollectList extends StatefulWidget {
  final Widget Function(BuildContext, MessageListEntity, MessageListModel)
      itemBuilder;
  final String type;
  _SubCollectList({@required this.itemBuilder, @required this.type});
  @override
  State<StatefulWidget> createState() {
    return _SubCollectState();
  }
}

class _SubCollectState extends State<_SubCollectList> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MessageListModel>(
      model: MessageListModel(widget.type),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        return content(context, model);
      },
    );
  }

  Widget content(BuildContext context, MessageListModel model) {
    Widget child = Center(
      child: ViewStateEmptyWidget(
        message: "给我一点学习成长的机会",
      ),
    );
    var _list = model.list;
    if (_list.length > 0) {
      child = ListView.builder(
        itemCount: _list.length,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        itemBuilder: (context, index) {
          var item = _list[index];
          return widget.itemBuilder(context, item, model);
        },
      );
    }
    return SmartRefresher(
      controller: model.refreshController,
      header: ClassicHeader(),
      footer: ClassicFooter(),
      onRefresh: model.refresh,
      onLoading: model.loadMore,
      enablePullUp: true,
      child: child,
    );
  }
}

_format(int number) {
  if (number < 10) {
    return '0$number';
  }
  return '$number';
}

_dateFormat(num timeMillis) {
  if (timeMillis == null) {
    return '';
  }
  var msgDateTime = DateTime.fromMillisecondsSinceEpoch(timeMillis);
  var now = DateTime.now();
  var toDayStartTime = DateTime(now.year, now.month, now.day);
  // 当日
  if (timeMillis >= toDayStartTime.millisecondsSinceEpoch) {
    return '${_format(msgDateTime.hour)}:${_format(msgDateTime.minute)}';
  }
  // 昨天
  var yesterday = now.subtract(new Duration(days: 1));
  var yesterdayStartTime =
      DateTime(yesterday.year, yesterday.month, yesterday.day);
  if (timeMillis >= yesterdayStartTime.millisecondsSinceEpoch) {
    return '昨天';
  } else {
    // 其他
    //2020/10/12
    return '${_format(msgDateTime.year)}/${_format(msgDateTime.month)}/${_format(msgDateTime.day)}';
  }
}

_icon(MessageListEntity entity) {
  if (entity.bizType == 'PRESCRIPTION_REJECT' ||
      entity.bizType == 'AUTH_STATUS_FAIL') {
    return Image.asset(
      'assets/images/reject.png',
      width: 40,
      height: 40,
    );
  }
  if (entity.bizType == 'DOCTOR_RE_LEARN') {
    return Image.asset(
      'assets/images/re_visit.png',
      width: 40,
      height: 40,
    );
  }
  if (entity.bizType == 'AUTH_STATUS_PASS') {
    return Image.asset(
      'assets/images/pass.png',
      width: 40,
      height: 40,
    );
  }

  return ImageWidget(
    url: entity.createUserHeadPic,
    width: 38,
    height: 38,
    defImagePath: "assets/images/doctor.png",
  );
}

class _MessageStudyCell extends StatelessWidget {
  final MessageListEntity data;
  final void Function(MessageListEntity) onTap;
  _MessageStudyCell(this.data, {this.onTap});
  Widget content() {
    bool alreadyRead = data.readed;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            _icon(data),
            Positioned(
              right: 2,
              top: 0,
              child: Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: alreadyRead ? Colors.transparent : Colors.red,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: 12,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              Expanded(
                  child: Text(
                data.messageTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: ThemeColor.colorFF222222,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              )),
              Container(
                width: 5,
              ),
              Text(
                _dateFormat(data.createTime),
                style: TextStyle(fontSize: 10, color: ThemeColor.colorFF444444),
              )
            ]),
            Container(height: 7),
            Row(children: [
              Expanded(
                  child: Text(
                data.messageContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: ThemeColor.colorFF444444),
              )),
              Text(
                _dateFormat(data.createTime),
                style: TextStyle(fontSize: 10, color: ThemeColor.colorFFFFFF),
              )
            ])
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: FlatButton(
          onPressed: () {
            onTap(data);
          },
          child: Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: content(),
          )),
    );
  }
}

class _InteractiveCell extends StatelessWidget {
  final MessageListEntity data;
  final void Function(MessageListEntity) onTap;
  _InteractiveCell(this.data, {this.onTap});

  Widget content() {
    bool alreadyRead = data.readed;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: ThemeColor.colorFFF3F5F8,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Color(0xffb8d1e2), width: 2)),
          child: Stack(
            children: [
              _icon(data),
              Positioned(
                right: 2,
                top: 0,
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: alreadyRead ? Colors.transparent : Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 12,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.messageTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12, color: ThemeColor.colorFF444444),
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  Text(
                    _dateFormat(data.createTime),
                    style: TextStyle(
                        fontSize: 10, color: ThemeColor.colorFF444444),
                  ),
                ],
              ),
              Container(height: 7),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.messageContent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ThemeColor.colorFF222222,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  Text(
                    _dateFormat(data.createTime),
                    style:
                        TextStyle(fontSize: 10, color: ThemeColor.colorFFFFFF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: FlatButton(
        onPressed: () {
          onTap(data);
        },
        child: Container(
          height: 70,
          padding: EdgeInsets.only(left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: content(),
        ),
      ),
    );
  }
}
