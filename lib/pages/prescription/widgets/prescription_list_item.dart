import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:flutter/material.dart';

class PrescriptionListLitem extends StatelessWidget {
  final PrescriptionModel data;

  PrescriptionListLitem(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        data.prescriptionPatientName,
                        style: MyStyles.inputTextStyle_16,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Text(
                        '${data.prescriptionPatientSexLabel}  |  ${data.prescriptionPatientAge} 岁',
                        style: MyStyles.inputTextStyle_12,
                      ),
                    ],
                  ),
                ),
                ...data.drugRps
                    .map(
                      (e) => FormItem(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.drugFullName,
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
                FormItem(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.createTimeText,
                        style: MyStyles.inputTextStyle_12,
                      ),
                      Text(
                        data.statusText,
                        style: MyStyles.inputTextStyle_12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 30,
            top: 0,
            child: Image.asset(
              'assets/images/${data.orderStatusImage}',
              width: 90,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
