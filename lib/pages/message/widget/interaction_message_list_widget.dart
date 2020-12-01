import 'package:doctor/pages/message/view_model/interaction_message_list_view_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/refreshable_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum InteractionType {
  TYPE_LIKE,
  TYPE_COMMENT,
}

class InteractionMessagePage extends StatefulWidget {
  final InteractionType type;

  InteractionMessagePage(this.type);

  @override
  State<StatefulWidget> createState() => _InteractionMessagePageState();
}

class _InteractionMessagePageState extends State<InteractionMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.type == InteractionType.TYPE_LIKE ? '收到的赞' : '收到的评论',
          style: TextStyle(fontSize: 17, color: ThemeColor.colorFF000000),
        ),
      ),
      body: _InteractionMessageListWidget(),
    );
  }
}

class _InteractionMessageListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InteractionMessageListWidgetState();
}

class _InteractionMessageListWidgetState extends AbstractListPageState<
    InteractionMessageListViewModel, _InteractionMessageListWidget> {
  @override
  InteractionMessageListViewModel getModel() =>
      InteractionMessageListViewModel();

  @override
  Widget itemWidget(BuildContext context, int index) {
    return _InteractionMessageListWidget();
  }
}
