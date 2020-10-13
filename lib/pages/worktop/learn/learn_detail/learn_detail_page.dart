import 'package:flutter/material.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
// import 'package:doctor/pages/worktop/learn/learn_detail/learn_detail_item_wiget.dart';

// * @Desc: 计划详情页  */
class LearnDetailPage extends StatefulWidget {
  LearnDetailPage({Key key}) : super(key: key);

  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LearnDetailPage> {
  bool _isExpanded = true;

  // 列表
  List formList;
  initState() {
    // super.initState();
    formList = [
      {"title": '车牌号'},
      {"title": '车牌号1'},
      {"title": '车牌号2'},
      {"title": '车牌号32'},
      {"title": '车牌号42'},
      {"title": '车牌号52'},
      {"title": '车牌号62'},
    ];
  }

  Widget buildGrid() {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in formList) {
      tiles.add(new Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  // padding: EdgeInsets.symmetric(vertical: 6),
                  child: Transform(
                    //对齐方式
                    alignment: Alignment.topRight,
                    //设置扭转值
                    transform: Matrix4.rotationZ(-0.45),
                    //设置被旋转的容器
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.orange),
                      child: Text('文章',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                            backgroundColor: Color(0xff72c140),
                          )),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFDEDEE1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      margin:
                                          EdgeInsets.only(right: 4, bottom: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '待观看',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFDEDEE1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      margin:
                                          EdgeInsets.only(right: 4, bottom: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '反馈',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                // textAlign: TextAlign.left,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '2医学信息推广专员医学信息推广专员息推广专员${item['title']}',
                                style: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ])),
                  ),
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.of(context).pushNamed(RouteManager.LEARN_DETAIL);
                    // },
                    child: Container(
                      width: 108,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/logo.png',
                            width: 60,
                            height: 60,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )));
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
        );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('学习计划详情'),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          color: ThemeColor.colorFFF3F5F8,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Card(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: ThemeColor.primaryColor,
                                ),
                              ]),
                          leading: Text(_isExpanded ? '学习计划信息2' : '学习计划信息',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: ThemeColor.primaryColor,
                              )),
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          }),
                      ListTile(
                        title: Text('学习计划名称',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            )),
                        leading: Text('学习计划名称1',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('划类型',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            )),
                        leading: Text('学习计划类型',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('来自企业划类型',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            )),
                        leading: Text('来自企业',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            )),
                      ),
                      Divider(),
                      ListTile(
                        leading: Text('当前完成度：${'333%'}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: ThemeColor.primaryColor,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AceButton(
                        text: '提交学习计划',
                        onPressed: () => {EasyLoading.showToast('暂未开放')},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Card(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ListTile(
                        title: Text('资料列表',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: ThemeColor.primaryColor,
                            )))),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: buildGrid()),
            ],
          ),
        ));
  }
}
