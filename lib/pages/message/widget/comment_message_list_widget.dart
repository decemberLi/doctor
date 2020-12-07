import 'package:doctor/pages/message/view_model/social_message_list_view_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/common_widget_style.dart';
import 'package:doctor/widgets/refreshable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentMessagePage extends StatefulWidget {
  CommentMessagePage();

  @override
  State<StatefulWidget> createState() => _CommentMessagePageState();
}

class _CommentMessagePageState extends AbstractListPageState<
    SocialMessageListViewModel, CommentMessagePage> {
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
      body: super.build(context),
    );
  }

  @override
  Widget emptyWidget(String msg) {
    return super.emptyWidget('还没有任何评论，好落寞');
  }

  @override
  SocialMessageListViewModel getModel() =>
      SocialMessageListViewModel(SocialMessageType.TYPE_COMMENT);

  @override
  Widget itemWidget(BuildContext context, int index, dynamic data) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: itemContainerDecoration,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 12),
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: ThemeColor.colorFFf25CDA1,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                '李',
                style: TextStyle(fontSize: 24, color: ThemeColor.colorFFFFFF),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('《这里是标题这里是标题这里是标题这里是标题这里题》',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('李科回复了你的评论了“这个药效很好很…', style: textStyle),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        '点赞了你的评论“超级厉害，说的很对…',
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
              child: Text('昨天', style: textStyle),
            )
          ],
        ),
      ),
    );
  }
}
