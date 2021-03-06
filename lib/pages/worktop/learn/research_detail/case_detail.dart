import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:http_manager/api.dart';

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

    _nameController.addListener(() {
      setState(() {

      });
    });
    _ageController.addListener(() {
      setState(() {

      });
    });
    _hospitalController.addListener(() {
      setState(() {

      });
    });
    _codeController.addListener(() {
      setState(() {

      });
    });
  }

  Widget buildText(TextEditingController controller, int maxLength,
      TextInputType keyboardType) {
    var noneBorder = UnderlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent),
    );
    return Container(
      constraints: BoxConstraints(
        minHeight: 10,
        maxHeight: 100,
      ),
      child:TextField(
        maxLines: null,
        enabled: widget.canSubmit,
        maxLength: maxLength,
        controller: controller,
        textAlign: TextAlign.end,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: "?????????",
          hintStyle: TextStyle(
            fontSize: 12,
            color: Color(0xff888888),
          ),
          border: noneBorder,
          focusedBorder: noneBorder,
          enabledBorder: noneBorder,
          disabledBorder: noneBorder,
          counterText: "",
        ),
      ),
    );
  }

  Widget buildPicker() {
    var sex = "?????????";
    var textStyle = TextStyle(
      fontSize: 12,
      color: Color(0xff888888),
    );
    if (data?.sex != null) {
      var sexValue = data?.sex;
      if (sexValue == 0) {
        sex = "???";
      } else {
        sex = "???";
      }
      textStyle = TextStyle(
        fontSize: 16,
        color: Colors.black,
      );
    }

    return GestureDetector(
      onTap: () {
        if (!widget.canSubmit) {
          return;
        }
        var listData = [
          PickerItem(
            text: Text('???'),
            value: 0,
          ),
          PickerItem(
            text: Text('???'),
            value: 1,
          ),
        ];
        var picker = Picker(
            title: Text(
              '????????????',
              style: TextStyle(fontSize: 18),
            ),
            selecteds: [data?.sex ?? 0],
            height: 200,
            columnPadding: EdgeInsets.all(30),
            itemExtent: 40,
            adapter: PickerDataAdapter<int>(data: listData),
            changeToFirst: true,
            cancelText: '??????',
            confirmText: '??????',
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
      child: Container(
        height: 50,
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          sex,
          textAlign: TextAlign.end,
          style: textStyle,
        ),
      ),
    );
  }

  Widget buildItem(String name, Widget content) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(name,),
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
    bool canSave = true;
    for(int i=0;i<data.showFields.length;i++){
      var item = data.showFields[i];
      Widget one;
      //"patientName","patientCode","age","sex","hospital"
      if (item == "patientName") {
        one = buildItem("????????????",
        buildText(_nameController, 10, TextInputType.text));
        canSave = canSave && _nameController.text.length > 0;
      }else if (item == "patientCode") {
        one = buildItem("????????????",
        buildText(_codeController, 20, TextInputType.text));
        canSave = canSave && _codeController.text.length > 0;
      }else if (item  == "age") {
        one = buildItem("??????",
        buildText(_ageController, 5, TextInputType.number));
        canSave = canSave && _ageController.text.length > 0;
      }else if (item  == "sex") {
        one = buildItem("??????", buildPicker());
        canSave = canSave && data.sex != null;
      }else if (item == "hospital") {
        one = buildItem("????????????",
        buildText(_hospitalController, 30, TextInputType.text));
        canSave = canSave && _hospitalController.text.length > 0;
      }
      if (one != null) {
        showList.add(one);
      }

    }
    var upColor = Color(0xFFBCBCBC);
    var shadowColor = Color(0xFFBCBCBC).withOpacity(0.4);
    if (canSave) {
      upColor = Color(0xff107BFD);
      shadowColor = Color(0xff489DFE).withOpacity(0.4);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("??????????????????"),
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
                  if (!canSave) {
                    return;
                  }
                  EasyLoading.instance.flash(() async {
                    data.hospital = _hospitalController.text;
                    data.patientName = _nameController.text;

                    if (_ageController.text != null && _ageController.text.length > 0) {
                      try {
                        int age = int.parse(_ageController.text);
                        if (age < 0) {
                          throw "-1";
                        }
                        data.age = age;
                      }catch(e) {
                        EasyLoading.showToast(
                            '????????????????????????', duration: Duration(seconds: 1));

                        await Future.delayed(Duration(seconds: 1));
                        return;
                      }
                    }

                    data.patientCode = _codeController.text;
                    print("the data is ${data.toJson()}");
                    await API.shared.server.updateIllnessCase(data.toJson());
                    data.status = "COMPLETE";
                    await EasyLoading.showToast("????????????");
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 44,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 10),
                  child: Text(
                    "??????",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: upColor,
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
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
