import 'package:doctor/pages/worktop/resource/comment/comment_list_view.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/pages/worktop/resource/service.dart';
import 'package:doctor/pages/worktop/resource/view_model/resource_view_model.dart';
import 'package:doctor/pages/worktop/resource/widgets/article.dart';
import 'package:doctor/pages/worktop/resource/widgets/attachment.dart';
import 'package:doctor/pages/worktop/resource/widgets/video.dart';
import 'package:doctor/pages/worktop/resource/widgets/questionPage.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/myIcons.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'comment/service.dart';

class ResourceDetailPage extends StatefulWidget {
  final learnPlanId;
  final resourceId;
  final favoriteId;
  ResourceDetailPage(this.learnPlanId, this.resourceId, this.favoriteId);
  @override
  _ResourceDetailPageState createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  bool logo = true;
  bool _startIcon = false;
  int msgCount = 5;

  String commentContent;
  FocusNode commentFocusNode = FocusNode();
  TextEditingController commentTextEdit = TextEditingController();
  Widget resourceRender(ResourceModel data) {
    if (data.contentType == 'RICH_TEXT') {
      return Article(data);
    }
    if (data.resourceType == 'VIDEO') {
      return VideoDetail(data);
    }
    if (data.contentType == 'ATTACHMENT') {
      return Attacement(data);
    }
    if (data.resourceType == 'QUESTIONNAIRE') {
      return QuestionPage(data);
    }
    return Container();
  }

  //获取评论
  void _getComments(resourceId) async {
    getCommentNum({'resourceId': resourceId}).then((res) {
      print('mes$res');
      setState(() {
        msgCount = res;
      });
    });
  }

  // 获取收藏状态
  void _getCollect(resourceId) async {
    getFavoriteStatus({'bizId': resourceId, 'bizType': 'RESOURCE'}).then((res) {
      print('res$res');
      setState(() {
        _startIcon = res['exists'];
      });
    });
  }

  @override
  void initState() {
    if (widget.learnPlanId != null) {
      _getComments(widget.resourceId);
    }
    _getCollect(widget.resourceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // dynamic obj = ModalRoute.of(context).settings.arguments;
    // if (obj != null) {
    //   learnPlanId = obj["learnPlanId"];
    //   resourceId = obj['resourceId'];
    // }
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
        'parentId': 0,
        'commentId': 0
      }).then((res) {
        EasyLoading.showToast('评论发表成功');
        commentTextEdit.clear();
        commentFocusNode.unfocus();
        _getComments(widget.resourceId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('资料详情'),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          commentFocusNode.unfocus();
          setState(() {
            logo = true;
          });
        },
        child: ProviderWidget<ResourceDetailViewModel>(
          model: ResourceDetailViewModel(
              widget.resourceId, widget.learnPlanId, widget.favoriteId),
          onModelReady: (model) => model.initData(),
          builder: (context, model, child) {
            if (model.isBusy) {
              return Container();
            }
            if (model.isError || model.isEmpty) {
              return ViewStateEmptyWidget(onPressed: model.initData);
            }
            var data = model.data;
            return Container(
              color: ThemeColor.colorFFF3F5F8,
              child: resourceRender(data),
            );
          },
        ),
      ),
      //评论
      bottomNavigationBar: widget.learnPlanId != null
          ? BottomAppBar(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                constraints: BoxConstraints(
                  minHeight: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentTextEdit,
                        focusNode: commentFocusNode,
                        onTap: () {
                          setState(() {
                            logo = false;
                          });
                        },
                        onChanged: (text) {
                          setState(() {
                            commentContent = text;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          hintText: '请输入您的问题或评价',
                          suffix: GestureDetector(
                            onTap: () {
                              sendCommentInfo();
                            },
                            child: Text(
                              logo ? '' : '发表',
                              style: TextStyle(
                                  color: ThemeColor.primaryColor, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    logo
                        ? Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                InkWell(
                                  onTap: () {
                                    commentTextEdit.clear();
                                    // CommonModal
                                    CommonModal.showBottomSheet(context,
                                        title: '评论区',
                                        height: 660,
                                        child: CommentListPage(
                                            widget.resourceId,
                                            widget.learnPlanId));
                                  },
                                  child: Icon(
                                    MyIcons.icon_talk,
                                    size: 28,
                                  ),
                                ),
                                msgCount > 0
                                    ? Positioned(
                                        left: 18,
                                        top: -10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: ThemeColor.primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          constraints: BoxConstraints(
                                            minWidth: 20,
                                            minHeight: 20,
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
                                      )
                                    : Text(''),
                              ],
                            ))
                        : Text(''),
                    logo
                        ? Container(
                            margin: EdgeInsets.only(left: 10),
                            child: InkWell(
                              onTap: () {
                                //收藏
                                setFavoriteStatus({
                                  'favoriteStatus':
                                      _startIcon ? 'CANCEL' : 'ADD',
                                  'resourceId': widget.resourceId,
                                }).then((res) {
                                  EasyLoading.showToast(
                                      _startIcon ? '取消收藏成功' : '收藏成功');
                                  setState(() {
                                    _startIcon = !_startIcon;
                                  });
                                });
                              },
                              child: Icon(
                                _startIcon
                                    ? MyIcons.icon_star_fill
                                    : MyIcons.icon_star,
                                size: 28,
                              ),
                            ),
                          )
                        : Text('')
                  ],
                ),
              ),
            )
          : BottomAppBar(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    //收藏
                    setFavoriteStatus({
                      'favoriteStatus': _startIcon ? 'CANCEL' : 'ADD',
                      'resourceId': widget.resourceId,
                    }).then((res) {
                      EasyLoading.showToast(_startIcon ? '取消收藏成功' : '收藏成功');
                      setState(() {
                        _startIcon = !_startIcon;
                      });
                    });
                  },
                  child: Icon(
                    _startIcon ? MyIcons.icon_star_fill : MyIcons.icon_star,
                    size: 30,
                  ),
                ),
              ),
            ),
    );
  }
}
