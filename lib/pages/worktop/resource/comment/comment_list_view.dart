import 'dart:async';

import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/resource/model/comment_list_model.dart';
import 'package:doctor/pages/worktop/resource/view_model/comment_view_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/root_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/time_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'bottom_bar.dart';
import 'input_bar.dart';

class ShowCommentItems extends StatefulWidget {
  final CommentListItem item;
  final onCommentClick;
  final controller;
  final index;

  ShowCommentItems(this.item, this.onCommentClick, this.controller, this.index);

  @override
  _ShowCommentItemsState createState() => _ShowCommentItemsState();
}

class _ShowCommentItemsState extends State<ShowCommentItems> {
  bool showAllReply = false;

  //姓名和角色
  Widget replyItem(String name, String roleType) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text(name),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              // height: 20,
              constraints: BoxConstraints(
                minWidth: 30,
              ),
              decoration: BoxDecoration(
                color: ThemeColor.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Text(
                roleType == 'DOCTOR' ? '医生' : '医药信息沟通专员',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14), //居中
              ),
            ),
          )
        ],
      ),
    );
  }

// 子回复
  Widget commentReplyItem(CommentSecond data) {
    print(
      data.commentUserType,
    );
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, RouteManager.FIND_PWD);
        widget.onCommentClick(
          data.id,
          data.parentId,
          data.commentUserName,
          data.commentContent,
          data.commentUserType,
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.commentUserType == 'DOCTOR'
                ? Image.asset(
                    "assets/images/doctor.png",
                    width: 40,
                  )
                : Image.asset(
                    "assets/images/present.png",
                    width: 40,
                  ),
            // Image.network(
            //   'https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg',
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      replyItem(data.commentUserName, data.commentUserType),
                      // if (data.respondentContent == null ||
                      //     data.respondentContent == '')
                      //   Text('回复'),
                      // if (data.respondentContent == null ||
                      //     data.respondentContent == '')
                      //   replyItem(data.respondent, data.respondentUserType),
                    ],
                  ),
                  if (data.respondentContent != null &&
                      data.respondentContent != '')
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Color(0xFFF6F6F6),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Text(
                        '回复 ${data.respondent}：${data.respondentContent}',
                        style: TextStyle(
                            fontSize: 12, color: ThemeColor.colorFF999999),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Text(
                      data.deleted ? '该评论已删除' : data.commentContent,
                      style: TextStyle(color: Color(0xff0b0b0b)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    alignment: Alignment.centerRight,
                    child: Text(
                      RelativeDateFormat.format(data.createTime),
                      style: TextStyle(
                        color: Color(0XFF2222222),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List secondItem = widget.item.secondLevelCommentList;
    int secondLength = secondItem == null ? 0 : secondItem.length;
    List<Widget> applyContentByLength() {
      if (secondLength > 2 && !showAllReply) {
        return secondItem
            .getRange(0, 2)
            .map((e) => commentReplyItem(e))
            .toList();
      } else {
        return secondLength == 0
            ? [Container()]
            : secondItem.map((e) => commentReplyItem(e)).toList();
      }
    }

    return AutoScrollTag(
      key: ValueKey(widget.index),
      controller: widget.controller,
      index: widget.index,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, RouteManager.FIND_PWD);
            widget.onCommentClick(
              widget.item.id,
              widget.item.id,
              widget.item.commentUserName,
              widget.item.commentContent,
              widget.item.commentUserType,
            );
          },
          child: Column(
            children: [
              //主回复
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.item.commentUserType == 'DOCTOR'
                      ? Image.asset(
                          "assets/images/doctor.png",
                          width: 40,
                        )
                      : Image.asset(
                          "assets/images/present.png",
                          width: 40,
                        ),
                  // Image.network(
                  //   'https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg',
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        replyItem(widget.item.commentUserName,
                            widget.item.commentUserType),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Text(
                            widget.item.commentContent,
                            style: TextStyle(
                              color: Color(0XFF0B0B0B),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          alignment: Alignment.centerRight,
                          child: Text(
                            RelativeDateFormat.format(widget.item.createTime),
                            style: TextStyle(
                              color: Color(0XFF222222),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // 子回复
              ...applyContentByLength(),
              secondLength > 2
                  ? GestureDetector(
                      onTap: () {
                        //滚动到当前评论
                        widget.controller.scrollToIndex(widget.index,
                            preferPosition: AutoScrollPosition.begin);
                        setState(() {
                          showAllReply = !showAllReply;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          showAllReply ? '收起' : '查看全部${secondItem.length}条回复>',
                          style: TextStyle(color: ThemeColor.primaryColor),
                        ),
                      ))
                  : Container(),
              Divider(
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 评论列表
class CommentListPage extends StatefulWidget {
  final int resourceId;
  final int learnPlanId;
  final BottomBarController bottomBarController;

  CommentListPage(this.resourceId, this.learnPlanId, this.bottomBarController);

  @override
  _CommentListPageState createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage>
    with AutomaticKeepAliveClientMixin {
  // 保持不被销毁
  final scrollDirection = Axis.vertical;
  int subscribeId;
  AutoScrollController controller;
  CommentListViewModel model;
  var text = '';

  @override
  bool get wantKeepAlive => true;

  String placeholder = '请输入您的问题或评论';
  FocusNode commentFocusNode = FocusNode();
  TextEditingController commentTextEdit = TextEditingController();
  String commentContent = ''; //评论内容
  int parentId = 0; //顶级id
  int commentId = 0; //回复id
  @override
  void initState() {
    //初始化数据
    model = CommentListViewModel(widget.resourceId, widget.learnPlanId);
    model.initData();
    //监听键盘高度变化
    subscribeId = KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          //键盘下降失去焦点
          commentFocusNode.unfocus();
        }
      },
    );
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  @override
  void dispose() {
    model.dispose();
    KeyboardVisibilityNotification().removeListener(subscribeId);
    super.dispose();
  }

  onCommentClick(
      sonId, parent, String name, String commentContent, String type) {
    if (sonId != commentId) {
      commentTextEdit.clear();
    }

    eventBus.fire('cleanHintText');
    InputBarHelper.showInputBar(
        context, '请输入您的问题或评论', name, '$sonId', commentContent, (msg) {
      this.commentContent = msg;
      sendCommentInfo();
      InputBarHelper.reset();
      return true;
    });

    String tips = '正在回复$name ${type == 'DOCTOR' ? '医生' : ''}';
    setState(() {
      parentId = parent;
      commentId = sonId;
      placeholder = tips;
    });
  }

  //发送消息
  sendCommentInfo() {
    if (commentContent.isEmpty || commentContent.trim().isEmpty) {
      EasyLoading.showToast('请输入评论内容');
      return;
    }
    if (commentContent.length > 150) {
      EasyLoading.showToast('评论字数超过限制');
      return;
    }
    API.shared.server.sendComment({
      'resourceId': widget.resourceId,
      'learnPlanId': widget.learnPlanId,
      'commentContent': commentContent,
      'parentId': parentId,
      'commentId': commentId
    }).then((res) {
      commentTextEdit.clear();
      commentFocusNode.unfocus();
      setState(() {
        placeholder = '请输入您的问题或评论';
        commentContent = '';
      });
      model.refresh();
      Timer(Duration(seconds: 1), () {
        EasyLoading.showToast('评论发表成功');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var content = Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 26, right: 26, bottom: 50),
          child: GestureDetector(
            onDoubleTap: () {
              //双击初始化弹窗
              commentTextEdit.clear();
              commentFocusNode.unfocus();
              setState(() {
                parentId = 0;
                commentId = 0;
                placeholder = '请输入您的问题或评论';
                commentContent = '';
              });
            },
            child: ChangeNotifierProvider<CommentListViewModel>.value(
              value: model,
              child: Consumer<CommentListViewModel>(
                builder: (context, model, child) {
                  if (model.isError || model.isEmpty) {
                    return ViewStateEmptyWidget(onPressed: model.initData);
                  }
                  if (model.isEmpty) {
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
                      scrollDirection: scrollDirection,
                      controller: controller,
                      itemCount: model.list.length,
                      itemBuilder: (context, index) {
                        CommentListItem item = model.list[index];
                        return ShowCommentItems(
                          item,
                          onCommentClick,
                          controller,
                          index,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: BottomBarWidget(
            isShowLikeBtn: false,
            isShowCommentBtn: false,
            isShowCollectBtn: false,
            hintText: '请输入您的问题或评论',
            text: text,
            controller: widget.bottomBarController,
            inputCallback: () async {
              String cacheContent = await InputBarHelper.showInputBar(
                  context, '请输入您的问题或评论', null, null, null, (msg) {
                commentContent = msg;
                sendCommentInfo();
                InputBarHelper.reset();
                return true;
              });
              setState(() {
                widget.bottomBarController.text = cacheContent;
              });
            },
          ),
        )
      ],
    );
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: content,
      ),
    );
  }
}
