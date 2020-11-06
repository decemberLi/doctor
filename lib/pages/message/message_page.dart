import 'package:doctor/main.dart';
import 'package:doctor/pages/message/view_model/message_center_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common_style.dart';
import 'message_list_page.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with RouteAware {
  MessageCenterViewModel _model = MessageCenterViewModel();

  @override
  void dispose() {
    print('work_top_dispose');
    _model.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPopNext() async {
    MessageCenterViewModel model =
        Provider.of<MessageCenterViewModel>(context, listen: false);
    await model.initData();
    super.didPopNext();
  }

  Widget messageItem(
      String lable, String img, int msgCount, callBack, int index,
      {Color dotColor = Colors.red}) {
    return Container(
      margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
      decoration: index == 4
          ? BoxDecoration()
          : BoxDecoration(
              border: Border(bottom: Divider.createBorderSide(context)),
            ),
      child: ListTile(
        title: Text(
          lable,
          style: fontStyle,
        ),
        leading: Image.asset(
          img,
          width: 24,
          height: 24,
        ),
        trailing: Stack(
          overflow: Overflow.visible,
          children: [
            Icon(Icons.keyboard_arrow_right),
            Positioned(
              left: -20,
              top: 4,
              child: Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: dotColor,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                constraints: BoxConstraints(
                  minWidth: 24,
                  minHeight: 16,
                ),
                child: Center(
                    child: Text(
                  msgCount > 99 ? '99+' : '$msgCount',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ],
        ),
        onTap: () {
          callBack();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('消息中心'),
        elevation: 0,
      ),
      body: Consumer<MessageCenterViewModel>(
        builder: (context, model, child) {
          var systemCount = model?.data?.systemCount ?? 0;
          var leanPlanCount = model?.data?.leanPlanCount ?? 0;
          var prescriptionCount = model?.data?.prescriptionCount ?? 0;
          var interactiveCount = model?.data?.interactiveCount ?? 0;
          return Container(
            padding: EdgeInsets.only(bottom: 5),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                messageItem(
                    '系统通知', 'assets/images/msg_system_notice.png', systemCount,
                    () {
                  goMessageList(MessageType.TYPE_SYSTEM);
                }, 1, dotColor: _dotColor(systemCount)),
                messageItem(
                    '学习计划', 'assets/images/msg_learn_plan.png', leanPlanCount,
                    () {
                  goMessageList(MessageType.TYPE_LEAN_PLAN);
                }, 2, dotColor: _dotColor(leanPlanCount)),
                messageItem(
                    '患者处方', 'assets/images/msg_interact.png', prescriptionCount,
                    () {
                  goMessageList(MessageType.TYPE_PRESCRIPTION);
                }, 3, dotColor: _dotColor(prescriptionCount)),
                messageItem(
                    '互动消息', 'assets/images/msg_patient.png', interactiveCount,
                    () {
                  goMessageList(MessageType.TYPE_INTERACTIVE);
                }, 4, dotColor: _dotColor(interactiveCount)),
              ],
            ),
          );
        },
      ),
    );
  }

  _dotColor(int count) {
    return (count ?? 0) == 0 ? Colors.transparent : ThemeColor.colorFFF57575;
  }

  goMessageList(String type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageListPage(type)),
    );
    _model.initData();
  }
}
