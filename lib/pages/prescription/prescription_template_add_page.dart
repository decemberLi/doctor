import 'package:dio/dio.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/widgets/rp_list.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

class PrescriptionTemplageAddPage extends StatefulWidget {
  @override
  _PrescriptionTemplageAddPageState createState() =>
      _PrescriptionTemplageAddPageState();
}

class _PrescriptionTemplageAddPageState
    extends State<PrescriptionTemplageAddPage> {
  PrescriptionTemplateModel data = PrescriptionTemplateModel();

  final _formKey = GlobalKey<FormState>();

  HttpManager http = HttpManager('dtp');

  changeDataNotify() {
    setState(() {});
  }

  submitData() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        var res = await http.post('/prescription-template/add',
            params: this.data.toJson());
        if (!(res is DioError)) {
          Navigator.pop(context, true);
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('添加处方模板'),
        ),
        body: Form(
          key: _formKey, //设置globalKey，用于后面获取FormState
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            color: ThemeColor.colorFFF3F5F8,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '模板名称',
                  style: MyStyles.inputTextStyle,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    initialValue: data.prescriptionTemplateName ?? '',
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (val) => val.length < 1 ? '名称不能为空' : null,
                    onSaved: (val) => {data.prescriptionTemplateName = val},
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    style: MyStyles.inputTextStyle,
                    // onChanged: (value) {
                    //   setState(() {
                    //     data.prescriptionTemplateName = value;
                    //   });
                    // },
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  '临床诊断',
                  style: MyStyles.inputTextStyle,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    initialValue: data.clinicalDiagnosis ?? '',
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (val) => val.length < 1 ? '临床诊断不能为空' : null,
                    onSaved: (val) => {data.clinicalDiagnosis = val},
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    style: MyStyles.inputTextStyle,
                    // onChanged: (value) {
                    //   setState(() {
                    //     data.clinicalDiagnosis = value;
                    //   });
                    // },
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Rp(0)',
                  style: MyStyles.inputTextStyle,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  alignment: Alignment.center,
                  child: RpList(
                    list: data.drugRps,
                    onAdd: (addList) {
                      data.drugRps = [...addList];
                      changeDataNotify();
                    },
                    onItemQuantityChange: (item, value) {
                      changeDataNotify();
                    },
                    onItemDelete: (val) {
                      changeDataNotify();
                    },
                    onItemEdit: (val) {
                      changeDataNotify();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: ThemeColor.colorFFF3F5F8,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: AceButton(
                  width: 310,
                  text: '确认',
                  onPressed: submitData,
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
