import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/activity_detail.dart';
import 'package:doctor/pages/activity/activity_research.dart';
import 'package:doctor/pages/activity/widget/activity_resource_detail.dart';
import 'package:doctor/pages/message/model/message_list_entity.dart';
import 'package:doctor/pages/message/view_model/message_list_view_model.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///
/// 医生消息列表
/// 消息类型
/// SYSTEM 系统消息,
/// PRESCRIPTION 处方消息，
/// LEAN_PLAN 学习计划消息，
/// INTERACTIVE 互动消息
///
///
class MessageType {
  static const String TYPE_SYSTEM = 'SYSTEM';
  static const String TYPE_ACTIVITY = 'ACTIVITY';
  static const String TYPE_PRESCRIPTION = 'PRESCRIPTION';
  static const String TYPE_LEAN_PLAN = 'LEAN_PLAN';
  static const String TYPE_INTERACTIVE = 'INTERACTIVE';
}

class MessageListPage extends StatefulWidget {
  final String _type;
  final Map<String, String> _map = {
    MessageType.TYPE_SYSTEM: '系统消息',
    MessageType.TYPE_PRESCRIPTION: '处方消息',
    MessageType.TYPE_LEAN_PLAN: '学习计划消息',
    MessageType.TYPE_INTERACTIVE: '互动消息',
    MessageType.TYPE_ACTIVITY: '活动通知',
  };

  MessageListPage(this._type);

  @override
  State<StatefulWidget> createState() {
    return _MessageListPageState();
  }
}

class _MessageListPageState extends State<MessageListPage> {
  MessageListModel _model;

  @override
  void initState() {
    super.initState();
    _model = MessageListModel(widget._type);
  }

  @override
  Widget build(BuildContext context) {
    Widget itemWidget(MessageListEntity entity) {
      bool alreadyRead = entity?.readed ?? false;
      return Column(
        children: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      _icon(entity),
                      Positioned(
                          right: 3,
                          top: 0,
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: alreadyRead
                                    ? Colors.transparent
                                    : Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                          ))
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  entity?.messageTitle ?? '',
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(0xFF0B0B0B), fontSize: 14),
                                ),
                              ),
                              Text(
                                dateFormat(entity?.createTime),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Color(0xFF0B0B0B), fontSize: 10),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              entity?.messageContent ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => _openDetail(widget._type, entity),
          ),
          Container(height: 8)
        ],
      );
    }

    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        elevation: 0,
        title: Text('${widget._map[widget._type]}'),
      ),
      body: ProviderWidget<MessageListModel>(
        model: MessageListModel(widget._type),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          if (model.isError || model.isEmpty) {
            return ViewStateEmptyWidget(
              message: '暂无消息通知',
              onPressed: model.initData,
              isShowRefreshBtn: false,
            );
          }
          return SmartRefresher(
            controller: model.refreshController,
            header: ClassicHeader(),
            footer: ClassicFooter(),
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            enablePullUp: true,
            child: ListView.builder(
                itemCount: model.list.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  MessageListEntity item = model?.list[index];
                  if (item == null) {
                    return itemWidget(null);
                  }
                  return itemWidget(item);
                }),
          );
        },
      ),
    );
  }

  _icon(MessageListEntity entity) {
    if (entity.bizType == 'PRESCRIPTION_REJECT' ||
        entity.bizType == 'AUTH_STATUS_FAIL') {
      return Image.asset(
        'assets/images/reject.png',
        width: 40,
        height: 40,
      );
    }
    if (entity.bizType == 'DOCTOR_RE_LEARN') {
      return Image.asset(
        'assets/images/re_visit.png',
        width: 40,
        height: 40,
      );
    }
    if (entity.bizType == 'AUTH_STATUS_PASS') {
      return Image.asset(
        'assets/images/pass.png',
        width: 40,
        height: 40,
      );
    }

    return ImageWidget(
      url: entity.createUserHeadPic,
      width: 40,
      height: 40,
    );
  }

  _openDetail(String type, MessageListEntity entity) async {
    print("the auth is ---- ");
    if (type == MessageType.TYPE_SYSTEM) {
      // 获取用户当前审核状态
      UserInfoViewModel userModel =
          Provider.of<UserInfoViewModel>(context, listen: false);
      await userModel.queryDoctorInfo();
      if (userModel.data == null) {
        EasyLoading.showToast('获取用户审核状态失败');
        return;
      }
      var doctorData = userModel.data;
      if (doctorData?.identityStatus == 'PASS') {
        if (doctorData?.authStatus == 'WAIT_VERIFY' ||
            doctorData.authStatus == 'FAIL') {
          Navigator.pushNamed(context, RouteManager.DOCTOR_AUTHENTICATION_PAGE);
        } else if (doctorData.authStatus == 'VERIFYING') {
          Navigator.pushNamed(
              context, RouteManager.DOCTOR_AUTH_STATUS_VERIFYING_PAGE);
        } else if (doctorData.authStatus == 'PASS') {
          Navigator.pushNamed(
              context, RouteManager.DOCTOR_AUTH_STATUS_PASS_PAGE);
        }
      } else {
        Navigator.pushNamed(
            context, RouteManager.DOCTOR_AUTHENTICATION_INFO_PAGE);
      }
    } else if (type == MessageType.TYPE_LEAN_PLAN) {
      if (entity.params == null || entity.params['learnPlanId'] == null) {
        return;
      }
      Navigator.pushNamed(context, RouteManager.LEARN_DETAIL, arguments: {
        'learnPlanId': entity.params['learnPlanId'],
      });
    } else if (type == MessageType.TYPE_PRESCRIPTION) {
      if (entity.params == null || entity.params['prescriptionNo'] == null) {
        return;
      }
      Navigator.pushNamed(context, RouteManager.PRESCRIPTION_DETAIL,
          arguments: entity.params['prescriptionNo']);
    } else if (type == MessageType.TYPE_INTERACTIVE) {
      Navigator.of(context).pushNamed(RouteManager.RESOURCE_DETAIL, arguments: {
        "resourceId": entity.params['resourceId'],
        "learnPlanId": entity.params['learnPlanId'],
        'from': 'MESSAGE_CENTER'
      });
    } else if (type == 'ACTIVITY') {
      if (entity.params['activityType'] == 'CASE_COLLECTION' || entity.params['activityType'] == 'RWS') {
        // go 病例驳回 资料详情
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ActivityResourceDetailPage(
            entity.params['activityPackageId'],
            entity.params['activityTaskId'],
            status: VERIFY_STATUS_REJECT,
            rejectReason: entity.params['rejectReason'],
          );
        }));
      } else if (entity.params['activityType'] == 'MEDICAL_SURVEY') {
        // go 医学调研驳回 资料详情
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ActivityResearch(
            entity.params['activityPackageId'],
            activityTaskId: entity.params['activityTaskId'],
          );
        }));
      }
    } else if (type == 'ASSIGN_STUDY_ACTIVITY') {
      // 指派活动进活动详情页
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ActivityDetail(
            entity.params['activityPackageId'], entity.params['activityType']);
      }));
    }
    _model.mark('${entity.messageId}');
    entity.readed = true;
    setState(() {});
  }
}
