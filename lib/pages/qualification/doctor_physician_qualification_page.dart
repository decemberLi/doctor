import 'dart:io';

import 'package:doctor/model/face_photo.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'model/doctor_qualification_model.dart';
import 'view_model/doctory_physician_qualification_view_model.dart';

typedef OnItemCallback = Function(FacePhoto model, int index);

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
  final _dashDecoration = DashedDecoration(
    dashedColor: ThemeColor.primaryColor,
    borderRadius: BorderRadius.circular(2),
  );

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
                    child: AceButton(
                        text: '提交', onPressed: () => _model.submitData()),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _buildGridView({
    String title,
    List<FacePhoto> list,
    OnItemCallback callback,
  }) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 16, top: 14, bottom: 24, left: 18),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? '头像', style: _titleStyle),
            Container(
              padding: EdgeInsets.only(top: 13),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: list?.length,
                addRepaintBoundaries:false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  var photo = list[index];
                  var widget;
                  if (photo.addImgPlaceHolder ?? false) {
                    widget = _addImageWidget();
                  } else if (photo.sampleImgPlaceHolder ?? false) {
                    widget = _imageWidget(photo);
                  } else {
                    widget = _imageWidget(photo);
                  }
                  return GestureDetector(
                    child: widget,
                    onTap: () {
                      if (index == list.length - 1) {
                        // TODO: 显示大图
                      } else {
                        callback(photo, index);
                      }
                    },
                  );
                },
              ),
            )
          ],
        ));
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
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 18),
                        width: 85,
                        height: 85,
                        decoration: _dashDecoration,
                        child: _doLoadImage(
                            model?.physicianInfoEntity?.fullFacePhoto),
                      ),
                      onTap: () => _selectPicture(TypeOperator.AVATAR)),
                  Container(
                    margin: EdgeInsets.only(top: 12, left: 24),
                    width: 85,
                    height: 85,
                    decoration: _dashDecoration,
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
                        _hintTextStyle('个人正面免冠头像'),
                        _hintTextStyle('背景尽量使用白色'),
                        _hintTextStyle('着装需穿着工作服'),
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
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: _containerPadding,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget('身份证（需拍摄原件）'),
          Wrap(
            direction: Axis.horizontal,
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
                              margin: EdgeInsets.only(
                                  top: 12, bottom: 10, left: 18),
                              width: 144,
                              height: 85,
                              decoration: DashedDecoration(
                                dashedColor: ThemeColor.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _doLoadImage(
                                  model?.physicianInfoEntity?.idCardLicense1,
                                  text: '人像照片面',
                                  aspectRatio: 144 / 85),
                            ),
                            onTap: () =>
                                _selectPicture(TypeOperator.ID_CARD_FACE_SIDE),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 12, left: 19, bottom: 10),
                              width: 144,
                              height: 85,
                              decoration: DashedDecoration(
                                dashedColor: ThemeColor.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _doLoadImage(
                                  model?.physicianInfoEntity?.idCardLicense2,
                                  text: '国徽面照片',
                                  aspectRatio: 144 / 85),
                            ),
                            onTap: () =>
                                _selectPicture(TypeOperator.ID_CARD_BG_SIDE),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 18),
                child: _hintTextStyle('医师执业证、资格证、专业技术资格证（支持原件或彩色扫描件）'),
              ),
            ],
          )
        ],
      ),
    );
  }

  _addPlaceHolderPhotoIfNeeded(
      List<FacePhoto> originList, String sampleAssetPath, int count) {
    List<FacePhoto> list = [];
    list.addAll(originList);

    if (list.length < count) {
      var addMsgPhoto = FacePhoto.create();
      addMsgPhoto.addImgPlaceHolder = true;
      list.add(addMsgPhoto);
    }
    var samplePhoto = FacePhoto.create();
    samplePhoto.sampleImgPlaceHolder = true;
    samplePhoto.assetsPath = 'assets/images/practice.png';
    list.add(samplePhoto);
    return list;
  }

  _buildPracticeWidget(DoctorQualificationModel model) {
    List<FacePhoto> originList =
        model?.physicianInfoEntity?.practiceCertificates ?? [];
    List<FacePhoto> list = _addPlaceHolderPhotoIfNeeded(
        originList, 'assets/images/practice.png', 5);

    return _buildGridView(
        title: '医师执业证（至少需上传编码页和执业地点页）',
        list: list,
        callback: (FacePhoto value, index) {
          _selectPicture(TypeOperator.PRACTICE_CERTIFICATES,
              facePhoto: value, index: index);
        });
  }

  _buildPhysicianWidget(DoctorQualificationModel model) {
    List<FacePhoto> originList =
        model?.physicianInfoEntity?.qualifications ?? [];
    List<FacePhoto> list = _addPlaceHolderPhotoIfNeeded(
        originList, 'assets/images/practice.png', 5);

    return _buildGridView(
        title: '医师资格证（至少需上传头像页和毕业院校页）',
        list: list,
        callback: (FacePhoto value, index) {
          _selectPicture(TypeOperator.QUALIFICATIONS,
              facePhoto: value, index: index);
        });
  }

  _buildProfessionWidget(DoctorQualificationModel model) {
    List<FacePhoto> originList =
        model?.physicianInfoEntity?.jobCertificates ?? [];
    List<FacePhoto> list = _addPlaceHolderPhotoIfNeeded(
        originList, 'assets/images/practice.png', 5);

    return _buildGridView(
        title: '专业技术资格证',
        list: list,
        callback: (FacePhoto value, index) {
          _selectPicture(TypeOperator.JOB_CERTIFICATES,
              facePhoto: value, index: index);
        });
  }

  _hintTextStyle(String text) {
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

  _border({Widget child}) {
    return Container(
      width: 85,
      height: 85,
      decoration: _dashDecoration,
      child: child,
    );
  }

  _addImageWidget({String text}) {
    return _border(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/camera.png',
            fit: BoxFit.scaleDown,
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            child: Text(text ?? '上传照片', style: _imgHintText),
          ),
        ],
      ),
    );
  }

  _doLoadImage(FacePhoto photo, {String text, double aspectRatio = 1 / 1}) {
    Widget icon;
    Widget hintWidget = Container(
      margin: EdgeInsets.only(top: 6),
      child: Text(text ?? '上传照片', style: _imgHintText),
    );
    icon = Image.asset('assets/images/camera.png');
    if (photo != null) {
      if (photo.url != null) {
        icon = AspectRatio(
            child: Image.network(photo.url, fit: BoxFit.cover),
            aspectRatio: aspectRatio);
        hintWidget = Container();
      } else if (photo.path != null) {
        icon = AspectRatio(
            child: Image.file(File(photo.path), fit: BoxFit.scaleDown),
            aspectRatio: aspectRatio);
        hintWidget = Container();
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [icon, hintWidget],
    );
  }

  _imageWidget(FacePhoto photo) {
    var icon;
    if (photo != null) {
      if (photo.url != null) {
        icon = Image.network(photo.url, fit: BoxFit.cover);
      } else if (photo.path != null) {
        icon = Image.file(File(photo.path), fit: BoxFit.scaleDown);
      } else {
        icon = Image.asset(photo.assetsPath, fit: BoxFit.fill);
      }
    }
    return Container(
      width: 85,
      height: 85,
      decoration: _dashDecoration,
      child: AspectRatio(child: icon, aspectRatio: 1 / 1),
    );
  }

  _titleWidget(String text) {
    return Container(
      margin: EdgeInsets.only(left: 18),
      child: Text(text, style: _titleStyle),
    );
  }

  _selectPicture(TypeOperator type, {FacePhoto facePhoto, int index}) async {
    PickedFile image = await _pickImage();
    if (image == null || image.path == null) {
      return;
    }
    if (type == TypeOperator.AVATAR) {
      _model.setAvatar(image.path);
    } else if (type == TypeOperator.ID_CARD_FACE_SIDE) {
      _model.setIdCardFaceSide(image.path);
    } else if (type == TypeOperator.ID_CARD_BG_SIDE) {
      _model.setIdCardBackgroundSide(image.path);
    } else if (type == TypeOperator.QUALIFICATIONS) {
      // 执业证
      _model.setQualifications(image.path, facePhoto, index);
    } else if (type == TypeOperator.PRACTICE_CERTIFICATES) {
      //资格证
      _model.setPracticeCertificates(image.path, facePhoto, index);
    } else if (type == TypeOperator.JOB_CERTIFICATES) {
      // 职称
      _model.setJobCertificatess(image.path, facePhoto, index);
    }
    _model.notifyDataChange();
  }

  _pickImage() async {
    int index = await DialogHelper.showBottom(context);
    if (index == null || index == 2) {
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
