import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/patient/model/patient_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:flutter/material.dart';

class PatientListItem extends StatelessWidget {
  final PatientModel data;
  PatientListItem(this.data);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    width: 42,
                    height: 42,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.patientName ?? '',
                                style: MyStyles.boldTextStyle_16,
                              ),
                              Text(
                                '${DateUtil.formatDateMs(data.diagnosisTime, format: 'yyyy.MM.dd HH:mm')}',
                                style: MyStyles.inputTextStyle_12_grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Text(
                            '${data.sexLabel} | ${data.age}岁',
                            style: MyStyles.inputTextStyle_12_grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              alignment: Alignment.topLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 12,
                runSpacing: 12,
                children: data.diseaseNameList
                    .map(
                      (e) => Container(
                        padding: EdgeInsets.only(
                            left: 12, right: 12, top: 2, bottom: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xff3AA7FF),
                          ),
                        ),
                        constraints: BoxConstraints(minWidth: 65),
                        child: Text(
                          e,
                          style: TextStyle(
                            color: Color(0xff3AA7FF),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
