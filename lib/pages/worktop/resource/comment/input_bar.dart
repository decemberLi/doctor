import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

typedef OnPublishCallback = bool Function(String text);

typedef OnChange = Function(String text);
typedef OnCleanCacheDataCallback = Function(String);

class InputBarHelper {
  static String _lastCallerId;
  static String _cachedContent;

  static showInputBar(
    BuildContext context,
    String hintText,
    String commentTo,
    String callerId,
    String replayContent,
    OnPublishCallback callback,
  ) async {
    if (_lastCallerId != callerId) {
      _cachedContent = null;
    }
    _lastCallerId = callerId;
    await showModalBottomSheet(
      backgroundColor: ThemeColor.colorFFFAFAFA,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (ctx, state) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 20),
            child: IntrinsicHeight(
              child: InputBarWidget(
                commentTo,
                replayContent,
                hintText,
                _cachedContent,
                callback,
                (text) {
                  _cachedContent = text;
                },
              ),
            ),
          );
        });
      },
    );
    return _cachedContent;
  }

  static reset() {
    _cachedContent = '';
  }
}

class InputBarWidget extends StatefulWidget {
  final String commentTo;
  final String replayContent;
  final bool isReply;
  final String hintText;
  final String cachedContent;
  final OnPublishCallback callback;
  final OnChange onChange;

  InputBarWidget(
    this.commentTo,
    this.replayContent,
    this.hintText,
    this.cachedContent,
    this.callback,
    this.onChange,
  ) : isReply = commentTo != null &&
            commentTo != '' &&
            replayContent != null &&
            replayContent != '';

  @override
  State<StatefulWidget> createState() => InputBarWidgetState();
}

class InputBarWidgetState extends State<InputBarWidget> {
  FocusNode _commentFocusNode = FocusNode();
  final _kvn = KeyboardVisibilityController();
  var length = 0;
  int _subscribeId;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.cachedContent;
    length = widget?.cachedContent?.length ?? 0;
    _kvn.onChange.listen(
       (visible) {
        if (!visible) {
          _commentFocusNode.unfocus();
          if (ModalRoute.of(context).isCurrent) {
            Navigator.pop(context);
          }
        }
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var container = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 8, right: 8, top: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.isReply)
            _buildCommendArea(widget.commentTo, widget.replayContent),
          TextField(
            style: TextStyle(fontSize: 14),
            minLines: 1,
            maxLines: 5,
            controller: _controller,
            focusNode: _commentFocusNode,
            enableInteractiveSelection: true,
            autofocus: true,
            onChanged: (text) {
              if (widget.onChange != null) {
                widget.onChange(text);
              }
              setState(() {
                length = text?.length ?? 0;
              });
            },
            decoration: InputDecoration(
                counterText: "",
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: ThemeColor.colorFFD9D5D5,
                  ),
                ),
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: ThemeColor.colorFFD9D5D5,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: ThemeColor.colorFF999999)),
            cursorHeight: 20,
          ),
          _buildPublishArea(),
        ],
      ),
    );

    return container;
  }

  _buildCommendArea(String commentTo, String replyContent) {
    return Container(
      padding: EdgeInsets.only(bottom: 12, top: 6, left: 2, right: 2),
      width: double.infinity,
      child: Text(
        '回复 $commentTo: $replyContent',
        style: TextStyle(color: ThemeColor.colorFF999999, fontSize: 14),
      ),
    );
  }

  _buildPublishArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Text('$length',
                    style: TextStyle(
                        color: length > 150
                            ? ThemeColor.colorFFF67777
                            : ThemeColor.colorFF999999,
                        fontSize: 16)),
                Text(
                  '/150',
                  style:
                      TextStyle(color: ThemeColor.colorFF999999, fontSize: 16),
                )
              ],
            ),
          ),
          GestureDetector(
            child: Text(
              '发表',
              style: TextStyle(color: ThemeColor.primaryColor, fontSize: 16),
            ),
            onTap: debounce(() async {
              if (_controller.text == null || _controller.text.length == 0) {
                EasyLoading.showToast('${widget.hintText}内容不能为空');
                return;
              }
              if (_controller.text.length > 150) {
                EasyLoading.showToast('字数超过限制');
                return;
              }
              if (widget.callback(_controller.text)) {
                Navigator.pop(context);
              }
            }),
          ),
        ],
      ),
    );
  }
}
