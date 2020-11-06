import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spinner_input/spinner_input.dart';

class AceSpinnerInput extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double step;
  final double middleNumberWidth;
  final double spinnerValue;

  final Function(double newValue) onChange;
  AceSpinnerInput({
    this.minValue = 1,
    this.maxValue = 99,
    this.step = 1,
    this.middleNumberWidth = 40,
    this.spinnerValue,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SpinnerInput(
        minValue: this.minValue,
        maxValue: this.maxValue,
        step: this.step,
        plusButton: SpinnerButtonStyle(
          elevation: 0,
          width: 20,
          height: 20,
          color: Colors.transparent,
          child: Icon(
            Icons.add_circle,
            size: 20,
            color: ThemeColor.primaryColor,
          ),
        ),
        minusButton: SpinnerButtonStyle(
          elevation: 0,
          width: 20,
          height: 20,
          color: Colors.transparent,
          child: Icon(
            Icons.remove_circle_outline,
            size: 20,
            color: ThemeColor.primaryColor,
          ),
        ),
        middleNumberWidth: this.middleNumberWidth,
        spinnerValue: this.spinnerValue,
        onChange: (double value) {
          // if (value < minValue) {
          //   EasyLoading.showToast('数量不能小于1');
          // }
          this.onChange(value);
        });
  }
}
