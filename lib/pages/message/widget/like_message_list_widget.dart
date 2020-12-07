import 'package:doctor/pages/message/view_model/social_message_list_view_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/common_widget_style.dart';
import 'package:doctor/widgets/refreshable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/social_message_entity.dart';

class LikeMessagePage extends StatefulWidget {
  LikeMessagePage();

  @override
  State<StatefulWidget> createState() => _LikeMessagePageState();
}

class _LikeMessagePageState
    extends AbstractListPageState<SocialMessageListViewModel, LikeMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '收到的赞',
          style: TextStyle(fontSize: 17, color: ThemeColor.colorFF000000),
        ),
      ),
      body: super.build(context),
    );
  }

  @override
  SocialMessageListViewModel getModel() =>
      SocialMessageListViewModel(SocialMessageType.TYPE_LIKE);

  @override
  Widget itemWidget(BuildContext context, int index, dynamic data) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: itemContainerDecoration,
      child: IntrinsicHeight(
        child: Row(
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
                    Container(
                      child: Text(
                        '李科',
                        style: TextStyle(
                            fontSize: 12, color: ThemeColor.colorFF444444),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        '点赞了你的评论“超级厉害，说的很对…',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, color: ThemeColor.colorFF000000),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              padding: EdgeInsets.only(left: 8),
              child: Text('昨天',
                  style:
                      TextStyle(fontSize: 10, color: ThemeColor.colorFF444444)),
            )
          ],
        ),
      ),
    );
  }
}
