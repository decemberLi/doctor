import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_spinner_input.dart';
import 'package:flutter/material.dart';

List<String> frequencyList = ['每日一次', '每日两次', '每日三次'];

List<String> doseUnitList = ['片/次', '颗/次'];

List<String> usePatternList = ['口服', '冲服', '硬塞'];

/// 添加药品弹窗内容
class MedicationAddSheet extends StatefulWidget {
  final DrugModel item;
  final Function onSave;
  MedicationAddSheet(this.item, {this.onSave});

  @override
  _MedicationAddSheetState createState() => _MedicationAddSheetState();
}

class _MedicationAddSheetState extends State<MedicationAddSheet> {
  String frequency = frequencyList[0];

  String doseUnit = doseUnitList[0];

  String singleDose = '1';

  String usePattern = usePatternList[0];

  double quantity;

  initialize() {
    frequency = widget.item.frequency ?? frequencyList[0];
    singleDose = widget.item.singleDose ?? '1';
    doseUnit = widget.item.doseUnit ?? doseUnitList[0];
    usePattern = widget.item.usePattern ?? usePatternList[0];
    quantity = double.parse(widget.item.quantity ?? '1');
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(MedicationAddSheet oldWidget) {
    initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '药品名称：${widget.item.drugName ?? ''}',
                style: MyStyles.inputTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '规格：${widget.item.drugSize ?? ''}',
                style: MyStyles.inputTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    '用药频率：',
                    style: MyStyles.inputTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 100.0,
                    child: DropdownButton(
                      isExpanded: true,
                      value: this.frequency,
                      items: [
                        ...frequencyList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          this.frequency = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    '单次剂量：',
                    style: MyStyles.inputTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    width: 50,
                    height: 30,
                    margin: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      initialValue: singleDose,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF979797),
                          ),
                          gapPadding: 0,
                        ),
                        contentPadding: EdgeInsets.all(6),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          singleDose = value;
                        });
                      },
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      style: MyStyles.inputTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 100.0,
                    child: DropdownButton(
                      isExpanded: true,
                      value: this.doseUnit,
                      items: [
                        ...doseUnitList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          this.doseUnit = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    '用药途径：',
                    style: MyStyles.inputTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 100.0,
                    child: DropdownButton(
                      isExpanded: true,
                      value: this.usePattern,
                      items: [
                        ...usePatternList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          this.usePattern = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    '数量：',
                    style: MyStyles.inputTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 100.0,
                    child: AceSpinnerInput(
                      spinnerValue: this.quantity,
                      onChange: (newValue) {
                        setState(() {
                          // widget.item.quantity = newValue.toStringAsFixed(0);
                          this.quantity = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: 20,
            ),
            AceButton(
              text: '确认',
              onPressed: () {
                widget.item.frequency = frequency;
                widget.item.singleDose = singleDose;
                widget.item.doseUnit = doseUnit;
                widget.item.usePattern = usePattern;
                widget.item.quantity = this.quantity.toStringAsFixed(0);
                widget.onSave();
              },
            ),
          ],
        ),
      ),
    );
  }
}
