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

  /

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
      shrinkWrap: true, //是否根据子widget的总长度来设置ListView的长度，默认值为false
      physics: new NeverScrollableScrollPhysics(), // 禁用问题列表子组件的滚动事件
      //itemCount +1 为了显示加载中和暂无数据progressbar
      itemCount: widget.data.questions.length + 1,
      itemBuilder: (context, index) {
        // 列表显示
        return Container(
          padding: new EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.data.questions[index]['type'] == 'RADIO'
                  ? question(widget.data.questions)
                  : widget.data.questions[index]['type'] == "CHECKBOX"
                      ? question(widget.data.questions)
                      : question(widget.data.questions)
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
