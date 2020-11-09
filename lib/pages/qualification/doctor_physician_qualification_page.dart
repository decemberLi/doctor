import 'dart:io';

import 'package:doctor/model/face_photo.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
    gap: 3,
    borderRadius: BorderRadius.circular(8),
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
        title: Text('医师资质认证'),
        elevation: 0,
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
                  _buildNoticeWidget(snapshot.data),
                  _buildAvatarWidget(snapshot.data),
                  _buildIdCardWidget(snapshot.data),
                  _buildPracticeWidget(snapshot.data),
                  _buildPhysicianWidget(snapshot.data),
                  _buildProfessionWidget(snapshot.data),
                  Container(
                    margin: EdgeInsets.only(top: 50, bottom: 20),
                    child: AceButton(
                        text: '提交',
                        onPressed: () async {
                          var result = await _model.submitData(context);
                          if (result) {
                            UserInfoViewModel model =
                                Provider.of<UserInfoViewModel>(context,
                                    listen: false);
                            await model.queryDoctorInfo();
                            Navigator.pop(context, true);
                          }
                        }),
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
    TypeOperator type,
  }) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 16, top: 14, bottom: 24),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(title ?? '头像', style: _titleStyle),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: list?.length,
              addRepaintBoundaries: false,
              addSemanticIndexes: false,
              padding: EdgeInsets.only(left: 16, top: 13),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
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
                      _showOriginPic(type);
                    } else {
                      callback(photo, index);
                    }
                  },
                );
              },
            )
          ],
        ));
  }

  _buildAvatarWidget(DoctorQualificationModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 16, top: 14, bottom: 24),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('头像', style: _titleStyle),
          ),
          GridView(
            physics: NeverScrollableScrollPhysics(),
            addRepaintBoundaries: false,
            addSemanticIndexes: false,
            padding: EdgeInsets.only(left: 16, top: 13),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: [
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: _dashDecoration,
                  child:
                      _doLoadImage(model?.physicianInfoEntity?.fullFacePhoto),
                ),
                onTap: () => _selectPicture(TypeOperator.AVATAR),
              ),
              GestureDetector(
                child: Image.asset(
                  'assets/images/avatar_sample.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                onTap: () {
                  _showSamplePicDialog('assets/images/sample_avatar.png', '头像');
                },
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _hintTextStyle('个人正面免冠头像'),
                    _hintTextStyle('背景尽量使用白色'),
                    _hintTextStyle('着装需穿着工作服'),
                  ],
                ),
              ),
            ],
          ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            margin:
                                EdgeInsets.only(top: 12, bottom: 10, left: 18),
                            height: 85,
                            decoration: _dashDecoration,
                            child: _doLoadImage(
                                model?.physicianInfoEntity?.idCardLicense1,
                                text: '人像面照片',
                                aspectRatio: 144 / 85),
                          ),
                          onTap: () =>
                              _selectPicture(TypeOperator.ID_CARD_FACE_SIDE),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            margin:
                                EdgeInsets.only(top: 12, left: 19, bottom: 10),
                            height: 85,
                            decoration: _dashDecoration,
                            child: _doLoadImage(
                                model?.physicianInfoEntity?.idCardLicense2,
                                text: '国徽面照片',
                                aspectRatio: 144 / 85),
                          ),
                          onTap: () =>
                              _selectPicture(TypeOperator.ID_CARD_BG_SIDE),
                        ),
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
        type: TypeOperator.PRACTICE_CERTIFICATES,
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
        type: TypeOperator.QUALIFICATIONS,
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
        type: TypeOperator.JOB_CERTIFICATES,
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
    icon = Image.asset(
      'assets/images/camera.png',
      width: 32,
      height: 28,
    );
    if (photo != null) {
      if (photo.url != null) {
        icon = AspectRatio(
            child: Image.network(photo.url, fit: BoxFit.cover),
            aspectRatio: aspectRatio);
        hintWidget = Container();
      } else if (photo.path != null) {
        icon = AspectRatio(
            child: Image.file(File(photo.path), fit: BoxFit.cover),
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
    Decoration decoration = _dashDecoration;
    if (photo != null) {
      if (photo.url != null) {
        icon = Image.network(photo.url, fit: BoxFit.fill);
      } else if (photo.path != null) {
        icon = Image.file(File(photo.path), fit: BoxFit.fill);
      } else {
        decoration = BoxDecoration();
        icon = Image.asset(photo.assetsPath, fit: BoxFit.fill);
      }
    }

    return Container(
      width: 85,
      height: 85,
      decoration: decoration,
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
    await Future.delayed(Duration(milliseconds: 500));
    return await _imagePicker.getImage(source: source);
  }

  _buildNoticeWidget(DoctorQualificationModel data) {
    var style = TextStyle(fontSize: 12, color: ThemeColor.colorFF222222);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 0, top: 10, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('完成医师资质认证后，将为您开通复诊开方服务',
              style: TextStyle(fontSize: 14, color: ThemeColor.colorFF222222)),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('平台认证有效后，即可开通电子处方功能', style: style),
          ),
          Text('请您放心填写，以下信息仅供认证使用，我们将严格保密', style: style)
        ],
      ),
    );
  }

  _showSamplePicDialog(String assetsPath, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            padding: EdgeInsets.only(left: 70, right: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(assetsPath),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOriginPic(TypeOperator type) {
    if (type == TypeOperator.QUALIFICATIONS) {
      _showSamplePicDialog(
          'assets/images/sample_qualifications.png', '医师资格证示例');
    } else if (type == TypeOperator.PRACTICE_CERTIFICATES) {
      _showSamplePicDialog(
          'assets/images/sample_practice_certificates.png', '医师执业证示例');
    } else if (type == TypeOperator.JOB_CERTIFICATES) {
      _showSamplePicDialog(
          'assets/images/sample_job_certificates.png', '专业技术资格证示例');
    }
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
