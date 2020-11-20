import 'dart:io';

import 'package:doctor/model/face_photo.dart';
import 'package:doctor/pages/qualification/image_choose_widget.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/route/fade_route.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:doctor/widgets/photo_view_gallery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'doctor_signature_widget.dart';
import 'model/doctor_qualification_model.dart';
import 'view_model/doctory_physician_qualification_view_model.dart';

typedef OnItemCallback = Function(FacePhoto model, int index);
typedef OnRemoveImageCallback = void Function(int index);

class PhysicianQualificationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhysicianQualificationWidgetState();
  }
}

class _PhysicianQualificationWidgetState
    extends State<PhysicianQualificationWidget> {
  var _model = DoctorPhysicianQualificationViewModel();
  var signatureTextStyle = TextStyle(
      color: ThemeColor.colorFF8FC1FE,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  TextStyle _titleStyle = TextStyle(
      color: ThemeColor.colorFF222222,
      fontSize: 14,
      fontWeight: FontWeight.bold);

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
                  Card(
                    child: Column(
                      children: [
                        Container(
                          child:
                              _hintTextStyle('医师执业证、资格证、专业技术资格证（支持原件或彩色扫描件）'),
                          margin:
                              EdgeInsets.only(left: 18, top: 18, bottom: 18),
                        ),
                        _buildPracticeWidget(snapshot.data),
                        _buildPhysicianWidget(snapshot.data),
                        _buildProfessionWidget(snapshot.data),
                      ],
                    ),
                  ),
                  _buildDoctorSignatureWidget(snapshot.data),
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

  _buildGrid({
    String title,
    List<FacePhoto> list,
    OnItemCallback callback,
    OnRemoveImageCallback removeCallback,
    String sampleAssets,
    TypeOperator type,
  }) {
    List<Widget> widgets = [];
    for (var idx = 0; idx < list.length; idx++) {
      FacePhoto photo = list[idx];
      widgets.add(ImageChooseWidget(
        width: 85,
        url: photo?.url,
        addImgCallback: () {
          callback(photo, idx);
        },
        removeImgCallback: () {
          removeCallback(idx);
        },
        showOriginImgCallback: () {
          _showOriginImage(list.map((e) => e.url).toList(), idx);
        },
      ));
    }
    if (widgets.length < 5) {
      widgets.add(ImageChooseWidget(
        url: null,
        width: 85,
        addImgCallback: () {
          callback(null, 5);
        },
      ));
    }

    widgets.add(GestureDetector(
      child: Image.asset(sampleAssets, fit: BoxFit.fill, width: 85, height: 85),
      onTap: () {
        _showOriginPic(type);
      },
    ));

    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 18),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _titleStyle),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Wrap(
                clipBehavior: Clip.none,
                runSpacing: 20,
                spacing: 20,
                children: widgets,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showOriginImage(List data, int idx) {
    Navigator.of(context).push(
      FadeRoute(
        page: PhotoViewGalleryScreen(
          images: data,
          index: idx,
        ),
      ),
    );
  }

  _buildAvatarWidget(DoctorQualificationModel model) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('头像', style: _titleStyle)),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ImageChooseWidget(
              width: 85,
              height: 85,
              url: model?.physicianInfoEntity?.fullFacePhoto?.url,
              addImgCallback: () => _selectPicture(TypeOperator.AVATAR),
              removeImgCallback: () {
                _model.setAvatar(null);
              },
              showOriginImgCallback: () {
                _showOriginImage(
                    [model?.physicianInfoEntity?.fullFacePhoto?.url], 0);
              },
            ),
            Container(
              width: 10,
            ),
            GestureDetector(
                child: Image.asset(
                  'assets/images/avatar_sample.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  width: 85,
                  height: 85,
                ),
                onTap: () {
                  _showSamplePicDialog('assets/images/sample_avatar.png', '头像');
                }),
            Container(
              width: 10,
            ),
            Expanded(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                  _hintTextStyle('个人正面免冠头像'),
                  _hintTextStyle('背景尽量使用白色'),
                  _hintTextStyle('着装需穿着工作服'),
                ]))),
          ])
        ],
      ),
    ));
  }

  _buildIdCardWidget(DoctorQualificationModel model) {
    List<String> data = [
      model?.physicianInfoEntity?.idCardLicense1?.url,
      model?.physicianInfoEntity?.idCardLicense2?.url
    ];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('身份证（需拍摄原件）', style: _titleStyle),
            ),
            Row(
              children: [
                Expanded(
                    child: ImageChooseWidget(
                  hintText: '人像面照片',
                  url: model?.physicianInfoEntity?.idCardLicense1?.url,
                  addImgCallback: () =>
                      _selectPicture(TypeOperator.ID_CARD_FACE_SIDE),
                  removeImgCallback: () => _model.setIdCardFaceSide(null),
                  showOriginImgCallback: () {
                    _showOriginImage(data, 0);
                  },
                )),
                Container(
                  width: 10,
                ),
                Expanded(
                    child: ImageChooseWidget(
                  hintText: '国徽面照片',
                  url: model?.physicianInfoEntity?.idCardLicense2?.url,
                  addImgCallback: () =>
                      _selectPicture(TypeOperator.ID_CARD_BG_SIDE),
                  removeImgCallback: () => _model.setIdCardBackgroundSide(null),
                  showOriginImgCallback: () {
                    _showOriginImage(data, 1);
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildPracticeWidget(DoctorQualificationModel model) {
    List<FacePhoto> originList =
        model?.physicianInfoEntity?.practiceCertificates ?? [];

    return _buildGrid(
        title: '医师执业证（至少需上传编码页和执业地点页）',
        list: originList,
        type: TypeOperator.PRACTICE_CERTIFICATES,
        sampleAssets: 'assets/images/practice.png',
        callback: (FacePhoto value, index) {
          _selectPicture(TypeOperator.PRACTICE_CERTIFICATES,
              facePhoto: value, index: index);
        },
        removeCallback: (idx) {
          _model.removePracticeCertificates(idx);
        });
  }

  _buildPhysicianWidget(DoctorQualificationModel model) {
    List<FacePhoto> originList =
        model?.physicianInfoEntity?.qualifications ?? [];

    return _buildGrid(
        title: '医师资格证（至少需上传头像页和毕业院校页）',
        list: originList,
        type: TypeOperator.QUALIFICATIONS,
        sampleAssets: 'assets/images/practice.png',
        callback: (FacePhoto value, index) {
          _selectPicture(TypeOperator.QUALIFICATIONS,
              facePhoto: value, index: index);
        },
        removeCallback: (idx) {
          _model.removeQualifications(idx);
        });
  }

  _buildProfessionWidget(DoctorQualificationModel model) {
    List<FacePhoto> originList =
        model?.physicianInfoEntity?.jobCertificates ?? [];

    return _buildGrid(
        title: '专业技术资格证',
        list: originList,
        type: TypeOperator.JOB_CERTIFICATES,
        sampleAssets: 'assets/images/practice.png',
        callback: (FacePhoto value, index) {
          _selectPicture(TypeOperator.JOB_CERTIFICATES,
              facePhoto: value, index: index);
        },
        removeCallback: (idx) {
          _model.removeJobCertificates(idx);
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
                  shape: BoxShape.circle, color: ThemeColor.primaryColor)),
          Text(text,
              style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 10))
        ],
      ),
    );
  }

  _selectPicture(TypeOperator type, {FacePhoto facePhoto, int index}) async {
    File image = await _pickImage(needCrop: type == TypeOperator.AVATAR);
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
      _model.setJobCertificates(image.path, facePhoto, index);
    }
    _model.notifyDataChange();
  }

  _pickImage({bool needCrop = false}) async {
    int index = await DialogHelper.showBottom(context);
    if (index == null || index == 2) {
      return;
    }
    File originFile = await ImageHelper.pickSingleImage(context,
        source: index, needCompress: false);
    if (originFile == null) {
      return null;
    }
    File cropedFile = originFile;
    if (needCrop) {
      cropedFile = await ImageHelper.cropImage(context, originFile.path);
    }
    File finalFile = await ImageHelper.compressImage(cropedFile);
    if (finalFile == null) {
      Toast.show('图片处理失败', context);
      return;
    }
    return finalFile;
  }

  _buildNoticeWidget(DoctorQualificationModel data) {
    var style = TextStyle(fontSize: 12, color: Colors.white);
    return Card(
      color: ThemeColor.colorFF8FC1FE,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('完成医师资质认证后，将为您开通复诊开方服务',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('平台认证有效后，即可开通电子处方功能', style: style)),
            Text('请您放心填写，以下信息仅供认证使用，我们将严格保密', style: style)
          ],
        ),
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

  _buildDoctorSignatureWidget(DoctorQualificationModel model) {
    print(model?.physicianInfoEntity?.toJson());
    var url = model?.physicianInfoEntity?.signature?.url;
    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(child: Text('电子签名', style: _titleStyle)),
                  if (url != null && url != '')
                    GestureDetector(
                      child: Text('点击此处修改签名', style: signatureTextStyle),
                      onTap: () => doSignature(model),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: DashedDecoration(
                        dashedColor: ThemeColor.colorFF8FC1FE,
                        gap: 3,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _signatureContent(url),
                    ),
                    onTap: () => doSignature(model),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _signatureContent(String url) {
    if (url != null && url != '') {
      return GestureDetector(
        child: Image.network(url, width: 108, height: 54),
        onTap: () => _showOriginImage([url], 0),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('点击此处去签名', style: signatureTextStyle),
          Container(
            margin: EdgeInsets.only(left: 4),
            child: Image.asset(
              'assets/images/signature_icon.png',
              width: 12,
              height: 12,
            ),
          ),
        ],
      );
    }
  }

  Future doSignature(DoctorQualificationModel model) async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    var path = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DoctorSignatureWidget(model?.physicianInfoEntity?.signature?.url),
      ),
    );
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    if (path == null || path == '') {
      return;
    }
    _model.setSignature(path);
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
