import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrescriptionCreateBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PrescriptionViewModel>(
      builder: (_, model, __) {
        return AceButton(
          type: AceButtonType.secondary,
          color: ThemeColor.primaryColor,
          textColor: Colors.white,
          width: 138,
          text: '生成处方',
          onPressed: () {
            model.savePrescription((String prescriptionNo) async {
              await Navigator.of(context).pushNamed(
                RouteManager.PRESCRIPTION_SUCCESS,
                arguments: prescriptionNo,
              );
              model.resetData();
            });
          },
        );
      },
    );
  }
}
