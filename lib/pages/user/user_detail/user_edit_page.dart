import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../service.dart';

final uploadData = {
  '姓名': 'doctorName',
  '个人简介': 'briefIntroduction',
  '擅长疾病': 'speciality',
};

class UserEditPage extends StatefulWidget {
  final lable;
  final value;
  final editWay;
  final function;

  UserEditPage(this.lable, this.value, this.editWay, this.function);

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  //设置编辑时的值
  TextEditingController dataText = new TextEditingController();

  //编辑
  Widget editWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(
        minLines: widget.lable == '姓名' ? 1 : 6,
        maxLines: 10,
        maxLength: widget.lable == '姓名'
            ? 10
            : widget.lable == '个人简介'
                ? 500
                : 200,
        autofocus: true,
        controller: dataText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          helperText: widget.lable == '姓名' ? '请您如实填写,认证通过后将不可修改' : '',
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: '请输入您的${widget.lable}',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    dataText.text = widget.value; //初始化默认值
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lable ?? ''),
          elevation: 1,
        ),
        body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              if (widget.editWay == 'edit') editWidget(),
              AceButton(
                onPressed: () {
                  updateUserInfo({uploadData[widget.lable]: dataText.text})
                      .then((res) {
                    if (res['status'] == 'ERROR') {
                      EasyLoading.showToast(res['errorMsg']);
                    } else {
                      widget.function(
                          {uploadData[widget.lable]: dataText.text}, true);
                    }
                  });
                },
                text: '保存',
              )
            ],
          ),
        ),
      ),
    );
  }
}
