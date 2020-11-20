import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/medication/view_model/medication_view_model.dart';
import 'package:doctor/pages/medication/widgets/medication_add_sheet.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_spinner_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 药品添加按钮
class MedicationAddBtn extends StatelessWidget {
  final DrugModel data;

  MedicationAddBtn(this.data);

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationViewModel>(
        builder: (context, MedicationViewModel model, child) {
      double _quantity = data.quantity != null ? data.quantity + .0 : 0;
      if (_quantity == 0) {
        return AceButton(
          width: 100,
          height: 30,
          fontSize: 14,
          text: '加入处方笺',
          onPressed: () {
            MedicationAddSheet.show(context, data, () {
              model.addToCart(data);
            });
          },
        );
      }
      return AceSpinnerInput(
        minValue: 0,
        maxValue: data.purchaseLimit,
        spinnerValue: _quantity,
        onChange: (newValue) {
          if (newValue == 0) {
            data.quantity = null;
            model.cartList.remove(data);
          } else {
            data.quantity = newValue;
          }
          model.changeDataNotify();
        },
      );
    });
  }
}
