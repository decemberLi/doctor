import 'package:doctor/pages/qualification/model/doctor_qualification_model.dart';
import 'package:doctor/pages/qualification/view_model/doctor_qualification_view_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/Radio_row.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/search_widget.dart';
import 'package:flutter/material.dart';

import 'doctor_physician_qualification_page.dart';
import 'model/config_data_entity.dart';

class DoctorBasicInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoctorBasicInfoPageState();
}

class _CenterEndFabLocation extends StandardFabLocation
    with FabCenterOffsetX, FabFloatOffsetY {
  const _CenterEndFabLocation();

  @override
  String toString() => 'FloatingActionButtonLocation.centerTop';
}

class _DoctorBasicInfoPageState extends State<DoctorBasicInfoPage> {
  DoctorQualificationViewModel _model = DoctorQualificationViewModel();

  var _textFieldHintStyle =
      const TextStyle(fontSize: 16, color: ThemeColor.colorFF888888);

  var _textFieldArrowIcon = const Icon(Icons.keyboard_arrow_right_rounded,
      size: 24, color: ThemeColor.colorFF000000);
  var _textStyle =
      const TextStyle(color: ThemeColor.colorFF222222, fontSize: 16);

  var _divider = Divider(
    height: 1,
  );

  var _titleText = '填写基本信息';
  SearchWidget<HospitalEntity> _hospitalSearchWidget;
  SearchWidget<ConfigDataEntity> _departSearchWidget;
  SearchWidget<ConfigDataEntity> _jobGradeSearchWidget;

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _model.refresh();
    _hospitalSearchWidget =
        SearchWidget<HospitalEntity>('选择医院', hintText: '输入医院名称',
            searchConditionCallback: <T extends Search>(condition, streamSink) {
      var hospitals = _model.queryHospital();
      streamSink.add(hospitals);
    });
    _departSearchWidget =
        SearchWidget<ConfigDataEntity>('选择科室', hintText: '请选择科室',
            searchConditionCallback: <T extends Search>(condition, streamSink) {
      var hospitals = _model.queryConfig('DEPARTMENTS');
      streamSink.add(hospitals);
    });
    _jobGradeSearchWidget =
        SearchWidget<ConfigDataEntity>('选择科室', hintText: '请选择科室',
            searchConditionCallback: <T extends Search>(condition, streamSink) {
      var hospitals = _model.queryConfig('DEPARTMENTS');
      streamSink.add(hospitals);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      floatingActionButton: AceButton(
        text: '提交',
        onPressed: () => {_model.submitBasicInfo()},
      ),
      floatingActionButtonLocation: const _CenterEndFabLocation(),
      appBar: AppBar(
        title: Text(_titleText),
        elevation: 1,
      ),
      body: StreamBuilder(
        stream: _model.stream,
        builder: (BuildContext context,
            AsyncSnapshot<DoctorQualificationModel> snapshot) {
          return _buildUi(snapshot.data);
        },
      ),
    );
  }

  _buildUi(DoctorQualificationModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNoticeMessage(model),
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            width: double.infinity,
            height: 311,
            padding: EdgeInsets.fromLTRB(16, 12, 16, 26),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Column(
              children: [
                // 姓名
                Expanded(
                  child: TextFormField(
                    readOnly: false,
                    initialValue: model?.doctorDetailInfo?.doctorName,
                    style: _textStyle,
                    onSaved: (val) => {print(val)},
                    onChanged: (String value) {
                      model.doctorDetailInfo.doctorName = value;
                      _model.changeDataNotify();
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '姓名',
                        hintStyle: _textFieldHintStyle),
                  ),
                ),
                _divider,
                Expanded(
                  child: Row(
                    children: [
                      Text('性别', style: _textStyle),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RadioRow(
                              title: Text('男', style: MyStyles.inputTextStyle),
                              value: 1,
                              groupValue: model?.doctorDetailInfo?.sex,
                              onChanged: (int value) {
                                model?.doctorDetailInfo?.sex = value;
                                _model.changeDataNotify();
                              },
                            ),
                            RadioRow(
                              title: Text('女', style: MyStyles.inputTextStyle),
                              value: 0,
                              groupValue: model?.doctorDetailInfo?.sex,
                              onChanged: (int value) {
                                model?.doctorDetailInfo?.sex = value;
                                _model.changeDataNotify();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _divider,
                // 所在医院
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: model?.doctorDetailInfo?.hospitalName,
                    style: _textStyle,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '所在医院',
                        hintStyle: _textFieldHintStyle,
                        suffixIcon: _textFieldArrowIcon),
                    onTap: _goSearchPage(_hospitalSearchWidget),
                  ),
                ),
                // 所在科室
                _divider,
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: model?.doctorDetailInfo?.departmentsName,
                    style: _textStyle,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '所在科室',
                        hintStyle: _textFieldHintStyle,
                        suffixIcon: _textFieldArrowIcon),
                    onTap: () {
                      _goSearchPage(_departSearchWidget);
                    },
                  ),
                ),
                // 职称
                _divider,
                Expanded(
                  child: TextFormField(
                      readOnly: true,
                      initialValue: model?.doctorDetailInfo?.jobGradeName,
                      style: _textStyle,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '职称',
                          hintStyle: _textFieldHintStyle,
                          suffixIcon: _textFieldArrowIcon),
                      onTap: () {
                        _goSearchPage(_jobGradeSearchWidget);
                      }),
                ),
                // 医学书执业科室
                _divider,
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue:
                        model?.doctorDetailInfo?.practiceDepartmentName,
                    style: _textStyle,
                    decoration: InputDecoration(
                        errorMaxLines: 1,
                        border: InputBorder.none,
                        hintText: '易学术执业科室',
                        hintStyle: _textFieldHintStyle,
                        suffixIcon: _textFieldArrowIcon),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchWidget<YXSDepModel>(
                          '搜索易学术执业科室',
                          hintText: '输入易学术执业科室',
                          searchConditionCallback:
                              <T extends Search>(condition, streamSink) {
                            // TODO 搜索
                            List<YXSDepModel> data = [];
                            data.add(YXSDepModel(condition));
                            streamSink.add(data);
                          },
                          callback: <T extends Search>(value, pos) {
                            // TODO 回填显示数据
                            print('position $pos');
                            print('value -> $value');
                          },
                        );
                      }));
                    },
                  ),
                ),
                _divider,
              ],
            ),
          ),
        )
      ],
    );
  }

  _goSearchPage(SearchWidget searchWidget) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => searchWidget));
  }

  _buildNoticeMessage(DoctorQualificationModel model) {
    bool hasBasicInfo = _model.validateBasicInfo(needShowMsg: false);
    if (hasBasicInfo) {
      _titleText = '基本信息确认';
      // 确认基本信息提示
      TextStyle style =
          const TextStyle(color: ThemeColor.colorFF222222, fontSize: 12);
      return Container(
        margin: EdgeInsets.only(left: 26, top: 10),
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
    _titleText = '填写基本信息';
    return Container();
  }
}

class YXSDepModel with Search {
  String text;

  YXSDepModel(this.text);

  @override
  String faceText() => text;
}
