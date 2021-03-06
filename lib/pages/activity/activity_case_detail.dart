import 'dart:ffi';

import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:http_manager/api.dart';

import 'entity/activity_questionnaire_entity.dart';
import 'package:doctor/http/activity.dart';

class ActivityCaseDetail extends StatefulWidget {
  final ActivityIllnessCaseEntity data;
  final int activityPackageId;
  final int activityTaskId;
  final bool canSubmit;

  ActivityCaseDetail(this.data, this.activityPackageId, this.canSubmit,
      {this.activityTaskId});

  @override
  State<StatefulWidget> createState() {
    return ActivityCaseDetailState(data);
  }
}

class ActivityCaseDetailState extends State<ActivityCaseDetail> {
  ActivityIllnessCaseEntity data;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();

  ActivityCaseDetailState(this.data) {
    print("init data is ${data.toJson()}");
    _nameController.text = data.patientName;
    _ageController.text = data.age == null ? "" : "${data.age}";
    _hospitalController.text = data.hospital;
    _codeController.text = data.patientCode;
    _weightController.text = data.weight == null ? "" : data.weight.toString();
    _heightController.text = data.height == null ? "" : data.height.toString();

    _weightController.addListener(() {
      setState(() {});
    });
    _heightController.addListener(() {
      setState(() {});
    });

    _nameController.addListener(() {
      setState(() {});
    });
    _ageController.addListener(() {
      setState(() {});
    });
    _hospitalController.addListener(() {
      setState(() {});
    });
    _codeController.addListener(() {
      setState(() {});
    });
  }

  Widget buildText(TextEditingController controller, int maxLength,
      TextInputType keyboardType,
      {bool editAble = true, String hintText = "?????????"}) {
    var noneBorder = UnderlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent),
    );
    return Container(
      constraints: BoxConstraints(
        minHeight: 10,
        maxHeight: 100,
      ),
      child: TextField(
        maxLines: null,
        enabled: widget.canSubmit && editAble,
        maxLength: maxLength,
        controller: controller,
        textAlign: TextAlign.end,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
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

  Widget buildDatePicker(int date, void Function(DateTime result) onchange,
      {DateTime defaultTime}) {
    var sex = "?????????";
    var textStyle = TextStyle(
      fontSize: 12,
      color: Color(0xff888888),
    );
    DateTime time = defaultTime ?? DateTime.now();
    if (date != null) {
      time = DateTime.fromMillisecondsSinceEpoch(date);
      sex = "${time.year}-${time.month}-${time.day}";
      textStyle = TextStyle(
        fontSize: 16,
        color: Colors.black,
      );
    }

    return GestureDetector(
      onTap: () async {
        if (!widget.canSubmit) {
          return;
        }
        DateTime last = DateTime(DateTime.now().year, 12, 31);
        DateTime result = await showDatePicker(
          context: context,
          initialDate: time,
          firstDate: DateTime(1900, 1, 1),
          lastDate: last,
        );
        if (result != null) {
          onchange(result);
        }
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

  Widget buildPicker(
      String text, List<String> list,String title, void Function(String value) onChange) {
    var sex = "?????????";
    var textStyle = TextStyle(
      fontSize: 12,
      color: Color(0xff888888),
    );
    if (text != null) {
      sex = text;
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
        var listData = list
            .asMap()
            .map(
              (key, value) => MapEntry(
                key,
                PickerItem(
                  text: Text(value),
                  value: key,
                ),
              ),
            )
            .values
            .toList();
        var selected = list.indexOf(text);
        if (selected < 0){
          selected = 0;
        }
        var picker = Picker(
            title: Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            selecteds: [selected],
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
            onConfirm: (picker, resultList) {
              onChange(list[resultList.first]);
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
                Text(
                  name,
                ),
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
    var showArray = data.showFields;
    showArray.remove("patientCode");
    showArray = ["patientCode", ...showArray];
    for (int i = 0; i < showArray.length; i++) {
      var item = showArray[i];
      Widget one;
      //"patientName","patientCode","age","sex","hospital"
      if (item == "patientName") {
        one = buildItem(
            "????????????", buildText(_nameController, 10, TextInputType.text));
        canSave = canSave && _nameController.text.length > 0;
      } else if (item == "patientCode") {
        one = buildItem(
            "????????????",
            buildText(_codeController, 20, TextInputType.text,
                editAble: false, hintText: "????????????"));
        // canSave = canSave && _codeController.text.length > 0;
      } else if (item == "age") {
        one = buildItem(
            "??????",
            buildText(_ageController, 5,
                TextInputType.numberWithOptions(decimal: true)));
        canSave = canSave && _ageController.text.length > 0;
      } else if (item == "sex") {
        String sex = null;
        if (data?.sex != null) {
          var sexValue = data?.sex;
          if (sexValue == 0) {
            sex = "???";
          } else {
            sex = "???";
          }
        }
        one = buildItem(
          "??????",
          buildPicker(
            sex,
            ["???", "???"],
            '????????????',
            (value) {
              if (value == "???") {
                data.sex = 1;
              } else {
                data.sex = 0;
              }
              setState(() {});
            },
          ),
        );
        canSave = canSave && data.sex != null;
      } else if (item == "hospital") {
        one = buildItem(
            "????????????", buildText(_hospitalController, 30, TextInputType.text));
        canSave = canSave && _hospitalController.text.length > 0;
      } else if (item == "height") {
        one = buildItem(
            "??????(cm)",
            buildText(_heightController, 6,
                TextInputType.numberWithOptions(decimal: true)));
        canSave = canSave && _heightController.text.length > 0;
      } else if (item == "weight") {
        one = buildItem(
            "??????(kg)",
            buildText(_weightController, 6,
                TextInputType.numberWithOptions(decimal: true)));
        canSave = canSave && _weightController.text.length > 0;
      } else if (item == "birthDay") {
        one = buildItem(
            "????????????",
            buildDatePicker(
              data.birthDay,
              (result) {
                data.birthDay = result.millisecondsSinceEpoch;
                setState(() {

                });
              },
              defaultTime: DateTime(2000, 1, 1),
            ));
        canSave = canSave && data.birthDay != null;
      } else if (item == "fillingDate") {
        one = buildItem(
            "????????????",
            buildDatePicker(
              data.fillingDate,
              (result) {
                data.fillingDate = result.millisecondsSinceEpoch;
                setState(() {

                });
              },
            ));
        canSave = canSave && data.fillingDate != null;
      } else if (item == "nation") {
        var nation = data.nation;
        one = buildItem(
          "??????",
          buildPicker(
            nation,
            notionList,
            '????????????',
            (value) {
              data.nation = value;
              setState(() {});
            },
          ),
        );
        canSave = canSave && data.nation != null;
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
    var body = Column(
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
        // Expanded(child: Container()),
        Container(
          height: 20,
        ),
        if (widget.canSubmit)
          GestureDetector(
            onTap: () async {
              if (!canSave) {
                return;
              }
              if (EasyLoading.isShow) {
                return;
              }
              EasyLoading.instance.flash(() async {
                data.hospital = _hospitalController.text;
                data.patientName = _nameController.text;
                try {
                  data.weight = double.parse(_weightController.text ?? "");
                } catch (e) {}

                try {
                  data.height = double.parse(_heightController.text ?? "");
                }catch(e){}

                if (_ageController.text != null &&
                    _ageController.text.length > 0) {
                  try {
                    int age = int.parse(_ageController.text);
                    if (age < 0) {
                      throw "-1";
                    }
                    data.age = age;
                  } catch (e) {
                    EasyLoading.showToast('????????????????????????',
                        duration: Duration(seconds: 1));

                    await Future.delayed(Duration(seconds: 1));
                    return;
                  }
                }

                data.patientCode = _codeController.text;
                print("the data is ${data.toJson()}");
                var result =
                    await API.shared.activity.activityIllnessCaseSaveWithJson(
                  widget.activityPackageId,
                  data.toJson(),
                  activityTaskId: widget.activityTaskId,
                );
                var activityTaskId = result["activityTaskId"] as int;
                data.status = "COMPLETE";
                await EasyLoading.showToast("????????????");
                await Future.delayed(Duration(seconds: 1));
                Navigator.of(context).pop(activityTaskId);
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
    );
    return Scaffold(
      backgroundColor: Color(0xffefefef),
      appBar: AppBar(
        elevation: 0,
        title: Text("??????????????????"),
      ),
      body: SingleChildScrollView(
        child: body,
      ),
    );
  }
}

const notionList = [
  "??????",
  "??????",
  "?????????",
  "??????",
  "??????",
  "????????????",
  "??????",
  "??????",
  "??????",
  "?????????",
  "??????",
  "??????",
  "??????",
  "?????????",
  "?????????",
  "????????????",
  "??????",
  "??????",
  "?????????",
  "??????",
  "??????",
  "?????????",
  "?????????",
  "??????",
  "?????????",
  "?????????",
  "?????????",
  "???????????????",
  "??????",
  "????????????",
  "?????????",
  "??????",
  "?????????",
  "?????????",
  "?????????",
  "?????????",
  "?????????",
  "?????????",
  "?????????",
  "?????????",
  "????????????",
  "??????",
  "???????????????",
  "????????????",
  "????????????",
  "?????????",
  "?????????",
  "?????????",
  "??????",
  "????????????",
  "?????????",
  "????????????",
  "?????????",
  "?????????",
  "?????????",
  "?????????",
];
