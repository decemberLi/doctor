import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:doctor/model/face_photo.dart';
import 'package:doctor/pages/qualification/image_choose_widget.dart';
import 'package:doctor/pages/user/auth/viewmodel/auth_step2_view_model.dart';
import 'package:doctor/route/fade_route.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/photo_view_gallery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'crude_progress_widget.dart';

typedef OnItemCallback = Function(FacePhoto model, int index);
typedef OnRemoveImageCallback = void Function(int index);

class DoctorAuthenticationStepTwoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoctorAuthenticationStepTwoPageState();
}

class DoctorAuthenticationStepTwoPageState
    extends State<DoctorAuthenticationStepTwoPage> {
  var _model = AuthenticationStep2ViewModel();

  @override
  Widget build(BuildContext context) {
    Widget rootWidget = SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColor.colorFFF3F5F8,
        appBar: AppBar(
          title: Text('医师身份认证'),
          elevation: 0,
        ),
        body: ChangeNotifierProvider<AuthenticationStep2ViewModel>.value(
          value: _model,
          child: Consumer<AuthenticationStep2ViewModel>(
            builder: (context, model, child) {
              return Container(
                color: const Color(0xFFF3F5F8),
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonTips(),
                          if (!TextUtil.isEmpty(model.data?.rejectReson))
                            failTips(model.data?.rejectReson),
                          CrudeProgressWidget(2),
                          Container(
                            margin:
                                EdgeInsets.only(top: 12, left: 16, right: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildGrid(
                                  title: "上传证件照",
                                  list: model.data.qualifications ?? [],
                                  callback: (FacePhoto value, int index) async {
                                    var selectedFile = await _pickImage();
                                    if (selectedFile == null) {
                                      return;
                                    }
                                    model.addImage(selectedFile, value, index);
                                  },
                                  removeCallback: (int index) {
                                    model.removeImage(index);
                                  },
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 40, left: 18),
                                  child: Text(
                                    "*支持执业证、资格证或者医师工作证等",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 30, right: 30, bottom: 26),
                          child: AceButton(
                            width: double.infinity,
                            type: model.canNext
                                ? AceButtonType.primary
                                : AceButtonType.grey,
                            text: TextUtil.isEmpty(model.data.rejectReson)
                                ? "提交"
                                : "重新提交",
                            onPressed: () async {
                              if(model.isCommitting){
                                return;
                              }
                              model.setIsCommitting(true);
                              model.commitAuthenticationData().then((success)async {
                                model.setIsCommitting(false);
                                await Navigator.pushNamed(
                                    context,
                                    RouteManager
                                        .DOCTOR_AUTH_STATUS_VERIFYING_PAGE);
                                Navigator.pop(context, true);
                              },onError: (error){
                                model.setIsCommitting(false);
                              });
                            },
                          ),
                        ))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
    _model.refreshData();
    return rootWidget;
  }

  commonTips() {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xFF88BEFF),
      height: 30,
      child: Text(
        "注：以下信息仅供认证使用，请您放心填写，我们将严格保密",
        style: const TextStyle(fontSize: 12, color: Color(0xFF222222)),
      ),
    );
  }

  failTips(String cause) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(16, 6, 16, 0),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '审核失败原因：',
            style:
                const TextStyle(fontSize: 16, color: const Color(0xFFFECE35)),
          ),
          Text(
            '${cause ?? ''}',
            style:
                const TextStyle(fontSize: 12, color: const Color(0xFFFECE35)),
          )
        ],
      ),
    );
  }

  _buildGrid({
    String title,
    List<FacePhoto> list,
    OnItemCallback callback,
    OnRemoveImageCallback removeCallback,
  }) {
    List<Widget> widgets = [];
    for (var idx = 0; idx < list.length; idx++) {
      FacePhoto photo = list[idx];
      widgets.add(ImageChooseWidget(
        width: 85,
        url: photo?.url,
        addImgCallback: () {
          print("addImgCallback");
          callback(photo, idx);
        },
        removeImgCallback: () {
          removeCallback(idx);
        },
        showOriginImgCallback: () {
          Navigator.of(context).push(
            FadeRoute(
              page: PhotoViewGalleryScreen(
                images: list.map((e) => e.url).toList(),
                index: idx,
              ),
            ),
          );
        },
      ));
    }
    if (widgets.length < 3) {
      widgets.add(ImageChooseWidget(
        url: null,
        width: 85,
        addImgCallback: () {
          callback(null, widgets.length);
        },
      ));
    }

    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 10, top: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold)),
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

  _addImage(FacePhoto value, int index) async {}

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
}
