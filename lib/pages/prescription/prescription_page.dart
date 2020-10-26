import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/clinica_diag_input.dart';
import 'package:doctor/pages/prescription/widgets/prescripion_card.dart';
import 'package:doctor/pages/prescription/widgets/prescription_create_btn.dart';
import 'package:doctor/pages/prescription/widgets/prescription_template_sheet.dart';
import 'package:doctor/pages/prescription/widgets/rp_list.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/Radio_row.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/image_upload.dart';
import 'package:doctor/widgets/remove_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 开处方主页面
class PrescriptionPage extends StatefulWidget {
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String val = '';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommonStack(
      appBar: AppBar(
        title: Text(
          "开处方",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
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
      body: Consumer<PrescriptionViewModel>(builder: (_, model, __) {
        return Container(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            children: [
              PrescripionCard(
                title: '患者信息',
                trailing: TextButton(
                  child: Text(
                    '快速开方',
                    style: MyStyles.primaryTextStyle_12,
                  ),
                  onPressed: () {
                    print(222);
                  },
                ),
                children: [
                  FormItem(
                    label: '姓名',
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      initialValue: model.data.prescriptionPatientName,
                      validator: (val) => val.length < 1 ? '姓名不能为空' : null,
                      onSaved: (val) => {print(val)},
                      onChanged: (String value) {
                        model.data.prescriptionPatientName = value;
                        model.changeDataNotify();
                      },
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      style: MyStyles.inputTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  FormItem(
                    label: '年龄',
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: (val) => val.length < 1 ? '年龄不能为空' : null,
                      onSaved: (val) => {print(val)},
                      onChanged: (String value) {
                        model.data.prescriptionPatientAge = int.parse(value);
                        model.changeDataNotify();
                      },
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      style: MyStyles.inputTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  FormItem(
                    label: '性别',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RadioRow(
                          title: Text(
                            '男',
                            style: MyStyles.inputTextStyle,
                          ),
                          value: 1,
                          groupValue: model.data.prescriptionPatientSex,
                          onChanged: (int value) {
                            model.data.prescriptionPatientSex = value;
                            model.changeDataNotify();
                          },
                        ),
                        RadioRow(
                          title: Text(
                            '女',
                            style: MyStyles.inputTextStyle,
                          ),
                          value: 0,
                          groupValue: model.data.prescriptionPatientSex,
                          onChanged: (int value) {
                            model.data.prescriptionPatientSex = value;
                            model.changeDataNotify();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PrescripionCard(
                title: '临床诊断',
                trailing: TextButton(
                  child: Text(
                    '处方模板',
                    style: MyStyles.primaryTextStyle_12,
                  ),
                  onPressed: () {
                    _showPrescriptionTemplateSheet(model.addByTemplate);
                  },
                ),
                children: [
                  FormItem(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
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
                title: 'RP(${model.data.drugRps.length})',
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
                          style:
                              MyStyles.inputTextStyle_12.copyWith(fontSize: 18),
                        ),
                        Text(
                          '￥${model.totalPrice}',
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
                    onChange: (_) {
                      model.changeDataNotify();
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
                      value: '1',
                      groupValue: model.data.furtherConsultation,
                      onChanged: (String value) {
                        model.data.furtherConsultation = value;
                        model.changeDataNotify();
                      },
                    ),
                    RadioRow(
                      title: Text(
                        '否',
                        style: MyStyles.inputTextStyle,
                      ),
                      value: '0',
                      groupValue: model.data.furtherConsultation,
                      onChanged: (String value) {
                        model.data.furtherConsultation = value;
                        model.changeDataNotify();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AceButton(
                      width: 138,
                      type: AceButtonType.grey,
                      textColor: Colors.white,
                      text: '预览处方',
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.PRESCRIPTION_PREVIEW);
                      },
                    ),
                    PrescriptionCreateBtn(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
