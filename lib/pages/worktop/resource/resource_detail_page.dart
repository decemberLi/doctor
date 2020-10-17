import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/pages/worktop/resource/view_model/resource_view_model.dart';
import 'package:doctor/pages/worktop/resource/widgets/article.dart';
import 'package:doctor/pages/worktop/resource/widgets/attachment.dart';
import 'package:doctor/pages/worktop/resource/widgets/video.dart';
import 'package:doctor/pages/worktop/resource/widgets/questionPage.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class ResourceDetailPage extends StatelessWidget {
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
    );
  }
}
