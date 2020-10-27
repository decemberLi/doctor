import 'dart:async';
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
  final favoriteId; //收藏id
  final taskTemplate; //类型
  ResourceDetailPage(
      this.learnPlanId, this.resourceId, this.favoriteId, this.taskTemplate);
  @override
  _ResourceDetailPageState createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  bool logo = true;
  bool _startIcon = false;
  int msgCount = 5;

  Timer _timer;
  String commentContent;
  FocusNode commentFocusNode = FocusNode();
  TextEditingController commentTextEdit = TextEditingController();
  int _learnTime = 0;

  Widget resourceRender(ResourceModel data) {
    void openTimer() {
      //需要记录浏览时间
      bool needReport = data.learnPlanStatus != 'SUBMIT_LEARN' &&
          data.learnPlanStatus != 'ACCEPTED';
      if (_timer == null && needReport) {
        startCountTimer();
      }
    }

    void closeTimer() {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
    }

    if (data.contentType == 'RICH_TEXT') {
      return Article(data, _clickWebView);
    }
    if (data.resourceType == 'VIDEO') {
      return VideoDetail(data, openTimer, closeTimer);
    }
    if (data.contentType == 'ATTACHMENT') {
      return Attacement(data);
    }
    if (data.resourceType == 'QUESTIONNAIRE') {
      return QuestionPage(data);
    }
    return Container();
  }

  // 文章webview点击时触发
  void _clickWebView() {
    commentFocusNode.unfocus();
    setState(() {
      logo = true;
    });
  }

  //获取评论
  void _getComments(resourceId) async {
    getCommentNum({'resourceId': resourceId}).then((res) {
      setState(() {
        msgCount = res;
      });
    });
  }

  // 获取收藏状态
  void _getCollect(resourceId) async {
    getFavoriteStatus({'bizId': resourceId, 'bizType': 'RESOURCE'}).then((res) {
      setState(() {
        _startIcon = res['exists'];
      });
    });
  }

  @override
  void initState() {
    //收藏页面进入详情不需要取评论数量
    if (widget.learnPlanId != null) {
      _getComments(widget.resourceId);
    }
    _getCollect(widget.resourceId);
    // 输入框焦点监听事件
    commentFocusNode.addListener(() {
      if (commentFocusNode.hasFocus) {
        setState(() {
          logo = false;
        });
      } else {
        setState(() {
          logo = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    commentFocusNode.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      //反馈
    }
    if (_learnTime > 0) {
      //上传时间
      //time传当前学习了多少s 后台做累加用
      updateLearnTime({
        'resourceId': widget.resourceId,
        'learnPlanId': widget.learnPlanId,
        'time': _learnTime
      });
    }
  }

  //计时器
  void startCountTimer() {
    const timeout = const Duration(seconds: 1);
    _timer = Timer.periodic(timeout, (timer) {
      setState(() {
        _learnTime += 1;
      });
    });
  }

  // 计时展示
  Widget timerContent(data) {
    //需要记录浏览时间
    bool needReport = data.learnPlanStatus != 'SUBMIT_LEARN' &&
        data.learnPlanStatus != 'ACCEPTED';
    if (data.resourceType == 'QUESTIONNAIRE' ||
        widget.taskTemplate == 'DOCTOR_LECTURE') {
      return Text('');
    }
    int learnedTime = data.learnTime ?? 0;
    String tips = data.resourceType == 'VIDEO' ? '已观看' : '已浏览';
    //文章阅读进入页面直接触发定时器
    if (_timer == null && needReport && data.resourceType == 'ARTICLE') {
      startCountTimer();
    }
    //视频观看需点击视频观看按钮触发定时器
    return Positioned(
      top: 24,
      child: Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        height: 35,
        decoration: BoxDecoration(
          color: ThemeColor.primaryColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
        ),
        child: Row(
          children: [
            //阅读时间大于需学习时间显示
            if (learnedTime + _learnTime > data.needLearnTime)
              Icon(
                Icons.done,
                size: 20,
                color: Colors.white,
              ),
            // 定时器时间变化 文章为已浏览 视频为已观看
            Text(
              '$tips${learnedTime + (_learnTime ?? 0)}s',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
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
      'parentId': 0,
      'commentId': 0
    }).then((res) {
      EasyLoading.showToast('评论发表成功');
      commentTextEdit.clear();
      commentFocusNode.unfocus();
      setState(() {
        logo = true;
      });
      _getComments(widget.resourceId);
    });
  }

  //下方评论
  Widget commentBottom(data) {
    if (data.resourceType == 'QUESTIONNAIRE' ||
        widget.taskTemplate == 'DOCTOR_LECTURE') {
      return Text('');
    }
    return Container(
      color: Colors.white,
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
                    style:
                        TextStyle(color: ThemeColor.primaryColor, fontSize: 14),
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
                                  widget.resourceId, widget.learnPlanId));
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
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
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 10),
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
                      size: 28,
                    ),
                  ),
                )
              : Text('')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // dynamic obj = ModalRoute.of(context).settings.arguments;
    // if (obj != null) {
    //   learnPlanId = obj["learnPlanId"];
    //   resourceId = obj['resourceId'];
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('资料详情'),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: ProviderWidget<ResourceDetailViewModel>(
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
            child: Stack(
              overflow: Overflow.visible,
              children: [
                GestureDetector(
                  onTap: () {
                    commentFocusNode.unfocus();
                    setState(() {
                      logo = true;
                    });
                  },
                  child: resourceRender(data),
                ),
                // 评论 没有learnPlanId则默认展示为收藏列表进入的详情页
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0,
                  child: widget.learnPlanId != null
                      ? commentBottom(data)
                      : Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              //收藏
                              setFavoriteStatus({
                                'favoriteStatus': _startIcon ? 'CANCEL' : 'ADD',
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
                              size: 30,
                            ),
                          ),
                        ),
                ),
                // 计时器
                timerContent(data),
              ],
            ),
          );
        },
      ),
    );
  }
}
