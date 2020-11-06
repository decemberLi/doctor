import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_status.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:flutter/material.dart';

class PrescripionListItem extends StatelessWidget {
  final PrescriptionModel data;
  PrescripionListItem(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: ThemeColor.primaryColor, width: 12.0),
            ),
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                // decoration: BoxDecoration(
                //   color: Colors.transparent,
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(16),
                //   ),
                // ),
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 40,
                      child: Text(
                        '诊疗时间：${data.createTimeText}',
                        style: MyStyles.inputTextStyle_12,
                      ),
                    ),
                    FormItem(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '姓名: ${data.prescriptionPatientName}',
                            style: MyStyles.inputTextStyle,
                          ),
                          Text(
                            '性别: ${data.prescriptionPatientSexLabel}',
                            style: MyStyles.inputTextStyle,
                          ),
                          Text(
                            '年龄: ${data.prescriptionPatientAge}',
                            style: MyStyles.inputTextStyle,
                          ),
                        ],
                      ),
                    ),
                    FormItem(
                      height: 40,
                      child: Text(
                        '诊断：${data.clinicalDiagnosis}',
                        style: MyStyles.inputTextStyle,
                      ),
                    ),
                    FormItem(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '处方详情：',
                                    style: MyStyles.inputTextStyle,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    data.prescriptionNo ?? '',
                                    style: MyStyles.labelTextStyle_12,
                                  ),
                                ],
                              ),
                              PrescriptionStatus(data),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ...data.drugRps
                              .map(
                                (e) => Container(
                                  margin: EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${data.drugRps.indexOf(e) + 1}、${e.drugName}',
                                        style: MyStyles.inputTextStyle_12,
                                      ),
                                      Text(
                                        'X${e.quantity}',
                                        style: MyStyles.inputTextStyle_12,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 10,
                child: Image.asset(
                  'assets/images/${data.orderStatusImage}',
                  width: 90,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
