import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/Radio_row.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:flutter/material.dart';

class PrescripionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget trailing;
  PrescripionCard({
    this.title,
    this.children = const <Widget>[],
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    Widget titleWidget = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      title: Text(
        this.title,
        style: MyStyles.primaryTextStyle.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: this.trailing,
    );
    this.children.insert(0, titleWidget);
    return Card(
      child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
          margin: EdgeInsets.only(bottom: 12.0),
          child: Column(
            children: this.children,
          )),
    );
  }
}

class PrescriptionPage extends StatefulWidget {
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  int _sex = 1;

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
                      onPressed: () {},
                      minWidth: 60,
                      height: 30,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                    ),
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
