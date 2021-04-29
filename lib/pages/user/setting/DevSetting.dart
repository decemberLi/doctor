import 'package:doctor/pages/user/setting/qr_code_view.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../root_widget.dart';

class DevSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DevSettingState();
  }
}

class _DevSettingState extends State<DevSetting> {
  TextEditingController _webController = TextEditingController();
  TextEditingController _proxyController = TextEditingController();

  @override
  void initState() {
    SharedPreferences.getInstance().then((e){
      _proxyController.text = e.getString("settingProxy");
    });
    super.initState();
  }

  Widget cell(Widget child) => Container(
        decoration: BoxDecoration(
            color: Color(0x66eeeeee),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          padding: EdgeInsets.all(12),
          child: child,
        ),
      );

  Widget web() => cell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              "Web",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              controller: _webController,
              decoration: InputDecoration(
                hintText: "请输入网址",
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.qr_code_scanner_outlined),
                  onPressed: () {
                    Navigator.of(this.context).push(MaterialPageRoute(builder: (context)=>QRCodePage()));
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                TextButton(
                  child: Text("前往"),
                  onPressed: () {
                    MedcloudsNativeApi.instance()
                        .openWebPage(_webController.text);
                  },
                )
              ],
            )
          ],
        ),
      );

  Widget proxy() => cell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              "Proxy",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              controller: _proxyController,
              decoration: InputDecoration(
                hintText: "DIRECT",
              ),
            ),
            Row(
              children: [
                Expanded(child: Container()),
                TextButton(
                    onPressed: () async {
                      var text = _proxyController.text;
                      if (text.length == 0) {
                        text = "DIRECT";
                      }
                      var sp = await SharedPreferences.getInstance();
                      sp.setString("settingProxy", text);
                      HttpManager.shared.findProxy = () {
                        return "PROXY $text";
                      };
                    },
                    child: Text("设置")),
              ],
            )
          ],
        ),
      );

  Widget info() => cell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              "Info",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            GestureDetector(
              onTap: (){
                EasyLoading.showToast("复制成功");
                Clipboard.setData(ClipboardData(text: windowDeviceToken));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Text(
                      "DeviceToken",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(windowDeviceToken,textAlign: TextAlign.end,),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开发设置"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              web(),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              proxy(),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              info(),
            ],
          ),
        ),
      ),
    );
  }
}
