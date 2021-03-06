
import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/pages/doctors/model/in_screen_event_model.dart';
import 'package:doctor/pages/doctors/viewmodel/doctors_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../root_widget.dart';
import '../doctors_banner.dart';
import '../doctors_banner_item.dart';
import '../model/doctor_circle_entity.dart';
import 'doctors_circle_widget.dart';


class GossipNewsItemWidget extends StatelessWidget {
  final DoctorCircleEntity data;
  final VoidCallback onLikeClick;

  final List<Color> colors = [
    const Color(0xFF62C1FF),
    const Color(0xFF92E06B),
    const Color(0xFFFABB3E),
  ];

  GossipNewsItemWidget(this.data, this.onLikeClick);


  _staticsWidget(BuildContext context, icon, count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(icon),
          width: 20,
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(
            count,
            style: TextStyle(fontSize: 12, color: ThemeColor.colorFF999999),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Color(0xFF62C1FF),
                    borderRadius: new BorderRadius.all(Radius.circular(15))),
                child: Text(
                  data?.postUserName?.substring(0, 1) ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(data?.postUserName ?? '',
                    style: TextStyle(
                        fontSize: 14, color: ThemeColor.colorFF444444)),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text("${data?.postContent ?? ''} ",
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: data.read
                      ? ThemeColor.colorFFC1C1C1
                      : ThemeColor.colorFF222222,
                  height: 1.6,
                  letterSpacing: 0.6,
                )),
          ),
          _buildCommentArea(),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 6, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _staticsWidget(context, 'assets/images/gossip_view.png',
                    formatViewCount(data?.viewNum)),
                Spacer(),
                _staticsWidget(context, 'assets/images/gossip_comment.png',
                    '${formatViewCount(data?.commentNum) ?? ''}'),
                Spacer(),
                GestureDetector(
                  child: _staticsWidget(
                      context,
                      data.likeFlag ?? false
                          ? 'assets/images/liked_checked.png'
                          : 'assets/images/gossip_like.png',
                      '${formatViewCount(data?.likeNum) ?? ''}'),
                  onTap: () => onLikeClick(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCommentArea() {
    if (data.topComment == null) {
      return Container();
    }
    var commentTextStyle =
        TextStyle(fontSize: 12, color: ThemeColor.colorFF444444);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: ThemeColor.colorFFF8FAFD,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Color(0xFF62C1FF),
                      borderRadius: new BorderRadius.all(Radius.circular(15))),
                  child: Text(
                    data.topComment.commentUserName?.substring(0, 1) ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    data.topComment.commentUserName ?? '',
                    style: commentTextStyle,
                  ),
                )
              ],
            ),
            if (data.topComment.respondentUserName != null &&
                data.topComment.respondentContent != null)
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "?????? ${data.topComment.respondentUserName}???${data.topComment.respondentContent}",
                  style:
                      TextStyle(fontSize: 12, color: ThemeColor.colorFF999999),
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                '${data.topComment.commentContent}',
                style: commentTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}

typedef OnScrollerCallback = Function(double offset);

class GossipNewsPage extends StatefulWidget {
  final OnScrollerCallback callback;

  GossipNewsPage(this.callback);

  @override
  State<StatefulWidget> createState() => GossipNewsPageState();
}

class GossipNewsPageState extends State<GossipNewsPage> {
  ScrollOutScreenViewModel _inScreenViewModel;

  bool _currentIsOutScreen = false;
  final _model = DoctorsViewMode(type: 'GOSSIP');
  final NormalTableViewController _controller = NormalTableViewController();

  @override
  void initState() {
    super.initState();
    eventBus.on().listen((event) {
      if (event != null &&
          event is OutScreenEvent &&
          event.page == PAGE_GOSSIP &&
          _currentIsOutScreen) {
        _controller.refresh();
      }
    }, cancelOnError: true);
    _inScreenViewModel =
        Provider.of<ScrollOutScreenViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return NormalTableView(
      controller: _controller,
      pageSize: (page) => 20,
      itemBuilder: (context, data) {
        var content = Column(
          children: [
            GossipNewsItemWidget(data, () async{
               await _model.like(data.postId);
               setState(() {

               });
            }),
            Container(
              color: ThemeColor.colorFFF8F8F8,
              height: 6,
            ),
          ],
        );
        return GestureDetector(
          onTap: (){
            onItemClicked(_model,data);
          },
          child: content,
        );
      },
      header: (context) {
        return bodyHeader();
      },
      getData: (page) async {
        if (page == 1) {
          return await _model.refresh();
        }
        return await _model.loadData(pageNum: page);
      },
      onScroll: (context, offset) {
        var outScreen = MediaQuery.of(context).size.height < offset;
        _currentIsOutScreen = outScreen;
        _inScreenViewModel.updateState(PAGE_GOSSIP, _currentIsOutScreen);
        if (widget.callback != null) {
          widget.callback(offset);
        }
      },
    );
  }

  bodyHeader() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: DoctorsBanner(
        (context, data, index) {
          return DoctorBannerItemGrass(
            data,
            onClick: (data) {
              openBannerDetail(context, data);
            },
          );
        },
        dataStream: _model.gossipTopBannerStream,
        height: 207 + MediaQuery.of(context).padding.top,
        holder: (context) {
          return SafeArea(
            child: Container(
              height: 40,
            ),
          );
        },
      ),
    );
  }

  void onItemClicked(DoctorsViewMode model, itemData) {
    model.markToNative(itemData);
    RouteManagerOld.openDoctorsDetail(itemData?.postId);
  }

}
