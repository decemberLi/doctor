import 'package:dio/dio.dart';
import 'package:doctor/http/dtp.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/widgets/clinica_diag_input.dart';
import 'package:doctor/pages/prescription/widgets/prescripion_card.dart';
import 'package:doctor/pages/prescription/widgets/rp_list.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/remove_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';

class PrescriptionTemplageAddPage extends StatefulWidget {
  final String action;

  final PrescriptionTemplateModel data;

  bool isAddPrescriptionTemplate() => action == 'add';

  PrescriptionTemplageAddPage({this.action, this.data});

  @override
  _PrescriptionTemplageAddPageState createState() =>
      _PrescriptionTemplageAddPageState();
}

class _PrescriptionTemplageAddPageState
    extends State<PrescriptionTemplageAddPage> {
  PrescriptionTemplateModel data = PrescriptionTemplateModel();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.data != null) {
      this.data = widget.data;
    }
    super.initState();
  }

  changeDataNotify() {
    setState(() {});
  }

  submitData() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      if (data.clinicalDiagnosis == null || data.clinicalDiagnosis == '') {
        EasyLoading.showToast('请选择临床诊断');
        return;
      }
      if (data.drugRps == null || data.drugRps.isEmpty) {
        EasyLoading.showToast('请添加药品信息');
        return;
      }

      if (data.drugRps.length > 5) {
        EasyLoading.showToast('最多只能选择5种药品');
        return;
      }

      form.save();
      try {
        var res;
        if (widget.isAddPrescriptionTemplate()) {
          res = await API.shared.dtp.addPrescriptionTemplate(this.data.toJson());
        } else {
          res = await API.shared.dtp.modifyPrescriptionTemplate(this.data.toJson());
        }
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
            title:
                Text(widget.isAddPrescriptionTemplate() ? '添加处方模板' : '编辑处方模板'),
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
                    enableSuggestions: false,
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
                  PrescripionCard(
                    title: '临床诊断',
                    padding: const EdgeInsets.all(0),
                    color: ThemeColor.colorFFF3F5F8,
                    titleStyle: MyStyles.inputTextStyle,
                    constraints: const BoxConstraints(minHeight: 36),
                    children: [
                      Container(
                        color: ThemeColor.colorFFF3F5F8,
                        child: FormItem(
                          borderDirection: FormItemBorderDirection.bottom,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 8.0,
                            alignment: WrapAlignment.start,
                            children: [
                              ...data.clinicaList
                                  .map(
                                    (e) => RemoveButton(
                                      text: e,
                                      onPressed: () {
                                        setState(() {
                                          data.removeClinica(
                                              data.clinicaList.indexOf(e));
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                              AceButton(
                                type: AceButtonType.secondary,
                                onPressed: () {
                                  _showClinicalDiagnosisSheet((value) {
                                    data.addClinica(value);
                                    setState(() {});
                                  });
                                },
                                text: '添加诊断',
                                width: 60,
                                height: 30,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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

  // 显示临床诊断弹窗
  Future<void> _showClinicalDiagnosisSheet(Function onSave) {
    return CommonModal.showBottomSheet(
      context,
      title: '临床诊断',
      height: 550,
      child: ClinicaDiagInput(onSave: (String value) {
        if (value != null && value != '') {
          onSave(value);
        }
        Navigator.pop(context);
      }),
    );
  }
}
