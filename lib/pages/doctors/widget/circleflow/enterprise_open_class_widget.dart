import 'dart:async';

import 'package:doctor/pages/doctors/viewmodel/doctors_view_model.dart';
import 'package:doctor/root_widget.dart';
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

class EnterpriseOpenClassWidgetState extends State<EnterpriseOpenClassWidget>
    with WidgetsBindingObserver {
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
                : Image.network(entity.coverImgUrl,
                    width: double.infinity, height: 102, fit: BoxFit.cover),
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
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                        Positioned(
                          child: !_isPlaying
                              ? GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/video_playing.png"),
                                      width: 41,
                                      height: 41,
                                    ),
                                  ),
                                  onTap: () {
                                    doPlay();
                                  },
                                )
                              : Container(),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 12),
                            width: 50,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Color(0xFF171717),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '${_totalTime ?? ''}',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
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
        _pausePlaying();
        Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
            arguments: {
              'postId': entity?.id,
              'from': 'list',
              'type': 'OPEN_CLASS'
            });
      },
    );
  }

  void doPlay() {
    if (!_isPlaying) {
      _controller.play();
      _isPlaying = true;
    }
    if (_countDownTimer == null) {
      _countDownTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        var tim =
            Duration(milliseconds: _residueTime) - _oneMillSecondsDuration;
        _formatTime(tim);
        setState(() {});
      });
    } else {
      _countDownTimer.tick;
    }
    setState(() {});
  }

  bool _isPlaying = false;
  bool initialized = false;
  String _totalTime;
  int _residueTime = 0;
  Timer _countDownTimer;
  final _oneMillSecondsDuration = Duration(milliseconds: 1000);

  _formatTime(Duration total) {
    if (total.inMilliseconds < 0) {
      _totalTime = "00:00";
      _residueTime = _controller.value.duration.inMilliseconds;
      _countDownTimer.cancel();
      return;
    }
    print(total.inMilliseconds);
    var minute = total.inMinutes;
    var second = total.inSeconds - minute * 60;
    var seconds = second < 10 ? "0$second" : "$second";
    var minutes = minute < 10 ? "0$minute" : "$minute";
    _totalTime = "$minutes:$seconds";
    _residueTime = total.inMilliseconds;
  }

  @override
  void initState() {
    super.initState();
    // routeObserver.subscribe(this, ModalRoute.of(context));
    // _controller = VideoPlayerController.network("https://oss-dev.e-medclouds.com/Business-attachment/2021-01/100000/22160003-rc-upload-1611301838305-18.mp4");
    _controller = VideoPlayerController.network(widget.entities[0].videoUrl);
    _controller.setLooping(true);
    _controller.setVolume(0);
    _initializeVideoPlayerFuture = _controller.initialize()
      ..whenComplete(() {
        initialized = _controller.value.initialized;
        // 总时长
        _formatTime(_controller.value.duration);
        setState(() {});
      });
    _initializeVideoPlayerFuture.then((value) {});
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // routeObserver.unsubscribe(this);
    if (_countDownTimer != null && _countDownTimer.isActive) {
      _countDownTimer.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.paused == state) {
      _pausePlaying();
    }
    print(state);
  }

  _pausePlaying() {
    if (_isPlaying) {
      _isPlaying = false;
      _controller.pause();
      setState(() {});
    }
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
