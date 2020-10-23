import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_status.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class PerscriptionDetail extends StatelessWidget {
  final PrescriptionModel data;
  PerscriptionDetail(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: [
          Container(
            child: Row(
              children: [
                // PrescriptionStatus(data),
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
        ],
      ),
    );
  }
}
