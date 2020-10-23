import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/patient/model/patient_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

class PatientListItem extends StatelessWidget {
  final PatientModel data;
  PatientListItem(this.data);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: Image.asset(
                'assets/images/avatar.png',
                width: 42.0,
                fit: BoxFit.fitWidth,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.patientName ?? '',
                    style: MyStyles.boldTextStyle_16,
                  ),
                  Text(
                    '${data.sexLabel} | ${data.age}岁',
                    style: MyStyles.inputTextStyle_12,
                  ),
                ],
              ),
              trailing: Text(
                '${DateUtil.formatDateMs(int.parse(data.diagnosisTime), format: 'yyyy.MM.dd HH:mm')}',
                style: MyStyles.inputTextStyle_12,
              ),
            ),
            Divider(),
            SizedBox(
              height: 12,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 12,
                runSpacing: 12,
                children: data.diseaseNameList
                    .map(
                      (e) => AceButton(
                        type: AceButtonType.outline,
                        text: e,
                        width: null,
                        height: 26,
                        onPressed: null,
                        fontSize: 14,
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
