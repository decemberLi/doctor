import 'dart:io';

import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'model/doctor_physician_qualification_entity.dart';
import 'model/doctor_qualification_model.dart';
import 'view_model/doctory_physician_qualification_view_model.dart';
import 'package:doctor/model/face_photo.dart';

class PhysicianQualificationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhysicianQualificationWidgetState();
  }
}

class _PhysicianQualificationWidgetState
    extends State<PhysicianQualificationWidget> {
  var _model = DoctorPhysicianQualificationViewModel();

  TextStyle _titleStyle = TextStyle(
      color: ThemeColor.colorFF222222,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  TextStyle _imgHintText =
      TextStyle(color: ThemeColor.primaryColor, fontSize: 12);

  EdgeInsetsGeometry _containerPadding =
      const EdgeInsets.only(right: 18, top: 14, bottom: 24);
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _model.refresh();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('基本信息确认'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: StreamBuilder(
            stream: _model.stream,
            builder: (BuildContext context,
                AsyncSnapshot<DoctorQualificationModel> snapshot) {
              return Column(
                children: [
                  _buildAvatarWidget(snapshot.data),
                  _buildIdCardWidget(snapshot.data),
                  _buildPracticeWidget(snapshot.data),
                  _buildPhysicianWidget(snapshot.data),
                  _buildProfessionWidget(snapshot.data),
                  Container(
                    margin: EdgeInsets.only(top: 50, bottom: 20),
                    child: AceButton(text: '提交', onPressed: () {}),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _buildAvatarWidget(DoctorQualificationModel model) {
    return Container(
      color: Colors.white,
      padding: _containerPadding,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget('头像'),
          Wrap(
            direction: Axis.horizontal,
            children: [
              Row(
                children: [
                  GestureDetector(
                      child: _hintUploadPicWidget(
                          model?.physicianInfoEntity?.fullFacePhoto),
                      onTap: () => _selectPicture(TypeOperator.AVATAR)),
                  Container(
                    margin: EdgeInsets.only(top: 12, left: 24),
                    width: 85,
                    height: 85,
                    decoration: DashedDecoration(
                      dashedColor: ThemeColor.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/avatar_sample.png',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _hintTextUI('个人正面免冠头像'),
                        _hintTextUI('背景尽量使用白色'),
                        _hintTextUI('着装需穿着工作服'),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildIdCardWidget(DoctorQualificationModel model) {
    return _container(
      title: '身份证（需拍摄原件）',
      children: [
        Wrap(
          direction: Axis.horizontal,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 12, bottom: 10, left: 18),
                        width: 144,
                        height: 85,
                        decoration: DashedDecoration(
                          dashedColor: ThemeColor.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _doLoadImage(
                            model?.physicianInfoEntity?.idCardLicense1,
                            text: '人像照片面'),
                      ),
                      onTap: () =>
                          _selectPicture(TypeOperator.ID_CARD_FACE_SIDE),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 19, bottom: 10),
                        width: 144,
                        height: 85,
                        decoration: DashedDecoration(
                          dashedColor: ThemeColor.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _doLoadImage(
                            model?.physicianInfoEntity?.idCardLicense2,
                            text: '国徽面照片'),
                      ),
                      onTap: () => _selectPicture(TypeOperator.ID_CARD_BG_SIDE),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 18),
          child: _hintTextUI('医师执业证、资格证、专业技术资格证（支持原件或彩色扫描件）'),
        ),
      ],
    );
  }

  _buildPracticeWidget(DoctorQualificationModel model) {
    List<FacePhoto> photos = model?.physicianInfoEntity?.practiceCertificates;
    List<Widget> photoList = [];
    if (photos != null) {
      for (var each in photos) {
        photoList.add(_doLoadImage(each));
      }
    }
    if (photoList.isEmpty) {
      photoList.add(_hintUploadPicWidget(null));
    }
    photoList.add(_sampleWidget('assets/images/practice.png'));

    return GestureDetector(
      child: _container(
        title: '医师执业证（至少需上传编码页和执业地点页）',
        children: photoList,
      ),
      onTap: () => _selectPicture(TypeOperator.PRACTICE_CERTIFICATES),
    );
  }

  _buildPhysicianWidget(DoctorQualificationModel model) {
    List<FacePhoto> photos = model?.physicianInfoEntity?.qualifications;
    List<Widget> photoList = [];
    if (photos != null) {
      for (var each in photos) {
        photoList.add(_doLoadImage(each));
      }
    }
    if (photoList.isEmpty) {
      photoList.add(_hintUploadPicWidget(null));
    }

    photoList.add(_sampleWidget('assets/images/physician.png'));
    return GestureDetector(
      child: _container(
        title: '医师资格证（至少需上传头像页和毕业院校页）',
        children: photoList,
      ),
      onTap: () => _selectPicture(TypeOperator.QUALIFICATIONS),
    );
  }

  _buildProfessionWidget(DoctorQualificationModel model) {
    List<FacePhoto> photos = model?.physicianInfoEntity?.practiceCertificates;
    List<Widget> photoList = [];
    if (photos != null) {
      for (var each in photos) {
        photoList.add(_doLoadImage(each));
      }
    }
    if (photoList.isEmpty) {
      photoList.add(_hintUploadPicWidget(null));
    }
    photoList.add(_sampleWidget('assets/images/profession.png'));
    return GestureDetector(
      child: _container(
        title: '专业技术资格证',
        children: photoList,
      ),
      onTap: () => _selectPicture(TypeOperator.JOB_CERTIFICATES),
    );
  }

  _hintTextUI(String text) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ThemeColor.primaryColor),
          ),
          Text(
            text,
            style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 10),
          )
        ],
      ),
    );
  }

  _doLoadImage(FacePhoto photo, {String text}) {
    Widget icon;
    Widget hintWidget = Container(
      margin: EdgeInsets.only(top: 6),
      child: Text(text ?? '上传照片', style: _imgHintText),
    );
    if (photo == null) {
      icon = Image.asset('assets/images/camera.png');
    } else if (photo.url != null) {
      icon = Image.network(photo.url, fit: BoxFit.scaleDown);
      hintWidget = Container();
    } else if (photo.path != null) {
      icon = Image.file(File(photo.path), fit: BoxFit.scaleDown);
      hintWidget = Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [icon, hintWidget],
    );
  }

  _hintUploadPicWidget(FacePhoto photo) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 18),
      width: 85,
      height: 85,
      decoration: DashedDecoration(
        dashedColor: ThemeColor.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _doLoadImage(photo),
    );
  }

  _sampleWidget(String pic) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 24),
      width: 85,
      height: 85,
      decoration: DashedDecoration(
        dashedColor: ThemeColor.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        pic,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  _container({String title, List<Widget> children}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: _containerPadding,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(title),
          Wrap(
            direction: Axis.horizontal,
            children: children,
          )
        ],
      ),
    );
  }

  _titleWidget(String text) {
    return Container(
      margin: EdgeInsets.only(left: 18),
      child: Text(text, style: _titleStyle),
    );
  }

  _selectPicture(TypeOperator type) async {
    PickedFile image = await _pickImage();

    if (type == TypeOperator.AVATAR) {
      _model.setAvatar(image.path);
    } else if (type == TypeOperator.ID_CARD_FACE_SIDE) {
      _model.setIdCardFaceSide(image.path);
    } else if (type == TypeOperator.ID_CARD_BG_SIDE) {
      _model.setIdCardBackgroundSide(image.path);
    } else if (type == TypeOperator.QUALIFICATIONS) {
      // 执业证

    } else if (type == TypeOperator.PRACTICE_CERTIFICATES) {
      //资格证

    } else if (type == TypeOperator.JOB_CERTIFICATES) {
      // 职称

    }
    _model.notifyDataChange();
  }

  _pickImage() async {
    int index = await DialogHelper.showBottom(context);
    if (index == 2) {
      Navigator.pop(context);
      return;
    }
    var source = index == 0 ? ImageSource.camera : ImageSource.gallery;
    return await _imagePicker.getImage(source: source);
  }
}

enum TypeOperator {
  // 头像
  AVATAR,
  // 人头面
  ID_CARD_FACE_SIDE,
  // 国徽面
  ID_CARD_BG_SIDE,
  // 医师资格证
  QUALIFICATIONS,

  /// 医师执业证
  PRACTICE_CERTIFICATES,

  /// 医师职称证
  JOB_CERTIFICATES
}
