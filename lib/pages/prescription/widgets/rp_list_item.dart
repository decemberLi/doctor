import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/medication/widgets/medication_add_sheet.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/common_spinner_input.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:flutter/material.dart';

/// 处方药列表项
class RpListItem extends StatelessWidget {
  final int index;

  final DrugModel data;

  final Function onDelete;
  final Function onQuantityChange;
  final Function onEdit;
  RpListItem({
    Key key,
    this.index,
    this.data,
    this.onDelete,
    this.onEdit,
    this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
    return FormItem(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      // height: 95.0,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.drugName,
                  style: MyStyles.inputTextStyle_12,
                ),
                Text(
                  '规格： ${data.drugSize}',
                  style: MyStyles.labelTextStyle_12,
                ),
                Text(
                  '用法用量：${data.useInfo}',
                  style: MyStyles.inputTextStyle_12,
                ),
              ],
            ),
          ),
          Container(
            width: 100.0,
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        MedicationAddSheet.show(context, data, () {
                          onEdit(data);
                        });
                      },
                      child: Text(
                        '编辑',
                        style: MyStyles.primaryTextStyle_12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onDelete(data);
                      },
                      child: Text(
                        '删除',
                        style: MyStyles.primaryTextStyle_12,
                      ),
                    ),
                  ],
                ),
                AceSpinnerInput(
                  spinnerValue: data.quantity + .0 ?? 1,
                  onChange: (newValue) {
                    data.quantity = newValue;
                    onQuantityChange(newValue);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
