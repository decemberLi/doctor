import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_status.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/one_line_text.dart';
import 'package:flutter/material.dart';

class PerscriptionDetail extends StatelessWidget {
  final PrescriptionModel data;
  PerscriptionDetail(this.data);

  List<Widget> renderRp() {
    if (data == null || data.drugRps.isEmpty) {
      return [];
    }
    return data?.drugRps
        ?.map(
          (e) => Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(
                  height: 6,
                ),
                Text(
                  '规格：${e.drugSize}',
                  style: MyStyles.greyTextStyle_12,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  '用法用量：${e.useInfo}',
                  style: MyStyles.inputTextStyle_12,
                ),
              ],
            ),
          ),
        )
        ?.toList();
  }

  List<Widget> renderImages() {
    if (data == null || data.attachments == null || data.attachments.isEmpty) {
      return [];
    }
    return data.attachments
        .map(
          (e) => Image.network(
            e.url,
            width: 74,
            fit: BoxFit.fitWidth,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // if (data == null) {
    //   return Container();
    // }
    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrescriptionStatus(data),
                  Column(
                    children: [
                      Text(
                        '易问询互联网医院',
                        style: MyStyles.primaryTextStyle,
                      ),
                      Text(
                        '电子处方笺',
                        style: MyStyles.primaryTextStyle_bold,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: ThemeColor.primaryColor),
                    ),
                    child: Text(
                      '普通',
                      style: MyStyles.primaryTextStyle_12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data?.prescriptionNo ?? '',
                                style: MyStyles.greyTextStyle_12,
                              ),
                              Text(
                                data?.createTimeText ?? '',
                                style: MyStyles.greyTextStyle_12,
                              ),
                            ],
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '姓名：${data?.prescriptionPatientName ?? ''}',
                                style: MyStyles.inputTextStyle,
                              ),
                              Text(
                                '性别：${data?.prescriptionPatientSexLabel ?? ''}',
                                style: MyStyles.inputTextStyle,
                              ),
                              Text(
                                '年龄：${data?.prescriptionPatientAge ?? ''}',
                                style: MyStyles.inputTextStyle,
                              ),
                            ],
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '科室：${data?.depart ?? ''}',
                            style: MyStyles.inputTextStyle,
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: OneLineText(
                            '临床诊断：${data?.clinicalDiagnosis ?? ''}',
                            style: MyStyles.inputTextStyle,
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rp:',
                                style: MyStyles.inputTextStyle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...renderRp(),
                            ],
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '纸质处方图片',
                                style: MyStyles.inputTextStyle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 6,
                                runSpacing: 10,
                                children: renderImages(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '特别提醒',
                                style: MyStyles.greyTextStyle_12,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '1、处方有效期为3天，请及时取药。',
                                style: MyStyles.greyTextStyle_12,
                              ),
                              Text(
                                '2、按照卫生部、国家中药管理局卫医发[2002]24号文件规定：为保证患者用药安全，药品一经发出，不得退换。',
                                style: MyStyles.greyTextStyle_12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
