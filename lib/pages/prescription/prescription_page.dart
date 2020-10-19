import 'package:doctor/pages/prescription/widgets/medication_item.dart';
import 'package:doctor/pages/prescription/widgets/prescripion_card.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/Radio_row.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 开处方主页面
class PrescriptionPage extends StatefulWidget {
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  int _sex = 1;
  int _visit = 1;

  List medicationList = [1, 2, 3];

  // 显示临床诊断弹窗
  Future<int> _showModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(color: Colors.white, height: 350);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonStack(
      appBar: AppBar(
        title: Text(
          "开处方",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 跳转处方记录
              print('1111');
            },
            child: Text(
              '处方记录',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          children: [
            PrescripionCard(
              title: '患者信息',
              trailing: TextButton(
                child: Text(
                  '快速开方',
                  style: MyStyles.primaryTextStyle_12,
                ),
                onPressed: () {
                  print(222);
                },
              ),
              children: [
                FormItem(
                  label: '姓名',
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (val) => val.length < 1 ? '姓名不能为空' : null,
                    onSaved: (val) => {print(val)},
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    style: MyStyles.inputTextStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
                FormItem(
                  label: '年龄',
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (val) => val.length < 1 ? '年龄不能为空' : null,
                    onSaved: (val) => {print(val)},
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    style: MyStyles.inputTextStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
                FormItem(
                  label: '性别',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RadioRow(
                        title: Text(
                          '男',
                          style: MyStyles.inputTextStyle,
                        ),
                        value: 1,
                        groupValue: _sex,
                        onChanged: (int value) {
                          setState(() {
                            _sex = value;
                          });
                        },
                      ),
                      RadioRow(
                        title: Text(
                          '女',
                          style: MyStyles.inputTextStyle,
                        ),
                        value: 0,
                        groupValue: _sex,
                        onChanged: (int value) {
                          setState(() {
                            _sex = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            PrescripionCard(
              title: '临床诊断',
              trailing: TextButton(
                child: Text(
                  '处方模板',
                  style: MyStyles.primaryTextStyle_12,
                ),
                onPressed: () {
                  print(222);
                },
              ),
              children: [
                FormItem(
                    child: Row(
                  children: [
                    FlatButton(
                      color: ThemeColor.primaryColor.withOpacity(0.5),
                      child: Text(
                        '添加诊断',
                        style: MyStyles.primaryTextStyle_10.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: _showModalBottomSheet,
                      minWidth: 60,
                      height: 30,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                    ),
                  ],
                ))
              ],
            ),
            PrescripionCard(
              title: '药品信息',
              padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
              children: [
                ...this
                    .medicationList
                    .map((e) => MedicationItem(
                          index: this.medicationList.indexOf(e),
                          onDelete: (int index) {
                            setState(() {
                              this.medicationList.removeAt(index);
                            });
                          },
                        ))
                    .toList(),
                Container(
                  width: 295,
                  height: 42,
                  child: FlatButton(
                    onPressed: () {},
                    color: ThemeColor.primaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: ThemeColor.primaryColor,
                        ),
                        Text(
                          '添加药品',
                          style: TextStyle(
                              color: ThemeColor.primaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 6,
                        color: Color(0xFFDB1818),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '国家规定，对首处患者进行医疗行为时，必须当面诊查。',
                        style:
                            MyStyles.labelTextStyle_12.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '价格',
                        style:
                            MyStyles.inputTextStyle_12.copyWith(fontSize: 18),
                      ),
                      Text(
                        '￥896',
                        style: TextStyle(
                          color: Color(0xFFFE4B40),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            PrescripionCard(
              title: '纸质处方图片上传',
              children: [],
            ),
            PrescripionCard(
              title: '是否为复诊患者',
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RadioRow(
                    title: Text(
                      '是',
                      style: MyStyles.inputTextStyle,
                    ),
                    value: 1,
                    groupValue: _visit,
                    onChanged: (int value) {
                      setState(() {
                        _visit = value;
                      });
                    },
                  ),
                  RadioRow(
                    title: Text(
                      '否',
                      style: MyStyles.inputTextStyle,
                    ),
                    value: 0,
                    groupValue: _visit,
                    onChanged: (int value) {
                      setState(() {
                        _visit = value;
                      });
                    },
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            ),
          ],
        ),
      ),
    );
  }
}
