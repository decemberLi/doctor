import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/medication/widgets/medication_add_sheet.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:doctor/widgets/common_spinner_input.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/one_line_text.dart';
import 'package:flutter/material.dart';

/// 药品项
class MedicationItem extends StatelessWidget {
  final int index;

  final DrugModel data;

  final Function onDelete;
  final Function onQuantityChange;
  final Function onEdit;
  MedicationItem({
    Key key,
    this.index,
    this.data,
    this.onDelete,
    this.onEdit,
    this.onQuantityChange,
  });

  // 显示药品编辑弹窗
  Future<void> _showMedicationInfoSheet(BuildContext context, Function onSave) {
    return CommonModal.showBottomSheet(
      context,
      title: '药品用法用量',
      height: 560,
      child: MedicationAddSheet(
        data,
        onSave: () {
          onSave();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormItem(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      height: 95.0,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OneLineText(
                  data.drugName,
                  style: MyStyles.inputTextStyle_12,
                ),
                OneLineText(
                  '规格： ${data.drugSize}',
                  style: MyStyles.labelTextStyle_12,
                ),
                OneLineText(
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
                        _showMedicationInfoSheet(context, () {
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
                  spinnerValue: double.parse(data.quantity ?? '1'),
                  onChange: (newValue) {
                    String strValue = newValue.toStringAsFixed(0);
                    data.quantity = strValue;
                    onQuantityChange(strValue);
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
