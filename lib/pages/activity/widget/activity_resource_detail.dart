import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor/http/activity.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/entity/activity_resources_entity.dart';
import 'package:doctor/route/fade_route.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/enhance_photo_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:provider/provider.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

class _ImageResource {
  // 0 is local path, 1 is url
  Uint8List thumbData;
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
  String status;
  String rejectReason;

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

  int imagesSize() {
    return length < MAX_COUNT ? length + 1 : length;
  }

  int get enableAddImageSize => MAX_COUNT - length;

  int get length => _list.length;

  _ImageResource getImage(int index) => _list[index];

  List<_ImageResource> getAllImage() => _list;

  submit() async {
    var localRes = _list.where((element) => element.type == 0).toList();
    // upload pic
    List<Future<OssFileEntity>> futires = [];
    for (int i = 0; i < localRes.length; i++) {
      var toBeUploadEntity = localRes[i];
      var eachF = OssService.upload(localRes[i].uri, showLoading: false);
      futires.add(eachF);
      eachF.then((OssFileEntity entity) {
        toBeUploadEntity.ossRes = entity;
      });
      if (futires.length == 4) {
        await Future.wait(futires);
        futires.clear();
      }
    }
    await Future.wait(futires);
    List<Map<String, dynamic>> picList = [];
    for (int index = 0; index < length; index++) {
      var each = _list[index];
      var r = each.ossRes;
      var pos = r.name.lastIndexOf('.');
      String suffix = '';
      if (pos > 0 && pos < each.uri.length) {
        suffix = each.ossRes.name.substring(pos);
      }
      r.name = '病例图片-${index + 1}$suffix';
      r.type = 'CASE_COLLECTION_PIC';
    }
    _list.forEach((element) {
      picList.add(element.ossRes.toJson());
    });

    // post to server
    return await API.shared.activity.saveActivityCaseCollection(
        activityId, picList,
        activityTaskId: taskId);
  }

  void obtainTaskResources() {
    EasyLoading.instance.flash(() async {
      var result =
          await API.shared.activity.activityCaseCollectionDetail(taskId);
      var entity = ActivityResourceEntity(result);
      taskId = entity.activityTaskId;
      activityId = entity.activityPackageId;
      rejectReason = entity.rejectReason;
      status = entity.status;
      addImages(entity.attachments
          .map((e) => _ImageResource(1, e.url, ossRes: e))
          .toList());
    });
  }

  bool canEdit() => status == VERIFY_STATUS_REJECT || taskId == null;
}

@RoutePage(name: "case_collection_page")
class ActivityResourceDetailPage extends StatefulWidget {
  final String _titleText;
  final String status;
  final int activityPackageId;
  final int activityTaskId;
  final String rejectReason;

  ActivityResourceDetailPage(this.activityPackageId, this.activityTaskId,
      {this.status, this.rejectReason})
      : _titleText = status == null ? '新增病例征集' : '病例详情';

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
    if (widget.activityTaskId != null) {
      _model.obtainTaskResources();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
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
                        Consumer<_ImageResourceModel>(
                          builder: (context, _ImageResourceModel model, child) {
                            if (model.status != VERIFY_STATUS_REJECT) {
                              return Container();
                            }
                            return Container(
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(left: 16, right: 16, top: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text(
                                '驳回理由：${_model.rejectReason}',
                                style: TextStyle(
                                    color: Color(0xFFFECE35), fontSize: 14),
                              ),
                            );
                          },
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
                                builder: (context, _ImageResourceModel model,
                                    child) {
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
                                    itemCount: _model.imagesSize(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: _pictureArea(
                                            index, model.canEdit()),
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
                    Consumer<_ImageResourceModel>(
                      builder: (context, _ImageResourceModel model, child) {
                        bool enable = model.length > 0;
                        if (!model.canEdit()) {
                          return Container();
                        }
                        return Positioned(
                          bottom: 28,
                          child: AceButton(
                            type: enable
                                ? AceButtonType.primary
                                : AceButtonType.secondary,
                            textColor: Colors.white,
                            text: '提交病例',
                            onPressed: () {
                              if (!enable || EasyLoading.isShow) {
                                return;
                              }
                              EasyLoading.instance.flash(() async {
                                await _model.submit();
                                Navigator.pop(context, true);
                              });
                            },
                          ),
                        );
                      },
                    )
                  ],
                );
              }),
        ),
        onWillPop: () {
          EasyLoading.dismiss();
          return Future.value(true);
        });
  }

  Widget _pictureArea(index, bool canEdit) {
    if (index < 0 || index >= _model.length) {
      if (canEdit) {
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
              selectedImg.addAll(result
                  .map((e) => _ImageResource(0, e.originFile.path)
                    ..thumbData = e.thumbData)
                  .toList());
            }
            _model.addImages(selectedImg);
          },
        );
      } else {
        return Container();
      }
    }
    var res = _model.getImage(index);
    Widget imgWidget;
    if (res.type == 0) {
      if (res.thumbData == null) {
        debugPrint("YYYPicture -> thumbData is null");
        imgWidget = Image.file(
          File(res.uri),
          width: 74,
          height: 60,
          fit: BoxFit.cover,
        );
      } else {
        debugPrint("YYYPicture -> load picture is thumb Data");
        imgWidget = Image.memory(
          res.thumbData,
          width: 74,
          height: 60,
          fit: BoxFit.cover,
        );
      }
    } else {
      imgWidget = CachedNetworkImage(
        imageUrl: res.uri,
        width: 74,
        height: 60,
        fit: BoxFit.cover,
        memCacheWidth: 74,
        memCacheHeight: 60,
        filterQuality: FilterQuality.high,
        cacheKey: '${res.uri.hashCode}',
        progressIndicatorBuilder: (
          BuildContext context,
          String url,
          DownloadProgress progress,
        ) {
          return GestureDetector(
            child: Container(
              color: ThemeColor.colorFFEDEDED,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: progress.progress,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            onTap: () {},
          );
        },
        errorWidget: (context, url, error) => Icon(Icons.error),
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
        if (canEdit)
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
