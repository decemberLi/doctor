import 'package:doctor/pages/message/common_style.dart';
import 'package:doctor/pages/worktop/resource/comment/comment_list_view.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/pages/worktop/resource/view_model/resource_view_model.dart';
import 'package:doctor/pages/worktop/resource/widgets/article.dart';
import 'package:doctor/pages/worktop/resource/widgets/attachment.dart';
import 'package:doctor/pages/worktop/resource/widgets/video.dart';
import 'package:doctor/pages/worktop/resource/widgets/questionPage.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/myIcons.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:flutter/material.dart';

class ResourceDetailPage extends StatefulWidget {
  @override
  _ResourceDetailPageState createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  bool logo = true;
  bool _startIcon = false;
  Widget resourceRender(ResourceModel data) {
    if (data.contentType == 'RICH_TEXT') {
      return Article(data);
    }
    if (data.resourceType == 'VIDEO') {
      return VideoDetail(data);
    }
    if (data.contentType == 'ATTACHMENT') {
      return Attacement(data);
    }
    if (data.resourceType == 'QUESTIONNAIRE') {
      return QuestionPage(data);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    int learnPlanId;
    int resourceId;
    if (obj != null) {
      learnPlanId = obj["learnPlanId"];
      resourceId = obj['resourceId'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('资料详情'),
        elevation: 0,
      ),
      body: ProviderWidget<ResourceDetailViewModel>(
        model: ResourceDetailViewModel(resourceId, learnPlanId),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Container();
          }
          if (model.isError || model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: model.initData);
          }
          var data = model.data;
          return Container(
            color: ThemeColor.colorFFF3F5F8,
            child: resourceRender(data),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          constraints: BoxConstraints(
            minHeight: 40,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    setState(() {
                      logo = false;
                    });
                  },
                  onChanged: (text) {
                    print(text);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: '请输入您的问题或评价',
                    suffix: GestureDetector(
                      onTap: () {
                        print('发表评论');
                        // Navigator.pushNamed(context, RouteManager.FIND_PWD);
                      },
                      child: Text(
                        '发表',
                        style: TextStyle(
                            color: ThemeColor.primaryColor, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              logo
                  ? Container(
                      margin: EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          print('查看评论');
                          // CommonModal
                          CommonModal.showBottomSheet(context,
                              title: '评论区',
                              height: 660,
                              child: CommentListPage('381', '1129'));
                        },
                        child: Icon(
                          MyIcons.icon_talk,
                          size: 28,
                        ),
                      ))
                  : Text(''),
              logo
                  ? Container(
                      margin: EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _startIcon = !_startIcon;
                          });
                        },
                        child: Icon(
                          _startIcon
                              ? MyIcons.icon_star_fill
                              : MyIcons.icon_star,
                          size: 28,
                        ),
                      ))
                  : Text('')
            ],
          ),
        ),
      ),
    );
  }
}
