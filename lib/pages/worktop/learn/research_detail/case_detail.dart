import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';

class CaseDetail extends StatefulWidget {
  final IllnessCase data;
  CaseDetail(this.data);
  @override
  State<StatefulWidget> createState() {
    return CaseDetailState(data);
  }
}

class CaseDetailState extends State<CaseDetail> {
  IllnessCase data;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  CaseDetailState(this.data){
    print("init data is ${data.toJson()}");
    _nameController.text = data.patientName;
    _ageController.text = data.age == null ? "" : "${data.age}";
    var sex = "男";
    if (data.sex == 1) sex = "女";
    _sexController.text = sex;
    _hospitalController.text = data.hospital;
  }
  Widget buildItem(String name,TextEditingController controller) {
    var noneBorder = UnderlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent),
    );
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
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      hintText: "请输入",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Color(0xff888888),
                      ),
                      border: noneBorder,
                      focusedBorder: noneBorder,
                      enabledBorder: noneBorder,
                    ),
                  ),
                )
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
                  children: [
                    buildItem("患者姓名/编码",_nameController),
                    buildItem("年龄",_ageController),
                    buildItem("性别",_sexController),
                    buildItem("就诊医院",_hospitalController),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () async{
                EasyLoading.instance.flash(() async {
                  data.hospital = _hospitalController.text;
                  data.patientName = _nameController.text;
                  data.age = int.parse(_ageController.text);
                  if (_sexController.text == "男") {
                    data.sex = 1;
                  }else{
                    data.sex = 0;
                  }

                  print("the data is ${data.toJson()}");
                  await API.shared.server.updateIllnessCase(data.toJson());
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
