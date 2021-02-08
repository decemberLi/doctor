import 'package:doctor/pages/message/view_model/social_message_list_view_model.dart';
import 'package:doctor/pages/message/widget/redoc_logic.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/data_format_util.dart';
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
  Widget emptyWidget(String msg) {
    return super.emptyWidget('还没有任何赞，好落寞');
  }

  @override
  Widget itemWidget(BuildContext context, int index, dynamic data) {
    if (!(data is SocialMessageModel)) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: itemContainerDecoration,
      child: IntrinsicHeight(
        child: Row(
          children: [
            buildMessageItemAvatar(data as SocialMessageModel),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        data?.messageTitle ?? '',
                        style: TextStyle(
                            fontSize: 12, color: ThemeColor.colorFF444444),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        data?.messageContent ?? '',
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
              child: Text(dateFormat(data?.createTime),
                  style:
                      TextStyle(fontSize: 10, color: ThemeColor.colorFF444444)),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onItemClicked(SocialMessageListViewModel model, itemData) {
    RouteManager.openDoctorsDetail(itemData?.postId,from: 'msg');
    model?.messageClicked(itemData?.messageId);
  }
}
