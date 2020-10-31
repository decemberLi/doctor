import 'package:doctor/pages/qualification/model/config_data_entity.dart';
import 'package:doctor/pages/qualification/view_model/doctor_qualification_view_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class UserEditPage extends StatefulWidget {
  final lable;
  final value;
  final editWay;
  UserEditPage(this.lable, this.value, this.editWay);
  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  //设置编辑时的值
  TextEditingController dataText = new TextEditingController();
  //医院model
  DoctorQualificationViewModel _model = DoctorQualificationViewModel();
  SearchWidget<HospitalEntity> _hospitalSearchWidget;
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

  //search选择医院
  Widget pickerWidget() {
    return SearchWidget<HospitalEntity>(
      '选择医院',
      hintText: '输入医院名称',
      searchConditionCallback: <T extends Search>(condition, streamSink) async {
        var hospitals = await _model.queryHospital(condition);
        streamSink.add(hospitals);
      },
      callback: <T extends Search>(value, position) {
        _model.setHospital(value as HospitalEntity);
        _model.changeDataNotify();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    dataText.text = widget.value; //初始化默认值
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置${widget.lable}'),
        elevation: 1,
      ),
      body: Container(
        // margin: EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.editWay == 'edit') editWidget(),
            if (widget.editWay == 'search') pickerWidget(),
            AceButton(
              onPressed: () {},
              text: '保存',
            )
          ],
        ),
      ),
    );
  }
}
