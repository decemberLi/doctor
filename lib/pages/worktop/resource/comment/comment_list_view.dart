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

class ShowCommentItems extends StatefulWidget {
  final CommentListItem item;
  final onCommentClick;
  ShowCommentItems(this.item, this.onCommentClick);
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
          Container(
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
            child: Center(
              child: Text(
                roleType == 'DOCTOR' ? '医生' : '医药信息沟通专员',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

// 子回复
  Widget commentRepplyItem(CommentSecond data) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/avatar.png",
            width: 50,
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
                  margin: EdgeInsets.all(5),
                  // child: Text(data.commentContent),
                  child: GestureDetector(
                    onTap: () {
                      print('回复');
                      // Navigator.pushNamed(context, RouteManager.FIND_PWD);
                      widget.onCommentClick(
                        data.id,
                        data.parentId,
                        data.commentUserName,
                        data.commentUserType,
                      );
                    },
                    child: Text(
                      data.deleted ? '该评论已删除' : data.commentContent,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.centerRight,
                  child: Text(RelativeDateFormat.format(data.createTime)),
                ),
              ],
            ),
          ),
        ],
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
            ? [Text('')]
            : secondItem.map((e) => commentRepplyItem(e)).toList();
      }
    }

    return Container(
      child: Column(
        children: [
          //主回复
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/avatar.png",
                width: 50,
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
                    // Container(
                    //   margin: EdgeInsets.all(5),
                    //   child: Text(
                    //     widget.item.commentContent,
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          print('回复');
                          // Navigator.pushNamed(context, RouteManager.FIND_PWD);
                          widget.onCommentClick(
                            widget.item.id,
                            widget.item.id,
                            widget.item.commentUserName,
                            widget.item.commentUserType,
                          );
                        },
                        child: Text(
                          widget.item.commentContent,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                          RelativeDateFormat.format(widget.item.createTime)),
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
              : Text(''),
          Divider(
            height: 1,
          ),
        ],
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
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  onCommentClick(sonId, parent, String name, String type) {
    print('son$sonId,$parent');
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
    if (commentContent.isEmpty) {
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
      print(res);
      EasyLoading.showToast('评论发表成功');
      model.refresh();
      commentTextEdit.clear();
      commentFocusNode.unfocus();
      setState(() {
        placeholder = '请输入您的问题或评价';
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
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: model.list.length,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 60),
                        itemBuilder: (context, index) {
                          CommentListItem item = model.list[index];
                          return ShowCommentItems(item, onCommentClick);
                        },
                      ),
                    ],
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
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                hintText: placeholder,
                suffix: GestureDetector(
                  onTap: () {
                    print('发表评论');
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
