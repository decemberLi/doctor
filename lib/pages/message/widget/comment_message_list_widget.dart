import 'package:doctor/pages/message/view_model/social_message_list_view_model.dart';
import 'package:doctor/pages/message/widget/redoc_logic.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/widgets/common_widget_style.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentMessagePage extends StatefulWidget {
  CommentMessagePage();

  @override
  State<StatefulWidget> createState() => _CommentMessagePageState();
}

class _CommentMessagePageState extends State<CommentMessagePage> {
  var textStyle =
      const TextStyle(fontSize: 10, color: ThemeColor.colorFF444444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '收到的评论',
          style: TextStyle(fontSize: 17, color: ThemeColor.colorFF000000),
        ),
      ),
      body: Container(
        color: ThemeColor.colorFFF3F5F8,
        child: NormalTableView(
          padding: EdgeInsets.only(top: 10),
          itemBuilder: itemWidget,
          holder: (isError, message) {
            if (isError) {
              return ViewStateEmptyWidget(message: message);
            } else {
              return ViewStateEmptyWidget(message: '还没有任何评论，好落寞');
            }
          },
          getData: (page) async {
            if (page == 1) {
              await _model.initData();
            } else {
              await _model.loadData(pageNum: page);
            }
            return _model.list;
          },
        ),
      ),
    );
  }

  SocialMessageListViewModel _model =
      SocialMessageListViewModel(SocialMessageType.TYPE_COMMENT);

  Widget itemWidget(BuildContext context, dynamic data) {
    var content = Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
      decoration: itemContainerDecoration,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildMessageItemAvatar(data),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                                fit: FlexFit.loose,
                                child: Text('《${data?.messageAbstract ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyle)),
                            Text('》',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(data?.messageTitle ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        data?.messageContent ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, color: ThemeColor.colorFF222222),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              padding: EdgeInsets.only(left: 8),
              child: Text(dateFormat(data?.createTime), style: textStyle),
            )
          ],
        ),
      ),
    );
    return GestureDetector(
      child: content,
      onTap: () {
        onItemClicked(data);
      },
    );
  }

  void onItemClicked(itemData) {
    RouteManager.openDoctorsDetail(itemData?.postId, from: "msg");
    _model.messageClicked(itemData.messageId);
  }
}
