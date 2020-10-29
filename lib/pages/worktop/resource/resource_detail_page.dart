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

import '../service.dart';
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
  String _feedbackContent;
  Timer _timer;
  String commentContent;
  FocusNode commentFocusNode = FocusNode();
  TextEditingController commentTextEdit = TextEditingController();
  int _learnTime = 0;
  bool showFeedback = false; //是否展示遮罩层
  List _feedbackData = []; //反馈数据
  bool needFeedback = true; //是否需要遮罩层
  bool successFeedback = false; //反馈成功状态
  bool _addFeedback = false; //撰写评论
  String feedbackType;

  Widget resourceRender(ResourceModel data) {
    void openTimer() {
      //需要记录浏览时间
      bool needReport = data.learnPlanStatus != 'SUBMIT_LEARN' &&
          data.learnPlanStatus != 'ACCEPTED' &&
          widget.learnPlanId != null;
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
    if (widget.learnPlanId != null) {
      commentFocusNode.unfocus();
      setState(() {
        logo = true;
      });
    }
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
    if (commentFocusNode != null) {
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
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    commentFocusNode.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    if (_learnTime > 0 && widget.learnPlanId != null) {
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
      return Container();
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
      commentTextEdit.clear();
      commentFocusNode.unfocus();
      setState(() {
        logo = true;
        commentContent = '';
      });
      _getComments(widget.resourceId);
      Timer(Duration(seconds: 1), () {
        EasyLoading.showToast('评论发表成功');
      });
    });
  }

  //下方评论
  Widget commentBottom(data) {
    if (data.resourceType == 'QUESTIONNAIRE' ||
        widget.taskTemplate == 'DOCTOR_LECTURE') {
      return Container();
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
                          : Container(),
                    ],
                  ))
              : Container(),
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
              : Container()
        ],
      ),
    );
  }

  //发送反馈
  void sendFeedback(content) {
    // print('conten$content');
    //上传反馈 测试使用
    // setState(() {
    //   successFeedback = true;
    //   _feedbackData = [];
    //   _addFeedback = false;
    // });
    // //2秒后返回 测试使用
    // Timer(Duration(seconds: 2), () {
    //   Navigator.pop(context);
    // });
    //需提交代码
    if (content != null) {
      feedbackService({
        'learnPlanId': widget.learnPlanId,
        'resourceId': widget.resourceId,
        'feedback': content
      }).then((res) {
        setState(() {
          successFeedback = true;
          _feedbackData = [];
          _addFeedback = false;
        });
        //2秒后返回
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      });
    } else {
      EasyLoading.showToast('反馈不能为空');
    }
  }

  //反馈弹窗
  Widget feedbackWidget(ResourceModel data) {
    String resourceType = data.resourceType;
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context); //点击屏幕不反馈直接返回
        },
        child: Container(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              Container(
                height: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      successFeedback
                          ? '您的反馈已收到,非常感谢！'
                          : '您认为本${resourceType == 'VIDEO' ? '段视频' : '篇文章'}有用吗?',
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                    // 反馈成功
                    if (successFeedback)
                      Icon(
                        Icons.favorite,
                        size: 80,
                        color: Colors.red,
                      ),
                    if (_feedbackData.length > 0)
                      ..._feedbackData.map((item) {
                        return GestureDetector(
                          onTap: () {
                            sendFeedback(item['content']);
                          },
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                height: 30,
                                padding: EdgeInsets.only(left: 33, right: 10),
                                margin: EdgeInsets.all(20),
                                constraints: BoxConstraints(
                                  minWidth: 100,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // borderRadius:
                                  // BorderRadius.all(Radius.circular(15)),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        item['content'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 9,
                                top: 12,
                                child: Icon(
                                  item['icon'],
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    if (_feedbackData.length > 0)
                      Container(
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            Container(
                              width: 150,
                              height: 30,
                              child: RaisedButton(
                                padding: EdgeInsets.only(left: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30 / 2),
                                  ),
                                ),
                                color: Colors.white,
                                textColor: ThemeColor.primaryColor,
                                onPressed: () {
                                  // Respond to button press
                                  setState(() {
                                    _addFeedback = !_addFeedback;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("撰写评价"),
                                    Icon(
                                      _addFeedback
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      // size: 40,
                                      color: ThemeColor.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: -5,
                              top: -4,
                              child: Icon(
                                MyIcons.icon_pinglun,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              //添加评论
              if (_addFeedback)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).viewInsets.bottom - 110
                      : 110,
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.text,
                        minLines: 3,
                        maxLines: 10,
                        maxLength: 200,
                        onChanged: (text) {
                          setState(() {
                            _feedbackContent = text;
                          });
                        },
                        autofocus: false,
                        // BoxDecoration(
                        //     border: Border.all(color: Colors.white)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          hintText: '请输入评价',
                        ),
                      ),
                    ],
                  ),
                ),
              if (_addFeedback)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 55,
                  child: FloatingActionButton.extended(
                    backgroundColor: ThemeColor.primaryColor,
                    onPressed: () {
                      // Respond to button press
                      sendFeedback(_feedbackContent);
                    },
                    icon: Icon(Icons.send),
                    label: Text('发送评价'),
                  ),
                ),
            ],
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0x40000000),
          ),
        ),
      ),
    );
  }

  void setFeedback() {
    //获取反馈信息初始化
    setState(() {
      showFeedback = true;
    });
    getFeedbackInfo({'businessArea': 'ACADEMIC_PROMOTION'}).then((res) {
      setState(() {
        _feedbackData = [
          {'content': res['perfectList'][0], 'icon': MyIcons.icon_dianzan},
          {'content': res['goodList'][0], 'icon': MyIcons.icon_xiaolian},
          {'content': res['middleList'][0], 'icon': MyIcons.icon_kulian}
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
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
              //根据状态决定是否需要反馈
              needFeedback = data.learnPlanStatus != 'SUBMIT_LEARN' &&
                  data.learnPlanStatus != 'ACCEPTED' &&
                  data.resourceType != 'QUESTIONNAIRE' &&
                  widget.taskTemplate != 'DOCTOR_LECTURE' &&
                  data.learnTime + _learnTime > 0 &&
                  data.feedback == null &&
                  widget.learnPlanId != null;
              return Container(
                color: ThemeColor.colorFFF3F5F8,
                child: Stack(
                  // overflow: Overflow.visible,
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
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0 &&
                              !showFeedback
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
                                  size: 30,
                                ),
                              ),
                            ),
                    ),
                    // 计时器
                    if (widget.learnPlanId != null) timerContent(data),
                    //反馈
                    if (needFeedback && showFeedback) feedbackWidget(data),
                  ],
                ),
              );
            },
          ),
        ),
        onWillPop: () {
          if (_timer != null) {
            _timer.cancel();
          }
          if (needFeedback && !showFeedback) {
            setFeedback();
          }
          if (!needFeedback) {
            Navigator.pop(context);
          }
          return;
        });
  }
}
