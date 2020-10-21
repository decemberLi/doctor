import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSelectedCallback<T> = void Function<T extends SearchModel>(
    T value, int position);

typedef OnMultiSelectedCallback<T> = void Function<T extends SearchModel>(
    List<T> values, List<int> positions);

typedef OnSearchConditionCallback = void Function(String condition);

mixin SearchModel {
  String faceText() => '搜索';
}

class SearchBar extends StatefulWidget {
  final OnSearchConditionCallback searchConditionCallback;
  final IconData searchIcon;
  final String hintText;

  SearchBar(
    this.hintText, {
    IconData searchIcon,
    this.searchConditionCallback,
  })  : assert(hintText != null),
        this.searchIcon = searchIcon == null ? Icons.search : searchIcon;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    _textEditingController.addListener(() {
      if (widget.searchConditionCallback != null) {
        widget.searchConditionCallback(_textEditingController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            color: ThemeColor.colorFF999999,
            size: 24,
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                      color: ThemeColor.colorFF999999, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchWidget<T extends SearchModel> extends StatefulWidget {
  Widget child;
  String title;

  String hintText;
  List<T> data;
  bool multiChoose;

  OnSearchConditionCallback searchConditionCallback;
  OnSelectedCallback<T> callback;
  OnMultiSelectedCallback<T> multiCallback;

  SearchWidget(
    this.title, {
    this.hintText,
    this.child,
    this.data,
    this.multiChoose = false,
    this.searchConditionCallback,
    this.callback,
    this.multiCallback,
  }) : assert(multiChoose ? multiCallback != null : true);

  @override
  State<SearchWidget> createState() => _SearchWidget();
}

class _SearchWidget extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text(widget.title ?? ''),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            SearchBar(widget.hintText ?? '',
                searchConditionCallback: widget.searchConditionCallback),
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.data?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: ThemeColor.colorLine))),
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        widget.data[index]?.faceText(),
                        style: const TextStyle(
                            color: ThemeColor.colorFF000000, fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      print('index -> $index');
                      if (widget.callback != null) {
                        widget.callback(widget.data[index], index);
                      }
                      Navigator.pop(context, widget.data[index]);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
