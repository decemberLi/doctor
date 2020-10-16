import 'package:doctor/http/common_service.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/pages/worktop/resource/view_model/resource_component_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_file_preview/flutter_file_preview.dart';

class QuestionPage extends StatefulWidget {
  final ResourceModel data;
  QuestionPage(this.data);
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool _checkboxSelected = true; //维护复选框状态
  bool _character = true; //维护复选框状态

  // String groupValue;
  // String valueLiu;
  // String valueZhang;
  // String valueGuo;
  // String valueLi;

  // @override
  // void initState() {
  //   super.initState();
  //   groupValue = "刘德华";
  //   valueLiu = "刘德华";
  //   valueZhang = "张学友";
  //   valueGuo = "郭富城";
  //   valueLi = "黎明";
  // }

  // _QuestionPageState();

  _openFile() async {
    var files = await CommonService.getFile({
      'ossIds': [widget.data.attachmentOssId]
    });
    if (files.isEmpty) {
      EasyLoading.showToast('打开失败');
    }
    // TODO: 预览器UI修改
    FlutterFilePreview.openFile(files[0]['tmpUrl'],
        title: widget.data.title ?? widget.data.resourceName);
  }

  Widget toOptions(String type, Iterable options) {
    List<Widget> tiles = [];
    Widget content;
    // if (resources.isEmpty) {
    //   content = new Column(
    //       children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
    //       );
    //   return content;
    // }
    for (var item in options) {
      String charCode = String.fromCharCode(65 + int.parse(item.index));
      tiles.add(
        new Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.only(left: 0, top: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text('$charCode、${item.answerOption}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: ThemeColor.colorFF444444,
                              ))),
                    ],
                  ),
                ])),
      );
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        );
    return content;
  }

  Widget question(Iterable questions) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    // if (resources.isEmpty) {
    //   content = new Column(
    //       children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
    //       );
    //   return content;
    // }
    for (var item in questions) {
      tiles.add(
        new Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.only(left: 0, top: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              '${item.index + 1}、问卷题目-------》》》》${item.question}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: ThemeColor.colorFF444444,
                              ))),
                    ],
                  ),
                  toOptions(item.type, item.options),
                ])),
      );
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        );
    return content;
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
    return new Row(
      children: <Widget>[
        // 此处也可以使用RadioListTile，但是这个组件不满足我们这边的需求，所以自己后来写了布局
        new Radio(
          value: question.options[optionIndex].index, // 该值为string类型
          groupValue: question.index, // 与value一样是选中
          onChanged: (val) {
            // 收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              question.index = int.parse(val);
              print('选中了: ' + val.toString());
            });
          },
        ),
        Expanded(
          // Row的子元素Text实现换行 需要加Expanded
          child: Text(
            radioTitle,
            softWrap: true, // 自动换行
          ),
        ),
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
    return new Row(
      children: <Widget>[
        // 此处也可以使用CheckboxListTile，但是这个组件不满足我们这边的需求，所以后来自己写了布局
        Checkbox(
          value: question.options[optionIndex].checked, // 该值为bool类型 false即不选中
          onChanged: (isCheck) {
            // 收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
            _checkMaxChoise(question, optionIndex, isCheck);
          },
        ),
        Expanded(
          // Row的子元素Text实现换行 需要加Expanded
          child: Text(
            checkboxTitle,
            softWrap: true, // 自动换行
          ),
        ),
      ],
    );
  }

  // 多选题 最多选择项的逻辑
  void _checkMaxChoise(question, optionIndex, isCheck) {
    setState(() {
      var optionId = question.options[optionIndex].index;
      question.options[optionIndex].checked = isCheck;
      if (isCheck) {
        print('选中了: ' + optionId);
        question['checked'].add(optionId);

        print('选中的: ' + question['checked'].toString());
      } else {
        question['checked'].remove(optionId);
        print('选中的: ' + question['checked'].toString());
      }
    });
  }

  // 构建 输入框行 简答题 组件
  Widget _buildTextControllerRow(question) {
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: const Color(0xFFFFFFFF),
          padding: EdgeInsets.only(left: 8.0),
          child: _buildTextField(question['textController']),
        ));
  }

  // 构建 输入框 组件
  Widget _buildTextField(controller) {
    // 文本字段（`TextField`）组件，允许用户使用硬件键盘或屏幕键盘输入文本。
    return new TextField(
      cursorColor: const Color(0xFFFE7C30),
      cursorWidth: 2.0,
      keyboardType: TextInputType.multiline, //多行
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        // 圆角矩形的边框
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      controller: controller, // 控制正在编辑的文本
    );
  }

  int sex = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true, //是否根据子widget的总长度来设置ListView的长度，默认值为false
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                    Column(children: [
                      if (widget.data.info != null &&
                          widget.data.info.summary != null)
                        Text(widget.data.info.summary,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: ThemeColor.colorFF444444,
                            )),
                    ]),
                    SizedBox(
                      height: 16,
                    ),
                    Row(children: [
                      Text('一、基本情况',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ThemeColor.colorFF444444,
                          )),
                    ]),
                    ListView.builder(
                      shrinkWrap:
                          true, //是否根据子widget的总长度来设置ListView的长度，默认值为false
                      physics:
                          new NeverScrollableScrollPhysics(), // 禁用问题列表子组件的滚动事件
                      //itemCount +1 为了显示加载中和暂无数据progressbar
                      itemCount: widget.data.questions.length + 1,
                      itemBuilder: (context, index) {
                        // 列表显示
                        return Container(
                          padding: new EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '${index + 1}、${widget.data.questions[index].question}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: ThemeColor.colorFF444444,
                                  )),
                              widget.data.questions[index].type == 'RADIO'
                                  ? _buildRadioChoiceRow(
                                      widget.data.questions[index])
                                  : widget.data.questions[index].type ==
                                          "CHECKBOX"
                                      ? _buildCheckboxChoiceRow(
                                          widget.data.questions[index])
                                      : _buildTextControllerRow(
                                          widget.data.questions[index])
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Checkbox(
                      value: _checkboxSelected,
                      activeColor: ThemeColor.primaryColor, //选中时的颜色
                      checkColor: Colors.white, //选中时里面对号的颜色
                      onChanged: (value) {
                        setState(() {
                          _checkboxSelected = value;
                        });
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RadioListTile(
                          value: 1,
                          onChanged: (value) {
                            setState(() {
                              this.sex = value;
                            });
                          },
                          groupValue: this.sex,
                          selected: this.sex == 1,
                        ),
                        RadioListTile(
                          value: 2,
                          onChanged: (value) {
                            setState(() {
                              this.sex = value;
                            });
                            ResourceComponentModel()
                                .changeOptions(widget.data, value);
                          },
                          groupValue: this.sex,
                          selected: this.sex == 2,
                        ),
                        TextField(
                          maxLines: 8,
                          onSubmitted: (value) {
                            print(value);
                          },
                          decoration: InputDecoration.collapsed(
                              hintText: "Enter your text here"),
                        ),
                      ],
                    ),
                  ],
                ),
                AceButton(
                  onPressed: _openFile,
                  text: '提交',
                ),
              ]),
        )
      ],
    );
  }

  // void _changed(value) {
  //   groupValue = value;
  //   setState(() {});
  // }
}
