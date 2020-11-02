import 'package:doctor/pages/qualification/model/config_data_entity.dart';
import 'package:doctor/pages/qualification/view_model/doctor_qualification_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

import '../service.dart';

class DoctorUserInfo extends StatefulWidget {
  @override
  _DoctorUserInfoState createState() => _DoctorUserInfoState();
}

class _DoctorUserInfoState extends State<DoctorUserInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DoctorQualificationViewModel _model = DoctorQualificationViewModel();
  SearchWidget<HospitalEntity> _hospitalSearchWidget;
  List DEPARTMENTS = [];
  List DOCTOR_TITLE = [];
  //跳转列表样式
  Widget infoItem(String lable, value, bool type, edit) {
    return Container(
      margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context)),
      ),
      child: ListTile(
        title: lable == '头像'
            ? Image.asset(
                value == null ? "assets/images/avatar.png" : value['url'],
                width: 40,
                height: 40,
                alignment: Alignment.centerRight,
              )
            : Text(
                value ?? '',
                textAlign: TextAlign.end,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
        leading: Text(
          lable,
          style: TextStyle(
            color: ThemeColor.colorFF000000,
            fontSize: 14,
          ),
        ),
        enabled: type, //TODO: 提交代码时修改为type
        trailing: type ? Icon(Icons.keyboard_arrow_right) : null,
        onTap: () {
          //跳转修改
          //照片调摄像头
          //姓名、个人简介、擅长疾病填写
          //性别、医院、科室、职称选择
          if (edit == 'edit' || edit == 'search') {
            Navigator.pushNamed(context, RouteManager.EDIT_DOCTOR_PAGE,
                arguments: {'lable': lable, 'value': value, 'editWay': edit});
          }
          if (edit == 'hospital') {
            _goHospitalSearchPage();
          }
          if (edit == 'picker') {
            showPickerModal(context, lable);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _hospitalSearchWidget = SearchWidget<HospitalEntity>(
      '选择医院',
      hintText: '输入医院名称',
      searchConditionCallback: <T extends Search>(condition, streamSink) async {
        var hospitals = await _model.queryHospital(condition);
        streamSink.add(hospitals);
      },
      callback: <T extends Search>(value, position) {
        _model.setHospital(value as HospitalEntity);
        _model.changeDataNotify();
      },
    );
    //科室数据
    getSelectInfo({'type': 'DEPARTMENTS'}).then((res) {
      print(res);
      DEPARTMENTS = res;
    });
    //职称数据
    getSelectInfo({'type': 'DOCTOR_TITLE'}).then((res) {
      DOCTOR_TITLE = res;
    });
  }

  _goHospitalSearchPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => _hospitalSearchWidget));
  }

  showPickerModal(BuildContext context, lable) {
    //下拉数据
    List<PickerItem<String>> listData = [];
    if (lable == '性别') {
      listData = [
        new PickerItem(
          text: Text(
            '女',
            textAlign: TextAlign.center,
          ),
          value: '0',
        ),
        new PickerItem(
          text: Text(
            '男',
            textAlign: TextAlign.center,
          ),
          value: '1',
        ),
      ];
    }
    if (lable == '科室') {
      listData = [
        ...DEPARTMENTS.map((e) {
          final children = e['children'];
          List<PickerItem<String>> childList = [
            ...children
                .map((e) => new PickerItem(
                      text: Text(
                        e['name'],
                        textAlign: TextAlign.center,
                      ),
                      value: '${e['code']}',
                    ))
                .toList()
          ];
          return new PickerItem(
              text: Text(
                e['name'],
                textAlign: TextAlign.center,
              ),
              value: '${e['code']}',
              children: childList);
        }).toList()
      ];
    }
    if (lable == '职称') {
      listData = [
        ...DOCTOR_TITLE
            .map((e) => new PickerItem(
                  text: Text(
                    e['name'],
                    textAlign: TextAlign.center,
                  ),
                  value: '${e['code']}',
                ))
            .toList()
      ];
    }
    Picker picker = Picker(
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
          print(value.toString());
          print(picker.getSelectedValues());
          //保存
        });
    picker.showModal(this.context);
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as Map;
    final args = data['doctorData'];
    bool doctorStatus = args['authStatus'] == 'WAIT_VERIFY';
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0XFFF9FCFF),
      appBar: AppBar(
        title: Text(
          '基本信息确认',
        ),
        elevation: 1,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Column(
              children: [
                infoItem('头像', args['fullFacePhoto'], doctorStatus, null),
                infoItem('姓名', args['doctorName'], doctorStatus, 'edit'),
                infoItem(
                    '性别', args['sex'] == 0 ? '女' : '男', doctorStatus, 'picker'),
                infoItem('医院', args['hospitalName'], doctorStatus, 'hospital'),
                infoItem('科室', args['departmentsName'], doctorStatus, 'picker'),
                infoItem('职称', args['jobGradeName'], doctorStatus, 'picker'),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Column(
              children: [
                infoItem('个人简介', args['briefIntroduction'], true, 'edit'),
                infoItem('擅长疾病', args['speciality'], true, 'edit'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
