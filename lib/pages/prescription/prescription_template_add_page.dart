import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/service/service.dart';
import 'package:doctor/pages/prescription/widgets/rp_list.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/app_regex_util.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      if (data.drugRps == null || data.drugRps.isEmpty) {
        EasyLoading.showToast('请添加药品信息');
        return;
      }
      form.save();
      try {
        var res = await addPrescriptionTemplate(this.data.toJson());
        if (!(res is DioError)) {
          Navigator.pop(context, true);
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('添加处方模板'),
          ),
          // 避免键盘弹起时高度错误
          resizeToAvoidBottomInset: false,
          body: Form(
            key: _formKey, //设置globalKey，用于后面获取FormState
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              color: ThemeColor.colorFFF3F5F8,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(16),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '模板名称',
                    style: MyStyles.inputTextStyle,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    initialValue: data.prescriptionTemplateName ?? '',
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      hintText: '请填写模板名称',
                    ),
                    maxLength: 15,
                    validator: (val) {
                      if (val.length < 1) {
                        return '名称不能为空';
                      }
                      if (val.length > 15) {
                        return '名称超过15个字符';
                      }
                      if (AppRegexUtil.isSpecialChart(val)) {
                        return '名称不能含有特殊字符';
                      }
                      return null;
                    },
                    onSaved: (val) => {data.prescriptionTemplateName = val},
                    keyboardType: TextInputType.text,
                    style: MyStyles.inputTextStyle,
                    // onChanged: (value) {
                    //   setState(() {
                    //     data.prescriptionTemplateName = value;
                    //   });
                    // },
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
                  TextFormField(
                    initialValue: data.clinicalDiagnosis ?? '',
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      hintText: '请填写临床诊断',
                    ),
                    maxLength: 15,
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
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Rp(${data.drugRps.length})',
                    style: MyStyles.inputTextStyle,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    // color: Colors.white,
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
      ),
    );
  }
}
