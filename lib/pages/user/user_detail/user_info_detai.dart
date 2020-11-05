import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/qualification/doctor_physician_qualification_page.dart';
import 'package:doctor/pages/qualification/model/config_data_entity.dart';
import 'package:doctor/pages/qualification/view_model/doctor_qualification_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';

import '../service.dart';
import 'uploadImage.dart';

final uploadData = {
  '性别': 'sex',
  '科室': 'departmentsCode',
  '职称': 'jobGradeCode',
  '姓名': 'doctorName',
  '个人简介': 'briefIntroduction',
  '擅长疾病': 'speciality',
  '医院': 'hospitalCode',
};

class DoctorUserInfo extends StatefulWidget {
  @override
  _DoctorUserInfoState createState() => _DoctorUserInfoState();
}

class _DoctorUserInfoState extends State<DoctorUserInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DoctorQualificationViewModel _model = DoctorQualificationViewModel();
  SearchWidget<HospitalEntity> _hospitalSearchWidget;
  dynamic args;
  bool _qualification = false;

  // view || sure
  String _openType;
  List departments = [];
  List doctorTitle = [];
  List doctorPractice = [];

  _pickImage() async {
    int index = await DialogHelper.showBottom(context);
    if (index == null || index == 2) {
      return;
    }
    var source = index == 0 ? ImageSource.camera : ImageSource.gallery;
    ImagePicker.pickImage(source: source).then((value) => cropImage(value));
  }

  cropImage(File value) {
    if (value == null || value.path == null) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropImageRoute(value, _uploadImage),
      ),
    );
  }

  _uploadImage(image) async {
    try {
      if (image == null || image.path == null) {
        return;
      }
      OssFileEntity entity = await OssService.upload(image.path);
      updateHeadPic({'fullFacePhoto': entity}).then((res) {
        if (res is! DioError) {
          args.addAll({
            'fullFacePhoto': {'url': '${args['fullFacePhoto']['url']}?status=1'}
          });
          setState(() {
            args = args;
          });
          Navigator.pop(context);
        }
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  //修改信息
  void updateDoctorInfo(params, ifBack) {
    //更新保存的数据到args作页面数据回填
    args.addAll(params);
    setState(() {
      args = args;
    });
    updateUserInfo(params).then((res) {
      if (res['status'] == 'ERROR') {
        EasyLoading.showToast(res['errorMsg']);
      } else {
        if (ifBack) {
          //返回 编辑页面返回
          Navigator.pop(context);
        } else {
          //当前页面toast
          EasyLoading.showToast('修改成功');
        }
      }
    });
  }

  //跳转列表样式
  ///lable:label
  ///value:初始值
  ///type 是否可修改
  ///edit 编辑方式 picker:下拉框 edit:编辑 hospital:医院搜索 photo:图片
  ///defaultCode 用户下拉框回填数据的默认值
  Widget infoItem(String lable, value, bool type, edit, defaultCode) {
    return Container(
      margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context)),
      ),
      child: ListTile(
        title: lable == '头像'
            ? Container(
                width: 40,
                height: 40,
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: value == null
                      ? AssetImage(
                          "assets/images/avatar.png",
                        )
                      : NetworkImage(
                          value['url'] + '?status=${value['ossId']}',
                        ),
                ),
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
        enabled: type,
        trailing: type ? Icon(Icons.keyboard_arrow_right) : null,
        onTap: () {
          //跳转修改
          //照片调摄像头，不修改头像
          if (edit == 'photo') {
            _pickImage();
          }
          //姓名、个人简介、擅长疾病填写
          if (edit == 'edit') {
            Navigator.pushNamed(context, RouteManager.EDIT_DOCTOR_PAGE,
                arguments: {
                  'lable': lable,
                  'value': value,
                  'editWay': edit,
                  'function': updateDoctorInfo
                });
          }
          if (edit == 'hospital') {
            _goHospitalSearchPage();
          }
          //性别、医院、科室、职称选择
          if (edit == 'picker') {
            showPickerModal(context, lable, defaultCode);
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
        HospitalEntity data = value as HospitalEntity;
        updateDoctorInfo({
          'hospitalCode': data.hospitalCode,
          'hospitalName': data.hospitalName
        }, false);
      },
    );
    //科室数据
    getSelectInfo({'type': 'DEPARTMENTS'}).then((res) {
      departments = res;
    });
    //职称数据
    getSelectInfo({'type': 'DOCTOR_TITLE'}).then((res) {
      doctorTitle = res;
    });
    getSelectInfo({'type': 'DOCTOR_PRACTICE_TITLE'}).then((res) {
      doctorPractice = res;
    });
  }

  _goHospitalSearchPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => _hospitalSearchWidget));
  }

  showPickerModal(BuildContext context, lable, defaultCode) {
    //下拉数据
    List<PickerItem<String>> listData = [];
    //默认选择值 默认值是通过index来确定的
    List<int> defaultSelect;
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
      if (defaultCode != null && defaultCode is! int) {
        defaultCode = int.parse(defaultCode);
      }
      defaultSelect = defaultCode == null ? [0] : [defaultCode];
    }
    if (lable == '职称') {
      listData = [
        ...doctorTitle
            .map((e) => new PickerItem(
                  text: Text(
                    e['name'],
                    textAlign: TextAlign.center,
                  ),
                  value: '${e['code']}',
                ))
            .toList()
      ];
      if (defaultCode != null && defaultCode is! int) {
        int index =
            doctorTitle.indexWhere((element) => element['code'] == defaultCode);
        defaultCode = index;
      }
      defaultSelect = defaultCode == null ? [0] : [defaultCode];
    }

    if (lable == '科室') {
      //找到父亲
      String parent;
      int sonIndex;
      departments.forEach((element) {
        List child = element['children'];
        List filterData =
            child.where((element) => element['code'] == defaultCode).toList();
        if (filterData.length > 0) {
          parent = element['code'];
          sonIndex =
              child.indexWhere((element) => element['code'] == defaultCode);
          return;
        }
      });
      int parentIndex =
          departments.indexWhere((element) => element['code'] == parent);
      defaultSelect = defaultCode == null ? [0, 0] : [parentIndex, sonIndex];
      listData = [
        ...departments.map((e) {
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
    if (lable == '易学术执业科室') {
      //找到父亲
      String parent;
      int sonIndex;
      doctorPractice.forEach((element) {
        List child = element['children'];
        List filterData =
            child.where((element) => element['code'] == defaultCode).toList();
        if (filterData.length > 0) {
          parent = element['code'];
          sonIndex =
              child.indexWhere((element) => element['code'] == defaultCode);
          return;
        }
      });
      int parentIndex =
          doctorPractice.indexWhere((element) => element['code'] == parent);
      defaultSelect = defaultCode == null ? [0, 0] : [parentIndex, sonIndex];
      listData = [
        ...doctorPractice.map((e) {
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
    Picker picker = Picker(
        title: Text(
          '选择$lable',
          style: TextStyle(fontSize: 18),
        ),
        selecteds: defaultSelect,
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
          //保存
          List pickerData = picker.getSelectedValues();
          if (pickerData.length > 1) {
            String departmentsName;
            final departChild = departments
                .where((element) => element['code'] == pickerData[0])
                .toList();
            if (departChild != null) {
              List children = departChild[0]['children'];
              departmentsName = children
                  .where((element) => element['code'] == pickerData[1])
                  .toList()[0]['name'];
            }
            if (lable == '科室') {
              updateDoctorInfo({
                'departmentsName': departmentsName,
                'departmentsCode': pickerData[1]
              }, false);
            } else if (lable == '易学术执业科室') {
              updateDoctorInfo({
                'practiceDepartmentName': departmentsName,
                'practiceDepartmentCode': pickerData[1]
              }, false);
            }
          } else {
            dynamic param = {
              uploadData[lable]: int.parse(pickerData[0]),
            };
            if (lable == '职称') {
              String jobGradeName = doctorTitle
                  .where((element) => element['code'] == pickerData[0])
                  .toList()[0]['name'];
              param = {
                uploadData[lable]: pickerData[0],
                'jobGradeName': jobGradeName
              };
            }
            updateDoctorInfo(param, false);
          }
        });
    picker.showModal(this.context);
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as Map;
    if (args == null) {
      args = data['doctorData'];
      _openType = data['openType'] ?? 'VIEW';
      _qualification = data['qualification'] ?? false;
    }

    bool doctorStatus = args['authStatus'] == 'WAIT_VERIFY';
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0XFFF9FCFF),
      appBar: AppBar(
        title: Text(
          _qualification ? '个人信息' : '基本信息确认',
        ),
        elevation: 1,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildRejectInfoIfNeeded(),
            _buildNoticeInfoIfNeeded(),
            Card(
              margin: EdgeInsets.only(left: 16, right: 16, top: 12),
              child: Column(
                children: [
                  !_qualification
                      ? infoItem('头像', args['fullFacePhoto'], doctorStatus,
                          'photo', null)
                      : Container(),
                  infoItem(
                      '姓名', args['doctorName'], doctorStatus, 'edit', null),
                  infoItem('性别', args['sex'] == 0 ? '女' : '男', doctorStatus,
                      'picker', args['sex']),
                  infoItem('医院', args['hospitalName'], doctorStatus, 'hospital',
                      null),
                  infoItem(
                      '科室',
                      args['departmentsName'],
                      doctorStatus,
                      'picker',
                      args['departmentsCode'] == ''
                          ? null
                          : args['departmentsCode']),
                  infoItem('职称', args['jobGradeName'], doctorStatus, 'picker',
                      args['jobGradeCode']),
                  _qualification
                      ? infoItem(
                          '易学术执业科室',
                          args['practiceDepartmentName'],
                          doctorStatus,
                          'picker',
                          args['practiceDepartmentCode'])
                      : Container(),
                ],
              ),
            ),
            !_qualification
                ? Card(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 12),
                    child: Column(
                      children: [
                        infoItem('个人简介', args['briefIntroduction'], true,
                            'edit', null),
                        infoItem(
                            '擅长疾病', args['speciality'], true, 'edit', null),
                      ],
                    ),
                  )
                : Container(),
            _buildNextBtnIfNeeded(),
          ],
        ),
      ),
    );
  }

  _buildNextBtnIfNeeded() {
    if (_openType == 'VIEW' && !_qualification) {
      return Container();
    }

    var isSureUserInfo = _openType == 'SURE_INFO';
    var titleText = isSureUserInfo ? '确认' : '下一步';

    return Container(
      margin: EdgeInsets.only(top: 36, bottom: 36),
      child: AceButton(
        text: titleText,
        onPressed: () async {
          if (!_checkData()) {
            return;
          }
          if (isSureUserInfo) {
            Navigator.pop(context, true);
            return;
          }

          var needPop = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PhysicianQualificationWidget()));
          if (needPop) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  _buildNoticeInfoIfNeeded() {
    if (_qualification) {
      // 确认基本信息提示
      TextStyle style =
          const TextStyle(color: ThemeColor.colorFF222222, fontSize: 12);
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 26, top: 10, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确认基础信息', style: style),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('确认基础信息后，方可进行医师资质认证', style: style),
            ),
            Text('请您放心填写，一下信息仅供认证使用，我们将严格保密', style: style)
          ],
        ),
      );
    }
    return Container();
  }

  _buildRejectInfoIfNeeded() {
    if (_qualification && args['authStatus'] == 'FAIL') {
      // 确认基本信息提示
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 15, top: 10, right: 16),
        child: Card(
          child: Container(
            margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('驳回理由',
                    style: TextStyle(
                        color: ThemeColor.primaryColor, fontSize: 12)),
                Text('请您放心填写，一下信息仅供认证使用，我们将严格保密',
                    style:
                        TextStyle(color: ThemeColor.primaryColor, fontSize: 12))
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }

  bool _checkData() {
    if (args == null) {
      return false;
    }
    var entity = DoctorDetailInfoEntity.fromJson(args);
    if (entity.doctorName == null || entity.doctorName.isEmpty) {
      EasyLoading.showToast('请填写姓名');
      return false;
    }
    if (entity.sex == null) {
      EasyLoading.showToast('请选择性别');
      return false;
    }
    if (entity.hospitalName == null ||
        entity.hospitalName == '' ||
        entity.hospitalCode == null ||
        entity.hospitalCode == '') {
      EasyLoading.showToast('请选择医院');
      return false;
    }
    if (entity.departmentsName == null ||
        entity.departmentsName == '' ||
        entity.departmentsCode == null ||
        entity.departmentsCode == '') {
      EasyLoading.showToast('请选择科室');
      return false;
    }
    if (entity.jobGradeName == null ||
        entity.jobGradeName == '' ||
        entity.jobGradeCode == null ||
        entity.jobGradeCode == '') {
      EasyLoading.showToast('请选择职称');
      return false;
    }
    if (_qualification &&
        (entity.practiceDepartmentName == null ||
            entity.practiceDepartmentName == '' ||
            entity.practiceDepartmentCode == null ||
            entity.practiceDepartmentCode == '')) {
      EasyLoading.showToast('请选择易学术执业科室');
      return false;
    }

    return true;
  }
}
