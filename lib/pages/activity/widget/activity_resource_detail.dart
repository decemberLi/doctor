import 'dart:collection';

import 'package:doctor/http/activity.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/entity/activity_resources_entity.dart';
import 'package:doctor/route/fade_route.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/enhance_photo_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:provider/provider.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';

class _ImageResource {
  // 0 is local path, 1 is url
  int type;
  String uri;
  OssFileEntity ossRes;

  _ImageResource(this.type, this.uri, {this.ossRes});
}

class _ImageResourceModel extends ChangeNotifier {
  List<_ImageResource> _list = [];

  // ignore: non_constant_identifier_names
  int MAX_COUNT = 30;
  int activityId;
  int taskId;

  _ImageResourceModel(this.activityId, this.taskId,
      {List<_ImageResource> images}) {
    if (images != null) {
      _list.addAll(images);
    }
  }

  void addImages(List<_ImageResource> selectedImg) {
    if (selectedImg == null || selectedImg.isEmpty) {
      return;
    }
    _list.addAll(selectedImg);
    notifyListeners();
  }

  void remove(int index) {
    _list.removeAt(index);
    notifyListeners();
  }

  int get imagesSize => length < MAX_COUNT ? length + 1 : length;

  int get enableAddImageSize => MAX_COUNT - length;

  int get length => _list.length;

  _ImageResource getImage(int index) => _list[index];

  List<_ImageResource> getAllImage() => _list;

  submit() async {
    var localRes = _list.where((element) => element.type == 0).toList();
    // upload pic
    Map<int, _ImageResource> map = HashMap();
    List<Future<OssFileEntity>> futires = [];
    for (int i = 0; i < localRes.length; i++) {
      var toBeUploadEntity = localRes[i];
      var eachF = OssService.upload(localRes[i].uri);
      futires.add(eachF);
      eachF.then((OssFileEntity entity) => toBeUploadEntity.ossRes = entity);
    }
    await Future.wait(futires);
    List<Map<String, dynamic>> picList = [];
    for (int index = 0; index < length; index++) {
      var r = _list[index].ossRes;
      r.name = '病例图片-${index + 1}';
      r.type = 'CASE_COLLECTION';
    }
    _list.forEach((element) {
      picList.add(element.ossRes.toJson());
    });

    // post to server
    return await API.shared.activity.saveActivityCaseCollection(activityId, picList,
        activityTaskId: taskId);
  }

  void obtainTaskResources() {
    EasyLoading.instance.flash(() async {
      var result =
          await API.shared.activity.activityCaseCollectionDetail(taskId);
      var entity = ActivityResourceEntity(result);
      taskId = entity.activityTaskId;
      activityId = entity.activityPackageId;
      addImages(entity.attachments
          .map((e) => _ImageResource(1, e.url, ossRes: e))
          .toList());
    });
  }
}

class ActivityResourceDetailPage extends StatefulWidget {
  final String _titleText;
  final String status;
  final bool _isNotPass;
  final int activityPackageId;
  final int activityTaskId;

  ActivityResourceDetailPage(this.activityPackageId, this.activityTaskId,
      {this.status})
      : _titleText = status == null ? '新增病例征集' : '病例详情',
        _isNotPass = status == VERIFY_STATUS_REJECT;

  @override
  State<StatefulWidget> createState() => _ActivityResourceDetailPageState();
}

class _ActivityResourceDetailPageState
    extends State<ActivityResourceDetailPage> {
  _ImageResourceModel _model;

  @override
  void initState() {
    super.initState();
    _model =
        _ImageResourceModel(widget.activityPackageId, widget.activityTaskId);
    _model.obtainTaskResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F8),
      appBar: AppBar(
        title: Text(widget._titleText),
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
          create: (context) => _model,
          builder: (context, child) {
            return Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                ListView(
                  padding: EdgeInsets.only(bottom: 100),
                  children: [
                    // 审核未通过展示驳回理由
                    if (widget._isNotPass)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          '驳回理由：病例征集信息不完整',
                          style:
                              TextStyle(color: Color(0xFFFECE35), fontSize: 14),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                      padding: EdgeInsets.fromLTRB(25, 0, 10, 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 12),
                            child: Text(
                              '病例列表',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeColor.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Consumer(
                            builder:
                                (context, _ImageResourceModel model, child) {
                              return GridView.builder(
                                clipBehavior: Clip.none,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 35,
                                  mainAxisSpacing: 12,
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: _model.imagesSize,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: _pictureArea(index),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 28,
                  child: Consumer<_ImageResourceModel>(
                    builder: (context, _ImageResourceModel model, child) {
                      bool enable = model.length > 0;
                      return AceButton(
                        type: enable
                            ? AceButtonType.primary
                            : AceButtonType.secondary,
                        textColor: Colors.white,
                        text: '提交病例',
                        onPressed: () {
                          if (!enable) {
                            return;
                          }
                          EasyLoading.instance.flash(() async {
                            await _model.submit();
                            Navigator.pop(context, true);
                          });
                        },
                      );
                    },
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget _pictureArea(index) {
    if (index < 0 || index >= _model.length) {
      return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFD9E6F0), width: 1)),
          child: Icon(
            Icons.add,
            color: ThemeColor.colorLine,
          ),
        ),
        onTap: () async {
          int witch = await DialogHelper.showBottom(context);
          List<_ImageResource> selectedImg = [];
          if (witch == 0) {
            var result = await ImageHelper.pickSingleImage(context);
            if (result != null) {
              selectedImg.add(_ImageResource(0, result.path));
            }
          } else if (witch == 1) {
            var result = await ImageHelper.pickMultiImageFromGallery(context,
                max: _model.enableAddImageSize);
            selectedImg
                .addAll(result.map((e) => _ImageResource(0, e.path)).toList());
          }
          _model.addImages(selectedImg);
        },
      );
    }
    var res = _model.getImage(index);
    Widget imgWidget;
    if (res.type == 0) {
      imgWidget = Image.file(
        File(res.uri),
        width: 74,
        height: 60,
        fit: BoxFit.cover,
      );
    } else {
      imgWidget = Image.network(
        res.uri,
        fit: BoxFit.cover,
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          child: GestureDetector(
            child: imgWidget,
            onTap: () {
              _showOriginImage(_model.getAllImage(), index);
            },
          ),
        ),
        Positioned(
          right: -10,
          top: -10,
          child: GestureDetector(
            child: Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onTap: () {
              _model.remove(index);
            },
          ),
        )
      ],
    );
  }

  _showOriginImage(List<_ImageResource> data, int idx) {
    Navigator.of(context).push(
      FadeRoute(
        page: EnhancePhotoViewer(
          images: data.map((e) => ImageResources(e.type, e.uri)).toList(),
          index: idx,
        ),
      ),
    );
  }
}
