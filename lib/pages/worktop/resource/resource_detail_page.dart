import 'package:doctor/pages/worktop/resource/widgets/attachment.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class ResourceDetailPage extends StatefulWidget {
  @override
  _ResourceDetailPageState createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('资料详情'),
        elevation: 1,
      ),
      body: Container(
        color: ThemeColor.colorFFF3F5F8,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 100),
        child: Attacement('测试文档'),
      ),
    );
  }
}
