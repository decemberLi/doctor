import 'package:common_utils/common_utils.dart';
import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/clinica_diag_input.dart';
import 'package:doctor/pages/prescription/widgets/prescripion_card.dart';
import 'package:doctor/pages/prescription/widgets/prescription_create_btn.dart';
import 'package:doctor/pages/prescription/widgets/prescription_template_sheet.dart';
import 'package:doctor/pages/prescription/widgets/rp_list.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/Radio_row.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/image_upload.dart';
import 'package:doctor/widgets/remove_button.dart';
import 'package:doctor/widgets/sex_radio_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 开处方主页面
class PrescriptionPage extends StatefulWidget {
  final String title;
  final bool showActicons;

  PrescriptionPage({
    this.title: '开处方',
    this.showActicons = true,
  });

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 显示临床诊断弹窗
  Future<void> _showClinicalDiagnosisSheet(Function onSave) {
    return CommonModal.showBottomSheet(
      context,
      title: '临床诊断',
      height: 550,
      child: ClinicaDiagInput(onSave: (String value) {
        onSave(value);
        Navigator.pop(context);
      }),
    );
  }

  // 显示药品添加弹窗
  Future<void> _showPrescriptionTemplateSheet(Function onSave) {
    return CommonModal.showBottomSheet(
      context,
      title: '处方模板',
      child: PrescriptionTemplateList(
        onSelected: (PrescriptionTemplateModel data) {
          onSave(data);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<bool> _showConsultationDialog() {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("患者必须为复诊才能开处方"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "确定",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  renderBottomBtns() {
    return Consumer<PrescriptionViewModel>(builder: (_, model, __) {
      if (model.data.prescriptionNo != null) {
        return AceButton(
          text: '重新提交',
          onPressed: () {
            model.updatePrescription(() {
              Navigator.of(context).pop(true);
            });
          },
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AceButton(
            width: 138,
            type: AceButtonType.grey,
            textColor: Colors.white,
            text: '预览处方',
            onPressed: () {
              if (model.validateData()) {
                Navigator.of(context)
                    .pushNamed(RouteManager.PRESCRIPTION_PREVIEW);
              }
            },
          ),
          PrescriptionCreateBtn(),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonStack(
      appBar: AppBar(
        title: Text(
          widget.title ?? '',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (widget.showActicons)
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteManager.PRESCRIPTION_LIST);
              },
              child: Text(
                '处方记录',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Consumer<PrescriptionViewModel>(
        builder: (_, model, __) {
          return Container(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              children: [
                if (model.data?.status == 'REJECT')
                  Container(
                    padding: EdgeInsets.only(right: 30, bottom: 20),
                    child: Text(
                      '未通过原因：${model.data?.reason ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                PrescripionCard(
                  title: '患者信息',
                  trailing: GestureDetector(
                    child: Text(
                      '快速开方',
                      style: MyStyles.primaryTextStyle_12,
                    ),
                    onTap: () async {
                      var patientUserId = await Navigator.of(context).pushNamed(
                        RouteManager.PATIENT,
                        arguments: 'QUICK_CREATE',
                      );
                      if (patientUserId != null) {
                        model.getDataByPatient(patientUserId);
                      }
                    },
                  ),
                  children: [
                    FormItem(
                      label: '姓名',
                      // height: 44.0,
                      child: TextFormField(
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入患者姓名',
                          counterText: '',
                        ),
                        maxLength: 6,
                        validator: (val) => val.length < 1 ? '姓名不能为空' : null,
                        onChanged: (String value) {
                          model.data.prescriptionPatientName = value;
                          // model.changeDataNotify();
                        },
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        style: MyStyles.inputTextStyle,
                        textAlign: TextAlign.right,
                      )..controller.text =
                          model.data.prescriptionPatientName ?? '',
                    ),
                    FormItem(
                      label: '年龄',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入患者年龄',
                          counterText: '',
                        ),
                        controller: TextEditingController(),
                        validator: (val) => val.length < 1 ? '年龄不能为空' : null,
                        onChanged: (String value) {
                          if (value.isEmpty) {
                            model.data.prescriptionPatientAge = null;
                            return;
                          }
                          model.data.prescriptionPatientAge = int.parse(value);
                          // model.changeDataNotify();
                        },
                        obscureText: false,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        style: MyStyles.inputTextStyle,
                        textAlign: TextAlign.right,
                      )..controller.text =
                          model.data?.prescriptionPatientAge?.toString() ?? '',
                    ),
                    FormItem(
                      label: '性别',
                      child: SexRadioRow(
                          groupValue: model.data.prescriptionPatientSex,
                          onChanged: (int value) {
                            model.data.prescriptionPatientSex = value;
                          }),
                    ),
                  ],
                ),
                PrescripionCard(
                  title: '临床诊断',
                  trailing: GestureDetector(
                    child: Text(
                      '处方模板',
                      style: MyStyles.primaryTextStyle_12,
                    ),
                    onTap: () {
                      _showPrescriptionTemplateSheet(model.addByTemplate);
                    },
                  ),
                  children: [
                    FormItem(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                      child: Wrap(
                        spacing: 16.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.start,
                        children: [
                          ...model.clinicaList
                              .map(
                                (e) => RemoveButton(
                                  text: e,
                                  onPressed: () {
                                    model.removeClinica(
                                        model.clinicaList.indexOf(e));
                                  },
                                ),
                              )
                              .toList(),
                          AceButton(
                            type: AceButtonType.secondary,
                            onPressed: () {
                              _showClinicalDiagnosisSheet(model.addClinica);
                            },
                            text: '添加诊断',
                            width: 60,
                            height: 30,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                PrescripionCard(
                  title: 'Rp(${model.data.drugRps.length})',
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                  children: [
                    RpList(
                      list: model.data.drugRps,
                      onAdd: (addList) {
                        model.data.drugRps = [...addList];
                        model.changeDataNotify();
                      },
                      onItemQuantityChange: (item, value) {
                        model.changeDataNotify();
                      },
                      onItemDelete: (val) {
                        model.changeDataNotify();
                      },
                      onItemEdit: (val) {
                        model.changeDataNotify();
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '价格',
                            style: MyStyles.inputTextStyle_12
                                .copyWith(fontSize: 18),
                          ),
                          Text(
                            '${MoneyUtil.changeF2YWithUnit(model.totalPrice.toInt(), unit: MoneyUnit.YUAN)}',
                            style: TextStyle(
                              color: Color(0xFFFE4B40),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                PrescripionCard(
                  title: '纸质处方图片上传',
                  children: [
                    ImageUpload(
                      images: model.data?.attachments ?? [],
                      customUploadImageType: 'PRESCRIPTION_PAPER',
                      onChange: (newImages) {
                        model.data.attachments = newImages;
                        // model.changeDataNotify();
                      },
                    ),
                  ],
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 16),
                ),
                PrescripionCard(
                  title: '是否为复诊患者',
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RadioRow(
                        title: Text(
                          '是',
                          style: MyStyles.inputTextStyle,
                        ),
                        value: true,
                        groupValue: model.data.furtherConsultation,
                        onChanged: (bool value) {
                          model.data.furtherConsultation = value;
                        },
                      ),
                      RadioRow(
                        title: Text(
                          '否',
                          style: MyStyles.inputTextStyle,
                        ),
                        value: false,
                        groupValue: model.data.furtherConsultation,
                        onChanged: (bool value) {
                          _showConsultationDialog();
                        },
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 35,
                    bottom: 60,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  alignment: Alignment.center,
                  child: renderBottomBtns(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
