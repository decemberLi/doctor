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
  List _questionsInit;

  @override
  void initState() {
    // 在initState中发出请求
    _questionsInit = _getQuestionsInit();

    super.initState();
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
          'groupValue': '-1'
        });
      }
      if (item.type == 'CHECKBOX') {
        // item.checked = [];
        questionsNew.add({
          'index': item.index,
          'question': item.question,
          'type': 'CHECKBOX',
          'checked': []
        });
      }
      if (item.type == 'TEXT') {
        questionsNew.add({
          'index': item.index,
          'question': item.question,
          'type': 'TEXT',
          'textField': ''
        });
      }
    }
    return questionsNew;
  }

  _openFile() async {
    // TODO: 提交问卷
    EasyLoading.showToast('$_questionsInit');
    print('提交问卷:$_questionsInit');
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
    return new Row(
      children: <Widget>[
        Expanded(
          // Row的子元素Text实现换行 需要加Expanded
          child: Text(
            '$charCode、$radioTitle',
            softWrap: true, // 自动换行
          ),
        ),
        // 此处也可以使用RadioListTile，但是这个组件不满足我们这边的需求，所以自己后来写了布局
        new Radio(
          activeColor: ThemeColor.primaryColor, //选中时的颜色
          value: question.options[optionIndex].index, // 该值为string类型
          groupValue: _questionsInit[question.index]
              ['groupValue'], // 与value一样是选中
          onChanged: (val) {
            // 收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              _questionsInit[question.index]['groupValue'] = val;
              print('选中了: ' + val);
            });
          },
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
    String charCode = String.fromCharCode(65 + optionIndex);
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
          activeColor: ThemeColor.primaryColor, //选中时的颜色
          checkColor: Colors.white, //选中时里面对号的颜色
          value: question.options[optionIndex].checked != null &&
              (question.options[optionIndex].checked ==
                      int.parse(question.options[optionIndex].index)
                  ? true
                  : false), // 该值为bool类型 false即不选中
          onChanged: (isCheck) {
            // 收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
            _checkMaxChoise(question, optionIndex, isCheck);
          },
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
        question.options[optionIndex].checked = optionIndex;
        print('选中了: ' + optionId);
      } else {
        question.options[optionIndex].checked = null;
        _questionsInit[question.index]['checked'].remove(optionId);
        print('选中了: ' + optionId);
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
    return new TextField(
      maxLines: 8,
      cursorColor: const Color(0xFFFE7C30),
      cursorWidth: 2.0,
      keyboardType: TextInputType.multiline, //多行
      decoration: InputDecoration(
        hintText: "请输入",
        contentPadding: EdgeInsets.all(10.0),
        // 圆角矩形的边框
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: (text) {
        _questionsInit[question.index]['textField'] = text;

        print("输入框 组件: $text");
      },
      // controller: controller, // 控制正在编辑的文本
    );
  }

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
                      itemCount: widget.data.questions.length,
                      itemBuilder: (context, index) {
                        // 列表显示
                        return Container(
                          padding: new EdgeInsets.fromLTRB(4, 4, 10, 4),
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
}
