import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:doctor/widgets/common_spinner_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class DropDownSelectInput extends StatefulWidget {
  final String label;
  final String value;
  final List data;
  final ValueChanged<String> onChange;
  DropDownSelectInput({
    this.label,
    this.value,
    this.data,
    this.onChange,
  });

  @override
  _DropDownSelectInputState createState() => _DropDownSelectInputState();
}

class _DropDownSelectInputState extends State<DropDownSelectInput> {
  showPickerModal(BuildContext context) {
    List<PickerItem<String>> listData = widget.data
        .map(
          (e) => new PickerItem<String>(
            text: Text(
              e,
              textAlign: TextAlign.center,
            ),
            value: e,
          ),
        )
        .toList();
    Picker(
        title: Text(
          '选择${widget.label}',
          style: TextStyle(fontSize: 18),
        ),
        height: 200,
        columnPadding: EdgeInsets.all(30),
        itemExtent: 40,
        adapter: PickerDataAdapter<String>(data: listData),
        changeToFirst: true,
        cancelText: '取消',
        confirmText: '确认',
        cancelTextStyle:
            TextStyle(color: ThemeColor.primaryColor, fontSize: 18),
        confirmTextStyle:
            TextStyle(color: ThemeColor.primaryColor, fontSize: 18),
        onConfirm: (Picker picker, List value) {
          widget.onChange(picker.getSelectedValues()[0]);
        }).showModal(context); //_scaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
      // width: 120.0,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF979797)),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: MyStyles.inputTextStyle_12,
            ),
            IconTheme(
              data: IconThemeData(
                color: Colors.grey.shade700,
                size: 24,
              ),
              child: Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
        onTap: () {
          this.showPickerModal(context);
        },
      ),
    );
  }
}

/// 添加药品弹窗内容
class MedicationAddSheet extends StatefulWidget {
  final DrugModel item;
  final Function onSave;
  MedicationAddSheet(this.item, {this.onSave});

  // 显示弹窗
  static Future<void> show(
      BuildContext context, DrugModel data, Function onSave) {
    return CommonModal.showBottomSheet(
      context,
      title: '编辑药品用法用量',
      height: 500,
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
  _MedicationAddSheetState createState() => _MedicationAddSheetState();
}

class _MedicationAddSheetState extends State<MedicationAddSheet> {
  String frequency = FREQUENCY_LIST[0];

  String doseUnit = DOSEUNIT_LIST[0];

  String singleDose = '1';

  String usePattern = USEPATTERN_LIST[0];

  double quantity;

  initialize() {
    frequency = widget.item.frequency ?? FREQUENCY_LIST[0];
    singleDose = widget.item.singleDose ?? '1';
    doseUnit = widget.item.doseUnit ?? DOSEUNIT_LIST[0];
    usePattern = widget.item.usePattern ?? USEPATTERN_LIST[0];
    quantity = widget.item.quantity != null ? widget.item.quantity + .0 : 1;
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
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
                      '单次剂量：',
                      style: MyStyles.inputTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      width: 50,
                      height: 32,
                      margin: EdgeInsets.only(left: 10, top: 4, bottom: 4),
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
                    DropDownSelectInput(
                      label: '剂量单位',
                      value: this.doseUnit,
                      data: DOSEUNIT_LIST,
                      onChange: (String value) {
                        setState(() {
                          this.doseUnit = value;
                        });
                      },
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
                      '用药频率：',
                      style: MyStyles.inputTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    DropDownSelectInput(
                      label: '用药频率',
                      value: this.frequency,
                      data: FREQUENCY_LIST,
                      onChange: (String value) {
                        setState(() {
                          this.frequency = value;
                        });
                      },
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 10),
                    //   padding: EdgeInsets.only(
                    //       left: 10, right: 4, top: 4, bottom: 4),
                    //   // width: 120.0,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: ThemeColor.colorFFBCBCBC),
                    //     borderRadius:
                    //         const BorderRadius.all(Radius.circular(4.0)),
                    //   ),
                    //   child: GestureDetector(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text(
                    //           this.frequency,
                    //           style: MyStyles.inputTextStyle_12,
                    //         ),
                    //         IconTheme(
                    //           data: IconThemeData(
                    //             color: Colors.grey.shade700,
                    //             size: 24,
                    //           ),
                    //           child: Icon(Icons.arrow_drop_down),
                    //         ),
                    //       ],
                    //     ),
                    //     onTap: () {
                    //       this.showPickerModal(context, '用药频率');
                    //     },
                    //   ),
                    // child: DropdownButton(
                    //   isExpanded: true,
                    //   value: this.frequency,
                    //   items: [
                    //     ...FREQUENCY_LIST
                    //         .map(
                    //           (e) => DropdownMenuItem(
                    //             value: e,
                    //             child: Text(e),
                    //           ),
                    //         )
                    //         .toList(),
                    //   ],
                    //   onChanged: (value) {
                    //     setState(() {
                    //       this.frequency = value;
                    //     });
                    //   },
                    // ),
                    // ),
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
                      '给药途径：',
                      style: MyStyles.inputTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    DropDownSelectInput(
                      label: '给药途径',
                      value: this.usePattern,
                      data: USEPATTERN_LIST,
                      onChange: (String value) {
                        setState(() {
                          this.usePattern = value;
                        });
                      },
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
                text: '确认加入处方笺',
                onPressed: () {
                  widget.item.frequency = frequency;
                  widget.item.singleDose = singleDose;
                  widget.item.doseUnit = doseUnit;
                  widget.item.usePattern = usePattern;
                  widget.item.quantity = this.quantity;
                  widget.onSave();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
