import 'package:doctor/pages/message/model/message_list_entity.dart';
import 'package:doctor/pages/message/view_model/message_list_view_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
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
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(right: 16),
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
                              color:
                                  alreadyRead ? Colors.red : Colors.transparent,
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
                            '${entity?.createTime ?? ''}',
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
          Container(height: 8)
        ],
      );
    }

    return Scaffold(
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
}
