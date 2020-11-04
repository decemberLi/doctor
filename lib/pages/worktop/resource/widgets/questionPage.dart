import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/pages/worktop/resource/service.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class QuestionPage extends StatefulWidget {
  final ResourceModel data;
  QuestionPage(this.data);
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List _questionsInit;
  final scrollDirection = Axis.vertical;
  AutoScrollController controller;

  @override
  void initState() {
    // 在initState中发出请求
    _questionsInit = _getQuestionsInit();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    super.initState();
  }

//确认弹窗
  Future<bool> confirmDialog() {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text('确认提交本调研问卷答案吗？'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            FlatButton(
              child: Text(
                "确定",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  _getQuestionsInit() {
    Iterable questionsAll = widget.data.questions;
    var questionsNew = [];
    for (var item in questionsAll) {
      if (item.type == 'RADIO') {
        // item['groupValue'] = -1;
        questionsNew.add({
          'index': item.index,
          'question': item.question,
          'type': 'RADIO',
          'groupValue': ''
        });
        if (item.options.length > 0) {
          item.options.forEach((element) {
            if (element.checked != null) {
              questionsNew[item.index]['groupValue'] = element.checked;

              return false;
            }
          });
        }
      }
      if (item.type == 'CHECKBOX') {
        // item.checked = [];
        questionsNew.add({
          'index': item.index,
          'question': item.question,
          'type': 'CHECKBOX',
          'checked': []
        });
        if (item.options.length > 0) {
          item.options.forEach((element) {
            if (element.checked != null) {
              questionsNew[item.index]['checked'].add(element.checked);
            }
          });
        }
      }
      if (item.type == 'TEXT') {
        questionsNew.add({
          'index': item.index,
          'question': item.question,
          'type': 'TEXT',
          'textField': ''
        });

        if (item.options.length > 0) {
          item.options.forEach((element) {
            if (element.checked != null) {
              questionsNew[item.index]['textField'] = (element.checked);
            }
          });
        }
      }
    }
    return questionsNew;
  }

  _openFile() async {
    // TODO: 提交问卷
    Iterable questionsAll = widget.data.questions;
    print('提交问卷:$_questionsInit');
    bool showError = false;
    for (var item in questionsAll) {
      if (item.type == 'RADIO') {
        // 单选
        _questionsInit.forEach((element) {
          if (element['index'] == item.index) {
            if ((element['groupValue']) != null &&
                (element['groupValue']) != '') {
              item.options[int.parse(element['groupValue'])].checked =
                  (element['groupValue']);
            } else {
              EasyLoading.showToast('请确保所有问卷内容已正确填写');
              showError = true;
              return false;
            }
          }
        });
      }
      if (item.type == 'CHECKBOX') {
        // 多选
        _questionsInit.forEach((element) {
          if (element['index'] == item.index) {
            if (element['checked'].length == 0) {
              EasyLoading.showToast('请确保所有问卷内容已正确填写');
              showError = true;
              return false;
            }
            // (element['checked']).forEach((checkeditem) {
            //   if (item.options[int.parse(checkeditem)] != null)
            //     item.options[int.parse(checkeditem)].checked = checkeditem;
            // });
          }
        });
      }
      if (item.type == 'TEXT') {
        // 文本
        _questionsInit.forEach((element) {
          if (element['index'] == item.index) {
            if (element['textField'] != null) {
              print(item.toString());
              Map<String, dynamic> reoptions = {
                "checked": element['textField'],
                "index": null,
                "answerOption": null,
              };

              QuestionOption option = QuestionOption.fromJson(reoptions);
              item.options.add(option);
            } else {
              EasyLoading.showToast('请确保所有问卷内容已正确填写');
              showError = true;
              return false;
            }
          }
        });
      }
    }

    if (!showError) {
      bool bindConfirm = await confirmDialog();
      if (bindConfirm) {
        String success = await submitQuestion({
          'learnPlanId': widget.data.learnPlanId,
          'resourceId': widget.data.resourceId,
          'questions': questionsAll
        }).then((res) {
          EasyLoading.showToast('提交成功');
          // 延时1s执行返回
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        });
        // if (success != null) {
        //   EasyLoading.showToast('提交成功');
        //   Navigator.of(context).pop();
        // }
      }
    }
  }

  // 构建 单选框Radio 单选题选项列表 组件
  Widget _buildRadioChoiceRow(question) {
    return new ListView.builder(
      physics: new NeverScrollableScrollPhysics(), // 禁用选项列表子组件的滚动事件
      shrinkWrap: true, //是否根据子widget的总长度来设置ListView的长度，默认值为false
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        var optionContent = question.options[index].answerOption;
        return _radioListItem(question, optionContent, index, optionContent);
      },
    );
  }

  Widget _radioListItem(question, optionContent, optionIndex, radioTitle) {
    String charCode = String.fromCharCode(65 + optionIndex);
    bool _dispatch = false;
    if (widget.data.learnStatus == 'FINISHED' ||
        widget.data.learnPlanStatus == 'SUBMIT_LEARN') {
      _dispatch = true;
    }
    return new Row(
      children: <Widget>[
        Expanded(
          // Row的子元素Text实现换行 需要加Expanded
          child: Text('$charCode、$radioTitle',
              softWrap: true, // 自动换行
              style: TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: 14,
              )),
        ),

        // 此处也可以使用RadioListTile，但是这个组件不满足我们这边的需求，所以自己后来写了布局
        new Radio(
            activeColor: _dispatch
                ? ThemeColor.secondaryGeryColor
                : ThemeColor.primaryColor, //选中时的颜色
            value: question.options[optionIndex].index, // 该值为string类型
            groupValue: _questionsInit[question.index]
                ['groupValue'], // 与value一样是选中
            // mouseCursor: MaterialStateMouseCursor.clickable,
            onChanged: (val) {
              // 收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
              // 滚动页面
              _scrollToIndex(question.index);
              if (!_dispatch) {
                setState(() {
                  _questionsInit[question.index]['groupValue'] = val;
                  // print('选中了: ' + val);
                });
              }
            })
      ],
    );
  }

  // 构建 复选框Checkbox 多选题选项列表 组件
  Widget _buildCheckboxChoiceRow(question) {
    return new ListView.builder(
      physics: new NeverScrollableScrollPhysics(), // 禁用选项列表子组件的滚动事件
      shrinkWrap: true, //是否根据子widget的总长度来设置ListView的长度，默认值为false
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        var optionContent = question.options[index].answerOption;

        return _checkboxListItem(question, optionContent, index, optionContent);
      },
    );
  }

  Widget _checkboxListItem(
      question, optionContent, optionIndex, checkboxTitle) {
    String charCode = String.fromCharCode(65 + optionIndex);
    bool _dispatch = false;
    if (widget.data.learnStatus == 'FINISHED' ||
        widget.data.learnPlanStatus == 'SUBMIT_LEARN') {
      _dispatch = true;
    }
    return new Row(
      children: <Widget>[
        Expanded(
          // Row的子元素Text实现换行 需要加Expanded
          child: Text(
            '$charCode、$checkboxTitle',
            softWrap: true, // 自动换行
          ),
        ),
        // 此处也可以使用CheckboxListTile，但是这个组件不满足我们这边的需求，所以后来自己写了布局
        Checkbox(
          activeColor: _dispatch
              ? ThemeColor.secondaryGeryColor
              : ThemeColor.primaryColor, //选中时的颜色
          checkColor: Colors.white, //选中时里面对号的颜色
          value: question.options[optionIndex].checked != null &&
              (int.parse(question.options[optionIndex].checked) ==
                      int.parse(question.options[optionIndex].index)
                  ? true
                  : false), // 该值为bool类型 false即不选中
          onChanged: (isCheck) {
            // 收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
            // 滚动页面
            _scrollToIndex(question.index);
            if (!_dispatch) {
              _checkMaxChoise(question, optionIndex, isCheck);
            }
          },
          // mouseCursor:MouseCursor,
        ),
      ],
    );
  }

  // 多选题 最多选择项的逻辑
  void _checkMaxChoise(question, optionIndex, isCheck) {
    setState(() {
      var optionId = question.options[optionIndex].index;

      if (isCheck) {
        _questionsInit[question.index]['checked'].add(optionId);
        question.options[optionIndex].checked = optionIndex.toString();
        // print('选中了: ' + optionId);
      } else {
        question.options[optionIndex].checked = null;
        _questionsInit[question.index]['checked'].remove(optionId);
        // print('选中了: ' + optionId);
      }
    });
  }

  // 构建 输入框行 简答题 组件
  Widget _buildTextControllerRow(question) {
    return new Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Container(
          color: const Color(0xFFFFFFFF),
          padding: EdgeInsets.only(left: 8.0),
          child: _buildTextField(question),
        ));
  }

  // 构建 输入框 组件
  Widget _buildTextField(question) {
    // 文本字段（`TextField`）组件，允许用户使用硬件键盘或屏幕键盘输入文本。
    bool _dispatch = true;
    if (widget.data.learnStatus == 'FINISHED' ||
        widget.data.learnPlanStatus == 'SUBMIT_LEARN') {
      _dispatch = false;
    }

    return new TextField(
      maxLines: 4,
      cursorColor: const Color(0xFFFE7C30),
      cursorWidth: 2.0,
      keyboardType: TextInputType.multiline, //多行
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(200) //限制长度200
      ],
      decoration: InputDecoration(
        hintText: "请输入",
        contentPadding: EdgeInsets.all(10.0),
        // 圆角矩形的边框
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      enabled: _dispatch, //禁用
      onChanged: (text) {
        _questionsInit[question.index]['textField'] = text;
        // print("${question.index}输入框 组件: $text");
        // 滚动页面
        _scrollToIndex(question.index);
      },
      controller: new TextEditingController(
          text: _questionsInit[question.index]['textField']), // 控制正在编辑的文本
    );
  }

  // 渲染不同类型问卷题目
  Widget _renderQuestionsType(Question questionsItem) {
    if (questionsItem.type == 'RADIO') {
      return _buildRadioChoiceRow(questionsItem);
    } else if (questionsItem.type == 'CHECKBOX') {
      return _buildCheckboxChoiceRow(questionsItem);
    } else {
      return _buildTextControllerRow(questionsItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // shrinkWrap: true, //是否根据子widget的总长度来设置ListView的长度，默认值为false
      scrollDirection: scrollDirection,
      controller: controller,
      children: <Widget>[
        GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 60),
              margin: EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(widget.data.title ?? widget.data.resourceName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: ThemeColor.colorFF444444,
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        if (widget.data.info != null &&
                            widget.data.info.summary != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(widget.data.info.summary,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: ThemeColor.colorFF444444,
                                    )),
                              )

                              // ])
                            ],
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(children: [
                          Text('一、基本情况',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: ThemeColor.colorFF444444,
                              )),
                        ]),
                        ...(widget.data.questions).map((item) {
                          return _wrapScrollTag(
                              index: item.index,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.fromLTRB(4, 24, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        '${item.index + 1}、${widget.data.questions[item.index].question}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: ThemeColor.colorFF444444,
                                        )),
                                    _renderQuestionsType(
                                        widget.data.questions[item.index])
                                  ],
                                ),
                              ));
                        }).toList(),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    if (widget.data.learnStatus != 'FINISHED' &&
                        widget.data.learnPlanStatus != 'SUBMIT_LEARN') //已完成、已提交
                      AceButton(
                        onPressed: _openFile,
                        text: '提交',
                      ),
                    if (widget.data.learnStatus != 'FINISHED' &&
                        widget.data.learnPlanStatus != 'SUBMIT_LEARN') //已完成、已提交
                      SizedBox(
                        height: 360,
                      ),
                  ]),
            ))
      ],
    );
  }

  // 滚动定位

  int scrollTocounter = -1;
  Future _scrollToIndex(counter) async {
    if (counter != scrollTocounter) {
      print('$scrollTocounter----滚动定位：$counter');
      await controller.scrollToIndex(counter,
          preferPosition: AutoScrollPosition.begin);
      controller.highlight(counter);
      scrollTocounter = counter;
    }
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.02),
      );
}
