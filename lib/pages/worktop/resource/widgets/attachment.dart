import 'package:doctor/http/common_service.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/theme/myIcons.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/pdf_Viewer_adapter.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AttacementWidget extends StatefulWidget {
  final ResourceModel data;
  final openTimer;
  final closeTimer;
  final _clickWebView;

  AttacementWidget(
      this.data, this.openTimer, this.closeTimer, this._clickWebView);

  @override
  State<StatefulWidget> createState() => Attacement();
}

class Attacement extends State<AttacementWidget> with WidgetsBindingObserver {
  _openFile(BuildContext context) async {
    var files = await CommonService.getFile({
      'ossIds': [widget.data.attachmentOssId]
    });
    if (files.isEmpty) {
      EasyLoading.showToast('打开失败');
    }
    //计时器
    widget.openTimer();
    await PdfViewerAdapter.openFile(
      files[0]['tmpUrl'],
      title: widget.data.title ?? widget.data.resourceName,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('--------------------$state');
    if (state == AppLifecycleState.resumed) {
      widget.closeTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
              onPressed: () {
                _openFile(context);
              },
              text: '在线阅读',
            ),
          ],
        ),
      ),
    );
  }
}
