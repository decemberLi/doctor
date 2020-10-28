import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class PrescriptionStatus extends StatelessWidget {
  final PrescriptionModel data;

  final Map<String, Color> _statusColor = {
    'WAIT_VERIFY': Color(0xFFFFB140),
    'PASS': ThemeColor.primaryColor,
    'REJECT': Color(0xFFFF2727),
    'EXPIRE': ThemeColor.primaryGeryColor,
  };
  PrescriptionStatus(this.data);

  @override
  Widget build(BuildContext context) {
    if (data == null || data.status == null) {
      return Container(
        width: 54,
      );
    }
    Color color = _statusColor[data.status ?? 'WAIT_VERIFY'];
    BorderSide borderSide = BorderSide(color: color, width: 2);
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: borderSide,
          bottom: borderSide,
          left: borderSide,
          right: borderSide,
        ),
      ),
      child: Text(
        data.statusText,
        style: TextStyle(
          color: color,
          fontSize: 14,
        ),
      ),
    );
  }
}
