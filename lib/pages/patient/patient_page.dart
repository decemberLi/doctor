import 'package:doctor/pages/patient/model/patient_model.dart';
import 'package:doctor/pages/patient/view_model/patient_view_model.dart';
import 'package:doctor/pages/patient/widget/patient_list_item.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 随诊患者列表
class PatientListPage extends StatefulWidget {
  PatientListPage();

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage>
    with AutomaticKeepAliveClientMixin {
  // 保持不被销毁
  @override
  bool get wantKeepAlive => true;

  Future<bool> confirmDialog(String name) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("确定要发送处方给$name吗?"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            FlatButton(
              child: Text(
                "确定",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var prescriptionNo = ModalRoute.of(context).settings.arguments;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(prescriptionNo != null ? '选择随诊患者' : '我的随诊患者'),
      ),
      body: Container(
        color: ThemeColor.colorFFF3F5F8,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.zero,
        child: ProviderWidget<PatientListViewModel>(
          model: PatientListViewModel(''),
          onModelReady: (model) => model.initData(),
          builder: (context, model, child) {
            Widget body;
            if (model.isError || model.isEmpty) {
              model.patientName = '';
              body = ViewStateEmptyWidget(
                message: '暂无随诊患者，快去开处方吧',
                onPressed: model.initData,
              );
            } else {
              body = SmartRefresher(
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
                    PatientModel item = model.list[index];
                    return GestureDetector(
                      child: PatientListItem(item),
                      onTap: () async {
                        if (prescriptionNo != null) {
                          if (prescriptionNo == 'QUICK_CREATE') {
                            Navigator.pop(context, item.patientUserId);
                          } else {
                            bool bindConfirm =
                                await confirmDialog(item.patientName);
                            if (bindConfirm) {
                              bool success = await model.bindPrescription(
                                patientUserId: item.patientUserId,
                                prescriptionNo: prescriptionNo as String,
                              );
                              if (success) {
                                EasyLoading.showToast('发送成功');
                                Navigator.of(context).pop(true);
                              }
                            }
                          }
                        } else {
                          Navigator.of(context).pushNamed(
                              RouteManager.PATIENT_DETAIL,
                              arguments: item.patientUserId);
                        }
                      },
                    );
                  },
                ),
              );
            }

            return Column(
              children: [
                Container(
                  height: 56,
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
                  child: Theme(
                    data: new ThemeData(primaryColor: Colors.white),
                    child: TextField(
                      onSubmitted: (text) {
                        model.patientName = text;
                        model.initData();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        fillColor: Color(0XFFF3F5F8),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          //未选中时候的颜色
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintText: '请输入患者名字',
                        hintStyle: TextStyle(color: Color(0xff999999)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: body,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
