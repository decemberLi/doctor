import 'package:doctor/main.dart';
import 'package:doctor/pages/message/message_promotion_list.dart';
import 'package:doctor/pages/message/view_model/message_center_view_model.dart';
import 'package:doctor/pages/message/widget/like_message_list_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common_style.dart';
import 'message_list_page.dart';
import 'widget/comment_message_list_widget.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with RouteAware {
  MessageCenterViewModel _model = MessageCenterViewModel();

  @override
  void dispose() {
    print('work_top_dispose');
    _model.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPopNext() async {
    MessageCenterViewModel model =
        Provider.of<MessageCenterViewModel>(context, listen: false);
    await model.initData();
    super.didPopNext();
  }

  Widget messageItem(
      String lable, String img, int msgCount, callBack, int index,
      {Color dotColor = Colors.red}) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
          decoration: index == 4
              ? BoxDecoration()
              : BoxDecoration(
                  border: Border(
                    bottom: Divider.createBorderSide(context,
                        color: ThemeColor.colorFFF3F5F8),
                  ),
                ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 11),
                child: Image.asset(
                  img,
                  width: 24,
                  height: 24,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                height: 48,
                child: Text(
                  lable,
                  style: fontStyle,
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: ThemeColor.colorFFBCBCBC,
                    ),
                    Positioned(
                      left: -20,
                      top: 4,
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: dotColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        constraints: BoxConstraints(
                          minWidth: 24,
                          minHeight: 16,
                        ),
                        child: Center(
                            child: Text(
                          msgCount > 99 ? '99+' : '$msgCount',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
        onTap: () {
          callBack();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('消息中心'),
        elevation: 0,
      ),
      body: Consumer<MessageCenterViewModel>(
        builder: (context, model, child) {
          var systemCount = model?.data?.systemCount ?? 0;
          var leanPlanCount = model?.data?.leanPlanCount ?? 0;
          var prescriptionCount = model?.data?.prescriptionCount ?? 0;
          var interactiveCount = model?.data?.interactiveCount ?? 0;
          var likeCount = model?.data?.likeCount ?? 0;
          var commentCount = model?.data?.commentCount ?? 0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildInteractionMessageWidget(likeCount, commentCount),
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      messageItem('系统通知', 'assets/images/msg_system_notice.png',
                          systemCount, () {
                        goMessageList(MessageType.TYPE_SYSTEM);
                      }, 1, dotColor: _dotColor(systemCount)),
                      messageItem('学术推广', 'assets/images/msg_learn_plan.png',
                          leanPlanCount, () {
                        goStudyPlane();
                      }, 2,
                          dotColor:
                              _dotColor(leanPlanCount + interactiveCount)),
                      messageItem('患者处方', 'assets/images/msg_patient.png',
                          prescriptionCount, () {
                        goMessageList(MessageType.TYPE_PRESCRIPTION);
                      }, 3, dotColor: _dotColor(prescriptionCount)),
                      // messageItem('互动消息', 'assets/images/msg_interact.png',
                      //     interactiveCount, () {
                      //   goMessageList(MessageType.TYPE_INTERACTIVE);
                      // }, 4, dotColor: _dotColor(interactiveCount)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _dotColor(int count) {
    return (count ?? 0) == 0 ? Colors.transparent : ThemeColor.colorFFF57575;
  }

  goMessageList(String type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageListPage(type)),
    );
    _model.initData();
  }

  goStudyPlane() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MessagePromotionList()));
  }

  _buildMessageIcon({
    String assetPath,
    String label,
    int unreadMsg,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              child: Image.asset(assetPath, width: 40, height: 40),
            ),
            if (unreadMsg != null)
              Positioned(
                right: -17,
                top: -10,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  padding: EdgeInsets.all(1.5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: _dotColor(unreadMsg),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    constraints: BoxConstraints(minWidth: 29, minHeight: 16),
                    child: Center(
                        child: Text(
                      unreadMsg > 99 ? '99+' : '$unreadMsg',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                ),
              )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: ThemeColor.colorFF222222),
          ),
        )
      ],
    );
  }

  _buildInteractionMessageWidget(int likeCount, int commentCount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 76),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: _buildMessageIcon(
                assetPath: 'assets/images/icon_like.png',
                label: '点赞',
                unreadMsg: likeCount),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LikeMessagePage())),
          ),
          GestureDetector(
            child: _buildMessageIcon(
                assetPath: 'assets/images/icon_comment.png',
                label: '评论',
                unreadMsg: commentCount),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CommentMessagePage())),
          ),
        ],
      ),
    );
  }
}
