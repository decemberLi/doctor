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

import '../model/social_message_entity.dart';

class LikeMessagePage extends StatefulWidget {
  LikeMessagePage();

  @override
  State<StatefulWidget> createState() => _LikeMessagePageState();
}

class _LikeMessagePageState
    extends State<LikeMessagePage> {
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
      body:Container(
        color: ThemeColor.colorFFF3F5F8,
        child:  NormalTableView(
          padding: EdgeInsets.only(top: 10),
          itemBuilder: itemWidget,
          holder: (isError,message){
            if (isError){
              return ViewStateEmptyWidget(message: message);
            }else{
              return ViewStateEmptyWidget(message: '还没有任何赞，好落寞');
            }
          },
          getData: (page) async {
            if (page == 1){
              await _model.initData();
            }else{
              await _model.loadData(pageNum: page);
            }
            return _model.list;
          },
        ),
      ),
    );
  }


  SocialMessageListViewModel _model =
      SocialMessageListViewModel(SocialMessageType.TYPE_LIKE);


  Widget itemWidget(BuildContext context, dynamic data) {
    if (!(data is SocialMessageModel)) {
      return Container();
    }
    var content = Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
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
    return GestureDetector(
      child: content,
      onTap: (){
        onItemClicked(data);
      },
    );
  }

  void onItemClicked(itemData) {
    RouteManager.openDoctorsDetail(itemData?.postId,from: 'msg');
    _model.messageClicked(itemData?.messageId);
  }
}
