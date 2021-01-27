import 'package:doctor/pages/doctors/viewmodel/doctors_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OpenClassEntity {
  final int id;
  final String coverImgUrl;
  final String videoUrl;
  final String title;
  final int viewNum;
  final String author;

  OpenClassEntity(
    this.id,
    this.coverImgUrl,
    this.videoUrl,
    this.title,
    this.viewNum,
    this.author,
  );
}

class EnterpriseOpenClassWidget extends StatefulWidget {
  final List<OpenClassEntity> entities;

  EnterpriseOpenClassWidget(this.entities);

  @override
  State<StatefulWidget> createState() => EnterpriseOpenClassWidgetState();
}

class EnterpriseOpenClassWidgetState extends State<EnterpriseOpenClassWidget> {
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;

  header(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Image(
                image: AssetImage("assets/images/doctor_circle_head_icon.png"),
                width: 12,
                height: 12,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "企业公开课",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColor.colorFF222222,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            child: Text(
              "查看全部",
              style: TextStyle(
                fontSize: 12,
                color: ThemeColor.colorFF489DFE,
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, RouteManager.DOCTOR_LIST2,
                arguments: 'OPEN_CLASS');
          },
        )
      ],
    );
  }

  Widget buildItem(BuildContext context, OpenClassEntity entity) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: ThemeColor.colorFFBCBCBC),
            height: 102,
            width: double.infinity,
            child: entity.coverImgUrl == null
                ? Container()
                : Image.network(
                    entity.coverImgUrl,
                    width: double.infinity,
                    height: 102,
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "${entity.title}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: ThemeColor.colorFF222222,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              "${formatViewCount(entity.viewNum)}次学习",
              style: TextStyle(
                fontSize: 12,
                color: ThemeColor.colorFF999999,
              ),
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
            arguments: {
              'postId': entity?.id,
              'from': 'list',
              'type': 'OPEN_CLASS'
            });
      },
    );
  }

  Widget buildVideoPreviewItem(BuildContext context, OpenClassEntity entity) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: ThemeColor.colorFFBCBCBC),
            height: 210,
            width: double.infinity,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    // aspectRatio: 16 / 9,
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              entity.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  color: ThemeColor.colorFF222222,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  "${entity.author ?? ''}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColor.colorFF999999,
                  ),
                )),
                Text(
                  "${formatViewCount(entity.viewNum)}次学习",
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColor.colorFF999999,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
            arguments: {
              'postId': entity?.id,
              'from': 'list',
              'type': 'OPEN_CLASS'
            });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network("https://oss-dev.e-medclouds.com/Business-attachment/2021-01/100000/22160003-rc-upload-1611301838305-18.mp4");
    _controller = VideoPlayerController.network(widget.entities[0].videoUrl);
    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 12),
      child: Column(
        children: [
          header(context),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                    child: buildVideoPreviewItem(context, widget.entities[0])),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(child: buildItem(context, widget.entities[1])),
                Container(
                  width: 20,
                  color: Colors.white,
                ),
                Expanded(child: buildItem(context, widget.entities[2])),
              ],
            ),
          )
        ],
      ),
    );
  }
}
