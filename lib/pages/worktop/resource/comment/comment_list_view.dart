import 'dart:async';

import 'package:doctor/pages/worktop/resource/comment/service.dart';
import 'package:doctor/pages/worktop/resource/model/comment_list_model.dart';
import 'package:doctor/pages/worktop/resource/view_model/comment_view_model.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/utils/time_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:doctor/theme/theme.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  Widget repplyItem(String name, String roleType) {
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
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 20,
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
                style: TextStyle(
                    color: Colors.white, fontSize: 14, height: 1.4), //居中
              ),
            ),
          )
        ],
      ),
    );
  }

// 子回复
  Widget commentRepplyItem(CommentSecond data) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, RouteManager.FIND_PWD);
        widget.onCommentClick(
          data.id,
          data.parentId,
          data.commentUserName,
          data.commentUserType,
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/avatar.png",
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
                      repplyItem(data.commentUserName, data.commentUserType),
                      Text('回复'),
                      repplyItem(data.respondent, data.respondentUserType),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Text(
                      data.deleted ? '该评论已删除' : data.commentContent,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    alignment: Alignment.centerRight,
                    child: Text(RelativeDateFormat.format(data.createTime)),
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
            .map((e) => commentRepplyItem(e))
            .toList();
      } else {
        return secondLength == 0
            ? [Container()]
            : secondItem.map((e) => commentRepplyItem(e)).toList();
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
              widget.item.commentUserType,
            );
          },
          child: Column(
            children: [
              //主回复
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/avatar.png",
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
                        repplyItem(widget.item.commentUserName,
                            widget.item.commentUserType),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.item.commentContent,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.centerRight,
                          child: Text(RelativeDateFormat.format(
                              widget.item.createTime)),
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

  CommentListPage(this.resourceId, this.learnPlanId);

  @override
  _CommentListPageState createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage>
    with AutomaticKeepAliveClientMixin {
  // 保持不被销毁
  final scrollDirection = Axis.vertical;

  AutoScrollController controller;
  CommentListViewModel model;

  @override
  bool get wantKeepAlive => true;

  String placeholder = '请输入您的问题或评价';
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
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  onCommentClick(sonId, parent, String name, String type) {
    if (sonId != commentId) {
      commentTextEdit.clear();
    }
    commentFocusNode.requestFocus(); //设置焦点
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
    sendComment({
      'resourceId': widget.resourceId,
      'learnPlanId': widget.learnPlanId,
      'commentContent': commentContent,
      'parentId': parentId,
      'commentId': commentId
    }).then((res) {
      commentTextEdit.clear();
      commentFocusNode.unfocus();
      setState(() {
        placeholder = '请输入您的问题或评价';
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
    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
            //双击初始化弹窗
            commentTextEdit.clear();
            commentFocusNode.unfocus();
            setState(() {
              parentId = 0;
              commentId = 0;
              placeholder = '请输入您的问题或评价';
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
                          item, onCommentClick, controller, index);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom > 0
              ? MediaQuery.of(context).viewInsets.bottom
              : 10,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  commentContent = text;
                });
              },
              controller: commentTextEdit,
              focusNode: commentFocusNode,
              minLines: 1,
              maxLines: 10,
              autofocus: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                hintText: placeholder,
                suffix: GestureDetector(
                  onTap: () {
                    sendCommentInfo();
                  },
                  child: Text(
                    '发表',
                    style:
                        TextStyle(color: ThemeColor.primaryColor, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
