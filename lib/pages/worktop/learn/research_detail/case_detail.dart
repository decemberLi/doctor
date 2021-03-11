import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:flutter_picker/flutter_picker.dart';

class CaseDetail extends StatefulWidget {
  final IllnessCase data;
  final bool canSubmit;

  CaseDetail(this.data, this.canSubmit);

  @override
  State<StatefulWidget> createState() {
    return CaseDetailState(data);
  }
}

class CaseDetailState extends State<CaseDetail> {
  IllnessCase data;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();

  CaseDetailState(this.data) {
    print("init data is ${data.toJson()}");
    _nameController.text = data.patientName;
    _ageController.text = data.age == null ? "" : "${data.age}";
    _hospitalController.text = data.hospital;
    _codeController.text = data.patientCode;
  }

  Widget buildText(TextEditingController controller, int maxLength,
      TextInputType keyboardType) {
    var noneBorder = UnderlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent),
    );
    return TextField(
      maxLength: maxLength,
      controller: controller,
      textAlign: TextAlign.end,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: "请输入",
        hintStyle: TextStyle(
          fontSize: 12,
          color: Color(0xff888888),
        ),
        border: noneBorder,
        focusedBorder: noneBorder,
        enabledBorder: noneBorder,
        counterText: "",
      ),
    );
  }

  Widget buildPicker() {
    var sex = "请选择";
    var textStyle = TextStyle(
      fontSize: 12,
      color: Color(0xff888888),
    );
    if (data?.sex != null) {
      var sexValue = data?.sex;
      if (sexValue == 0) {
        sex = "女";
      } else {
        sex = "男";
      }
      textStyle = TextStyle(
        fontSize: 14,
        color: Colors.black,
      );
    }

    return GestureDetector(
      onTap: () {
        var listData = [
          PickerItem(
            text: Text('女'),
            value: 0,
          ),
          PickerItem(
            text: Text('男'),
            value: 1,
          ),
        ];
        var picker = Picker(
            title: Text(
              '选择性别',
              style: TextStyle(fontSize: 18),
            ),
            selecteds: [data?.sex ?? 0],
            height: 200,
            columnPadding: EdgeInsets.all(30),
            itemExtent: 40,
            adapter: PickerDataAdapter<int>(data: listData),
            changeToFirst: true,
            cancelText: '取消',
            confirmText: '确认',
            cancelTextStyle:
                TextStyle(color: ThemeColor.primaryColor, fontSize: 18),
            confirmTextStyle:
                TextStyle(color: ThemeColor.primaryColor, fontSize: 18),
            onConfirm: (picker, list) {
              setState(() {
                data.sex = listData[list.first].value;
              });
            });
        picker.showModal(context);
      },
      child: Text(
        sex,
        textAlign: TextAlign.end,
        style: textStyle,
      ),
    );
  }

  Widget buildItem(String name, Widget content) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(name),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: content,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0xffF3F5F8),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> showList = [];
    for(int i=0;i<data.showFields.length;i++){
      var item = data.showFields[i];
      Widget one;
      //"patientName","patientCode","age","sex","hospital"
      if (item == "patientName") {
        one = buildItem("患者姓名",
        buildText(_nameController, 10, TextInputType.text));
      }else if (item == "patientCode") {
        one = buildItem("编码",
        buildText(_codeController, 20, TextInputType.text));
      }else if (item  == "age") {
        one = buildItem("年龄",
        buildText(_ageController, 5, TextInputType.number));
      }else if (item  == "sex") {
        one = buildItem("性别", buildPicker());
      }else if (item == "hospital") {
        one = buildItem("就诊医院",
        buildText(_hospitalController, 30, TextInputType.text));
      }
      if (one != null) {
        showList.add(one);
      }

    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("病例信息详情"),
      ),
      body: Container(
        color: Color(0xfff3f5f8),
        height: double.infinity,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Container(
                child: Column(
                  children: showList,
                ),
              ),
            ),
            Expanded(child: Container()),
            if (widget.canSubmit)
              GestureDetector(
                onTap: () async {
                  EasyLoading.instance.flash(() async {
                    data.hospital = _hospitalController.text;
                    data.patientName = _nameController.text;
                    if (_ageController.text != null && _ageController.text.length > 0) {
                      data.age = int.parse(_ageController.text);
                    }

                    data.patientCode = _codeController.text;
                    print("the data is ${data.toJson()}");
                    await API.shared.server.updateIllnessCase(data.toJson());
                    data.status = "COMPLETE";
                    EasyLoading.showToast("保存成功");
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 44,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 10),
                  child: Text(
                    "保存",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff489DFE).withOpacity(0.85),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff489DFE).withOpacity(0.4),
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
