import 'package:doctor/pages/message/model/message_list_entity.dart';
import 'package:doctor/pages/message/view_model/message_list_view_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///
/// 医生消息列表
/// 消息类型
/// SYSTEM 系统消息,
/// PRESCRIPTION 处方消息，
/// LEAN_PLAN 学习计划消息，
/// INTERACTIVE 互动消息
///
///
class MessageType {
  static const String TYPE_SYSTEM = 'SYSTEM';
  static const String TYPE_PRESCRIPTION = 'PRESCRIPTION';
  static const String TYPE_LEAN_PLAN = 'LEAN_PLAN';
  static const String TYPE_INTERACTIVE = 'INTERACTIVE';
}

class MessageListPage extends StatefulWidget {
  String _type;
  Map<String, String> _map = {
    MessageType.TYPE_SYSTEM: '系统消息',
    MessageType.TYPE_PRESCRIPTION: '处方消息',
    MessageType.TYPE_LEAN_PLAN: '学习计划消息',
    MessageType.TYPE_INTERACTIVE: '互动消息',
  };

  MessageListPage(this._type);

  @override
  State<StatefulWidget> createState() {
    return _MessageListPageState();
  }
}

class _MessageListPageState extends State<MessageListPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget itemWidget(MessageListEntity entity) {
      bool alreadyRead = entity?.readed ?? false;
      return Column(
        children: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Image.asset('assets/images/avatar.png'),
                      Positioned(
                          right: 15,
                          top: 8,
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: alreadyRead
                                    ? Colors.transparent
                                    : Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                          ))
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                entity?.messageTitle ?? '',
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xFF0B0B0B), fontSize: 14),
                              ),
                            ),
                            Text(
                              _dateFormat(entity?.createTime),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Color(0xFF0B0B0B), fontSize: 10),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            entity?.messageContent ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => _openDetail(widget._type, entity),
          ),
          Container(height: 8)
        ],
      );
    }

    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('${widget._map[widget._type]}'),
      ),
      body: ProviderWidget<MessageListModel>(
        model: MessageListModel(widget._type),
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
                  MessageListEntity item = model?.list[index];
                  if (item == null) {
                    return itemWidget(null);
                  }
                  return itemWidget(item);
                }),
          );
        },
      ),
    );
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
      return '${msgDateTime.hour}:${msgDateTime.minute}';
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
      return '${msgDateTime.year}/${msgDateTime.month}/${msgDateTime.day}';
    }
  }

  _openDetail(String type, MessageListEntity entity) {
    if (type == MessageType.TYPE_SYSTEM) {
      Navigator.pushNamed(context, RouteManager.QUALIFICATION_PAGE);
    }else if(type == MessageType.TYPE_LEAN_PLAN){
      Navigator.pushNamed(context, RouteManager.LEARN_DETAIL);
    }else if(type == MessageType.TYPE_PRESCRIPTION){
      Navigator.pushNamed(context, RouteManager.PRESCRIPTION_DETAIL);
    }else if(type == MessageType.TYPE_INTERACTIVE){
      Navigator.pushNamed(context, RouteManager.COLLECT_DETAIL);
    }
  }
}
