import 'package:doctor/http/common_service.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/theme/myIcons.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/pdf_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Attacement extends StatefulWidget {
  final ResourceModel data;
  final openTimer;
  final closeTimer;
  final _clickWebView;

  Attacement(this.data, this.openTimer, this.closeTimer, this._clickWebView);

  @override
  State<StatefulWidget> createState() => _AttacementState();
}

class _AttacementState extends State<Attacement> {
  _openFile() async {
    var files = await CommonService.getFile({
      'ossIds': [widget.data.attachmentOssId]
    });
    if (files.isEmpty) {
      EasyLoading.showToast('打开失败');
    }
    CustomerPDFViewer.openDefaultPreViewPage(context,
        widget.data.title ?? widget.data.resourceName, files[0]['tmpUrl']);
    //计时器
    widget.openTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget._clickWebView();
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Icon(
              MyIcons.icon_article,
              size: 80,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.data.title ?? widget.data.resourceName,
              style: TextStyle(
                color: ThemeColor.colorFF444444,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AceButton(
              onPressed: _openFile,
              text: '在线阅读',
            ),
          ],
        ),
      ),
    );
  }
}
