import 'dart:async';

import 'package:doctor/http/foundation.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/resource/comment/bottom_bar.dart';
import 'package:doctor/pages/worktop/resource/comment/comment_list_view.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/pages/worktop/resource/view_model/resource_view_model.dart';
import 'package:doctor/pages/worktop/resource/widgets/article.dart';
import 'package:doctor/pages/worktop/resource/widgets/attachment.dart';
import 'package:doctor/pages/worktop/resource/widgets/questionPage.dart';
import 'package:doctor/pages/worktop/resource/widgets/video.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/myIcons.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/adapt.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http_manager/manager.dart';

import 'comment/input_bar.dart';

class ResourceDetailPage extends StatefulWidget {
  final learnPlanId;
  final resourceId;
  final favoriteId; //收藏id
  final taskTemplate; //类型
  final meetingStartTime;
  final meetingEndTime;
  final taskDetailId;
  final from;

  ResourceDetailPage(
      this.learnPlanId,
      this.resourceId,
      this.favoriteId,
      this.taskTemplate,
      this.meetingStartTime,
      this.meetingEndTime,
      this.taskDetailId,
      this.from);

  @override
  _ResourceDetailPageState createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage>
    with WidgetsBindingObserver {
  bool logo = true;
  bool _startIcon = false;
  int msgCount = 5;
  String _feedbackContent;
  Timer _timer;
  String commentContent = '';
  FocusNode commentFocusNode = FocusNode();
  FocusNode feedbackFocusNode = FocusNode();
  TextEditingController commentTextEdit = TextEditingController();
  int _learnTime = 0;
  bool showFeedback = false; //是否展示遮罩层
  List _feedbackData = []; //反馈数据
  bool needFeedback = true; //是否需要遮罩层
  bool successFeedback = false; //反馈成功状态
  bool _addFeedback = false; //撰写评论
  String feedbackType;
  bool isKeyboardActived = false; //当前键盘是否激活
  int backfocus = 0; //点击返回按钮状态，第二次点击直接返回
  KeyboardVisibilityController subscribeId;

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
      return VideoDetail(data, openTimer, closeTimer, widget.meetingStartTime,
          widget.meetingEndTime, widget.taskDetailId, widget.learnPlanId);
    }
    if (data.contentType == 'ATTACHMENT') {
      return AttacementWidget(data, openTimer, closeTimer, _clickWebView);
    }
    if (data.resourceType == 'QUESTIONNAIRE') {
      return QuestionPage(data);
    }
    return Container();
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
          isKeyboardActived = false;
        }
        // isKeyboardActived = false;
      });
    }
    WidgetsBinding.instance.addObserver(this); //添加观察者
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.from == 'MESSAGE_CENTER') {
        _showCommentWidget();
      }
    });
    //监听键盘高度变化
    subscribeId = KeyboardVisibilityController()
        ..onChange.listen(
      (visible) {
        if (!visible) {
          //键盘下降失去焦点
          commentFocusNode.unfocus();
        }
      },
    );
    super.initState();
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
    API.shared.server.getCommentNum({'resourceId': resourceId}).then((res) {
      setState(() {
        msgCount = res;
      });
    });
  }

  // 获取收藏状态
  void _getCollect(resourceId) async {
    API.shared.server.getFavoriteStatus(
        {'bizId': resourceId, 'bizType': 'RESOURCE'}).then((res) {
      setState(() {
        _startIcon = res['exists'];
      });
    });
  }

  @override
  void dispose() {
    InputBarHelper.reset();
    super.dispose();

    commentFocusNode.dispose();
    feedbackFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this); //卸载观察者
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    // if (_learnTime > 0 && widget.learnPlanId != null) {
    //   //上传时间
    //   //time传当前学习了多少s 后台做累加用
    //   updateLearnTime({
    //     'resourceId': widget.resourceId,
    //     'learnPlanId': widget.learnPlanId,
    //     'time': _learnTime
    //   });
    // }
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
    //文章阅读进入页面直接触发定时器
    if (_timer == null && needReport && data.contentType == 'RICH_TEXT') {
      startCountTimer();
    }
    //视频观看需点击视频观看按钮触发定时器
    return Positioned(
      top: 24,
      right: 0,
      child: Container(
        width: 50,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        height: 35,
        decoration: BoxDecoration(
          color: ThemeColor.primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //阅读时间大于需学习时间显示
            learnedTime + _learnTime >= data.needLearnTime
                ? Icon(
                    Icons.done,
                    size: 20,
                    color: Colors.white,
                  )
                :
                // 定时器时间变化 文章为已浏览 视频为已观看
                Text(
                    '${learnedTime + (_learnTime ?? 0)}s',
                    style: TextStyle(color: Colors.white),
                  )
          ],
        ),
      ),
    );
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

  var _bottomBarController = BottomBarController();

  String text = '';

  //下方评论
  Widget commentBottom(data) {
    if (data.resourceType == 'QUESTIONNAIRE' ||
        widget.taskTemplate == 'DOCTOR_LECTURE') {
      return Container();
    }
    var bottomBar = Container(
      color: Colors.white,
      constraints: BoxConstraints(
        minHeight: 40,
      ),
      child: BottomBarWidget(
        isShowLikeBtn: false,
        hintText: '请输入您的问题或评论',
        text: text,
        controller: _bottomBarController,
        commentCallback: () {
          _showCommentWidget();
        },
        inputCallback: () async {
          String cacheContent = await InputBarHelper.showInputBar(
              context, '请输入您的问题或评论', null, null, null, (msg) {
            commentContent = msg;
            sendCommentInfo();
            InputBarHelper.reset();
            return true;
          });
          setState(() {
            _bottomBarController.text = cacheContent;
          });
        },
        collectCallback: () {
          API.shared.server.setFavoriteStatus({
            'favoriteStatus': _startIcon ? 'CANCEL' : 'ADD',
            'resourceId': widget.resourceId,
          }).then((res) {
            EasyLoading.showToast(_startIcon ? '取消收藏成功' : '收藏成功');
            setState(() {
              _startIcon = !_startIcon;
            });
          });
        },
      ),
    );
    _bottomBarController.commentCount = msgCount;
    _bottomBarController.isFavorite = _startIcon;
    _bottomBarController.hintText = '请输入您的问题或评论';

    return bottomBar;
  }

  Future _showCommentWidget() {
    return CommonModal.showBottomSheet(context,
        title: '评论区',
        contentPadding: EdgeInsets.all(0),
        height: Adapt.screenH() * 0.8,
        enableDrag: false,
        child: CommentListPage(
            widget.resourceId, widget.learnPlanId, _bottomBarController));
  }

  //发送反馈
  void sendFeedback(content, {String level = 'other'}) {
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
    dynamic params;
    if (_learnTime > 0 && widget.learnPlanId != null) {
      //上传时间
      //time传当前学习了多少s 后台做累加用
      params = {
        'resourceId': widget.resourceId,
        'learnPlanId': widget.learnPlanId,
        'time': _learnTime
      };
    }
    //需提交代码
    if (content != null) {
      API.shared.server.feedbackService({
        'learnPlanId': widget.learnPlanId,
        'resourceId': widget.resourceId,
        'feedback': content,
        'level': level
      }).then((res) {
        setState(() {
          successFeedback = true;
          _feedbackData = [];
          _addFeedback = false;
        });
        //2秒后返回
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context, params);
        });
      });
    } else {
      EasyLoading.showToast('反馈不能为空');
    }
  }

  //反馈弹窗
  Widget feedbackWidget(ResourceModel data) {
    String resourceType = data.resourceType;
    dynamic params;
    if (_learnTime > 0 && widget.learnPlanId != null) {
      //上传时间
      //time传当前学习了多少s 后台做累加用
      params = {
        'resourceId': widget.resourceId,
        'learnPlanId': widget.learnPlanId,
        'time': _learnTime
      };
    }
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          if (feedbackFocusNode.hasFocus) {
            feedbackFocusNode.unfocus();
          } else {
            Navigator.pop(context, params);
          }
          //
          //点击屏幕不反馈直接返回
        },
        child: Container(
          child: Stack(
            clipBehavior: Clip.none, children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: Adapt.screenH() * 0.4,
                child: Container(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          successFeedback
                              ? '您的反馈已收到'
                              : '您认为本${resourceType == 'VIDEO' ? '段视频' : '篇文章'}有用吗',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // 反馈成功
                      if (successFeedback)
                        Container(
                          margin: EdgeInsets.only(top: 59),
                          child: Image.asset(
                            'assets/images/feedback.png',
                            width: 88,
                            height: 88,
                          ),
                        ),
                      if (_feedbackData.length > 0)
                        ..._feedbackData.map((item) {
                          return GestureDetector(
                            onTap: () {
                              sendFeedback(item['content'],
                                  level: item['level']);
                            },
                            child: Stack(
                              clipBehavior: Clip.none, children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  margin: EdgeInsets.only(top: 26),
                                  constraints: BoxConstraints(
                                    minWidth: 100,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // borderRadius:
                                    // BorderRadius.all(Radius.circular(15)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['content'],
                                        style: TextStyle(
                                            color: Color(0xff444444),
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: item['index'] == 0 ? -10 : -8,
                                  top: item['index'] == 0 ? 20 : 22,
                                  child: Icon(
                                    item['icon'],
                                    size: 35,
                                    color: Color(0xFF51BEFF),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      if (_feedbackData.length > 0)
                        Container(
                          child: Stack(
                            clipBehavior: Clip.none, children: [
                              Container(
                                margin: EdgeInsets.only(top: 26),
                                width: 140,
                                height: 33,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "撰写评价",
                                        style: TextStyle(
                                            color: Color(0xff444444),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        _addFeedback
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        // size: 40,
                                        color: Color(0xFF000000),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              //添加评论
              if (_addFeedback)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).viewInsets.bottom
                      : Adapt.screenH() * 0.25,
                  child: Column(
                    children: [
                      TextField(
                        focusNode: feedbackFocusNode,
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
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: '请输入您对素材的评价',
                        ),
                      ),
                    ],
                  ),
                ),
              if (_addFeedback)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: Adapt.screenH() * 0.20,
                  child: FloatingActionButton.extended(
                    backgroundColor: ThemeColor.primaryColor,
                    onPressed: () {
                      // Respond to button press
                      sendFeedback(_feedbackContent);
                    },
                    label: Text(
                      '发表评价',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xC0000000),
          ),
        ),
      ),
    );
  }

  // 评论 没有learnPlanId则默认展示为收藏列表进入的详情页
  Widget comContent(data) {
    return (Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).viewInsets.bottom > 0 && !showFeedback
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
                  API.shared.server.setFavoriteStatus({
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
    ));
  }

  void setFeedback() {
    //获取反馈信息初始化
    setState(() {
      showFeedback = true;
    });
    API.shared.foundation
        .getFeedbackInfo({'businessArea': 'ACADEMIC_PROMOTION'}).then((res) {
      setState(() {
        var list = res as List<dynamic>;
        _feedbackData = list.asMap().entries.map((enty) {
          var value = enty.value;
          value['index'] = enty.key;
          return value;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var content = WillPopScope(
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
                widget.learnPlanId != null &&
                data.learnTime + _learnTime > 0 &&
                data.feedback == null;

            return Container(
                // color: ThemeColor.colorFFF3F5F8,
                color: data.resourceType == 'VIDEO'
                    ? Color.fromRGBO(0, 0, 0, 1)
                    : ThemeColor.colorFFF3F5F8,
                child: Stack(
                  // overflow: Overflow.visible,
                  children: [
                    GestureDetector(
                      onTap: () {
                        commentFocusNode.unfocus();
                        isKeyboardActived = false;
                        setState(() {
                          logo = true;
                        });
                      },
                      child: resourceRender(data),
                    ),

                    // 评论
                    if (data != null) comContent(data),
                    // 计时器
                    if (widget.learnPlanId != null) timerContent(data),
                    //反馈
                    if (needFeedback && showFeedback) feedbackWidget(data),
                  ],
                ));
          },
        ),
      ),
      onWillPop: () {
        dynamic params;
        if (_learnTime > 0 && widget.learnPlanId != null) {
          //上传时间
          //time传当前学习了多少s 后台做累加用
          params = {
            'resourceId': widget.resourceId,
            'learnPlanId': widget.learnPlanId,
            'time': _learnTime
          };
        }
        if (backfocus == 1) {
          //第二次点击返回直接退出页面
          Navigator.pop(context, params);
        } else {
          backfocus = backfocus + 1;
        }
        if (_timer != null) {
          _timer.cancel();
        }
        if (needFeedback && !showFeedback) {
          setFeedback();
        }
        if (!needFeedback) {
          Navigator.pop(context, params);
        }
        return;
      },
    );
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: content,
      ),
    );
  }
}
