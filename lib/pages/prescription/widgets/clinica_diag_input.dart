import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 临床诊断输入框
class ClinicaDiagInput extends StatelessWidget {
  final Function onSave;
  ClinicaDiagInput({
    this.onSave,
  });
  @override
  Widget build(BuildContext context) {
    String input;
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (String value) {
              input = value;
            },
            obscureText: false,
            keyboardType: TextInputType.text,
            style: MyStyles.inputTextStyle,
          ),
          Divider(
            height: 1,
          ),
          SizedBox(height: 10),
          AceButton(
            type: AceButtonType.secondary,
            onPressed: () {
              if (input == '' || input == null) {
                // TODO: 改为输入框校验
                EasyLoading.showToast('临床诊断不能为空');
                return;
              }
              this.onSave(input);
            },
            width: 62,
            height: 30,
            text: '添加',
            fontSize: 10,
          ),
        ],
      ),
    );
  }
}
