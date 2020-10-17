import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';
import 'package:doctor/route/route_manager.dart';

class LearnUploadRecordPage extends StatefulWidget {
  // final ResourceModel data;
  // LearnUploadRecordPage(this.data);
  LearnUploadRecordPage({Key key}) : super(key: key);

  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LearnUploadRecordPage> {
  TextEditingController _userDoctorName = TextEditingController();
  TextEditingController _userTaskName = TextEditingController();
  String _upDoctorName;
  String _upTaskName;

  @override
  void initState() {
    // 在initState中发出请求
    _upDoctorName = '';
    _upTaskName = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    // int learnPlanId;
    // int resourceId;
    String doctorName;
    String taskName;
    if (obj != null) {
      // learnPlanId = obj["learnPlanId"];
      // resourceId = obj['resourceId'];
      doctorName = obj['doctorName'];
      taskName = obj['taskName'];
      _userDoctorName.text = obj['doctorName'];
      _userTaskName.text = obj['taskName'];
      _upTaskName = obj['taskName'];
      _upDoctorName = obj['doctorName'];
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('讲课视频上传'),
        ),
        body: Container(
            color: ThemeColor.colorFFF3F5F8,
            child: Container(
              alignment: Alignment.topCenter,
              color: ThemeColor.colorFFF3F5F8,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: ListTile(
                          title: TextField(
                            keyboardType: TextInputType.multiline, //多行
                            textAlign: TextAlign.right,
                            controller: _userTaskName,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            style: TextStyle(color: ThemeColor.primaryColor),
                            onChanged: (value) {
                              _upTaskName = value;
                              print("$_upTaskName'11输入框 组件: $value");
                            },
                          ),
                          leading: Text('视频标题',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: ThemeColor.primaryColor,
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: ListTile(
                          title: TextField(
                            keyboardType: TextInputType.multiline, //多行
                            textAlign: TextAlign.right,
                            controller: _userDoctorName,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: ThemeColor.primaryColor),
                            onChanged: (value) {
                              _upDoctorName = value;
                              print("$_upDoctorName'输入框 组件: $value");
                            },
                          ),
                          leading: Text('主讲人',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: ThemeColor.primaryColor,
                              )),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                              padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
                              child: Text('上传视频',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: ThemeColor.primaryColor,
                                  )))
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
                              child: GestureDetector(
                                child: Image.asset(
                                  'assets/images/add_video.png',
                                  width: 150,
                                  height: 87,
                                ),
                                onTap: () {
                                  EasyLoading.showToast('添加视频');
                                },
                              ),
                            ),
                          ]),
                      AceButton(
                          text: '上传并提交',
                          onPressed: () => {
                                EasyLoading.showToast(
                                    '$_upDoctorName<<>> $_upTaskName')
                              }),
                    ],
                  ),
                ],
              ),
            )));
  }
}
