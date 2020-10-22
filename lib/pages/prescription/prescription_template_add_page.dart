import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

class PrescriptionTemplageAddPage extends StatefulWidget {
  @override
  _PrescriptionTemplageAddPageState createState() =>
      _PrescriptionTemplageAddPageState();
}

class _PrescriptionTemplageAddPageState
    extends State<PrescriptionTemplageAddPage> {
  PrescriptionTemplateModel data = PrescriptionTemplateModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('添加处方模板'),
        ),
        body: Container(
          color: ThemeColor.colorFFF3F5F8,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '模板名称',
                style: MyStyles.inputTextStyle,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                color: Colors.white,
                child: TextFormField(
                  initialValue: data.prescriptionTemplateName ?? '',
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  validator: (val) => val.length < 1 ? '名称不能为空' : null,
                  onSaved: (val) => {print(val)},
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  style: MyStyles.inputTextStyle,
                  onChanged: (value) {
                    setState(() {
                      data.prescriptionTemplateName = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '模板名称',
                style: MyStyles.inputTextStyle,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                color: Colors.white,
                child: TextFormField(
                  initialValue: data.clinicalDiagnosis ?? '',
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  validator: (val) => val.length < 1 ? '临床诊断不能为空' : null,
                  onSaved: (val) => {print(val)},
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  style: MyStyles.inputTextStyle,
                  onChanged: (value) {
                    setState(() {
                      data.clinicalDiagnosis = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Rp(0)',
                style: MyStyles.inputTextStyle,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                alignment: Alignment.center,
                child: AceButton(
                  type: AceButtonType.secondary,
                  onPressed: () {
                    // var list = await Navigator.pushNamed(
                    //     context, RouteManager.MEDICATION_LIST);
                    // // print(list);
                    // ///TODO: 偶尔有报错
                    // if (list != null) {
                    //   model.data.drugRp = [...list as List<DrugModel>];
                    //   model.changeDataNotify();
                    // }
                  },
                  width: 295,
                  height: 42,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+ 添加药品',
                        style: TextStyle(
                            color: ThemeColor.primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: ThemeColor.colorFFF3F5F8,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(),
              AceButton(
                width: 310,
                text: '确认',
                onPressed: () {},
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
