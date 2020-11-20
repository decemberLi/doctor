import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 临床诊断输入框
class ClinicaDiagInput extends StatelessWidget {
  final Function onSave;
  String _input;
  ClinicaDiagInput({
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TextFormField(
              initialValue: '',
              onFieldSubmitted: (String value) {
                if (value == '' || value == null) {
                  EasyLoading.showToast('临床诊断不能为空');
                  return;
                }
                if (value.length > 15) {
                  EasyLoading.showToast('临床诊断字数不能超过15字');
                  return;
                }
                this.onSave(value);
              },
              decoration: InputDecoration(
                hintText: '填写疾病诊断',
                border: InputBorder.none,
                counterText: '',
                suffixIcon: _suffixWidget(),
              ),
              // maxLength: 15,
              obscureText: false,
              keyboardType: TextInputType.text,
              style: MyStyles.inputTextStyle,
              onChanged: (String value) {
                _input = value;
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(height: 10),
          // AceButton(
          //   type: AceButtonType.secondary,
          //   onPressed: () {
          //     if (input == '' || input == null) {
          //       EasyLoading.showToast('临床诊断不能为空');
          //       return;
          //     }
          //     if (input.length > 15) {
          //       EasyLoading.showToast('临床诊断字数不能超过15字');
          //       return;
          //     }
          //     this.onSave(input);
          //   },
          //   width: 62,
          //   height: 30,
          //   text: '添加',
          //   fontSize: 10,
          // ),
        ],
      ),
    );
  }

  _suffixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          child: Image.asset('assets/images/close.png',width: 20,height: 20,),
          onTap: () {
            onSave(null);
          },
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                border: Border.all(color: ThemeColor.primaryColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            child: Text('添加'),
          ),
          onTap: () {
            onSave(_input);
          },
        )
      ],
    );
  }
}
