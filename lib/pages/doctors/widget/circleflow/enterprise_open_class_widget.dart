import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:doctor/common/event/event_tab_index.dart';
import 'package:doctor/pages/doctors/viewmodel/doctors_view_model.dart';
import 'package:doctor/root_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../doctors_circle_widget.dart';

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
  final Widget holder;
  final Stream<List<OpenClassEntity>> stream;

  EnterpriseOpenClassWidget(
    Key key,
    this.stream,
    this.holder,
  ) : super(key: key);

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
                width: 14,
                height: 14,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 2),
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "企业公开课",
                  style: TextStyle(
                    fontSize: 16,
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
                fontSize: 14,
                color: ThemeColor.colorFF489DFE,
              ),
            ),
          ),
          onTap: () {
            eventBus.fire(EventVideoPause());
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
            decoration: BoxDecoration(color: Color(0xffEAF3FF)),
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
                fontSize: 14,
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
        RouteManager.openDoctorsDetail(entity?.id);
      },
    );
  }

  _cover(OpenClassEntity entity) {
    return _isPlaying
        ? Container()
        : Container(
            color: Color(0xffEAF3FF),
            height: 280,
            child: Stack(
              children: [
                Image.network(
                  entity.coverImgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 280,
                ),
                Positioned(
                  child: !_isPlaying
                      ? GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            child: Image(
                              image:
                                  AssetImage("assets/images/video_playing.png"),
                              width: 41,
                              height: 41,
                            ),
                          ),
                          onTap: () {
                            doPlay();
                          },
                        )
                      : Container(),
                )
              ],
            ),
          );
  }

  Widget buildVideoPreviewItem(BuildContext context, OpenClassEntity entity) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Color(0xffEAF3FF)),
            height: 210,
            child: !_isPlaying
                ? _cover(entity)
                : FutureBuilder(
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
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Color(0xBB171717),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: _currentVolume != 0
                                        ? Image.asset(
                                            "assets/images/in_mute.png",
                                            width: 15,
                                            height: 15,
                                          )
                                        : Image.asset(
                                            "assets/images/mute.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                  ),
                                  onTap: () {
                                    if (_currentVolume == 0) {
                                      _controller.setVolume(_volume);
                                      _currentVolume = _volume;
                                    } else {
                                      _controller.setVolume(0);
                                      _currentVolume = 0;
                                    }
                                  },
                                ),
                              ),
                              _cover(entity),
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
                  fontSize: 14,
                  color: ThemeColor.colorFF222222,),
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
        RouteManager.openDoctorsDetail(entity?.id);
      },
    );
  }

  void doPlay() async {
    if (_isPlaying || !_isCurrentPage) {
      return;
    }
    if (!_isPlaying) {
      if (_isReplay) {
        print("------------replay----play");
        _formatTime(
            Duration(milliseconds: _residueTime) - _oneMillSecondsDuration);
        await _controller.seekTo(Duration(milliseconds: 0));
        _isReplay = false;
      }
      await _controller.play();
      _isPlaying = true;
    }
    _countDownTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      var tim = Duration(milliseconds: _residueTime) - _oneMillSecondsDuration;
      _formatTime(tim);
      setState(() {});
    });
    setState(() {});
  }

  bool _isPlaying = false;
  bool initialized = false;
  String _totalTime;
  int _residueTime = 0;
  Timer _countDownTimer;
  final _oneMillSecondsDuration = Duration(milliseconds: 1000);
  double _volume = 0;
  double _currentVolume = 0;
  bool _isScrollPause = false;
  bool _isReplay = false;

  _formatTime(Duration total) {
    if (total.inMilliseconds < 0) {
      _totalTime = _formatTime(_controller.value.duration);
      _residueTime = _controller.value.duration.inMilliseconds;
      _pausePlaying();
      print("------------replay");
      _isReplay = true;
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

  List<OpenClassEntity> snapshot;

  @override
  void initState() {
    super.initState();
    widget.stream.listen((List<OpenClassEntity> event) {
      snapshot = event;
      initVideoPlayerController(event[0].videoUrl);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  bool _isCurrentPage = true;

  Future initVideoPlayerController(String videoUrl) async {
    if (_controller != null) {
      _pausePlaying();
    }
    _controller = VideoPlayerController.network(videoUrl);
    _controller.setLooping(false);
    _initializeVideoPlayerFuture = _controller.initialize()
      ..whenComplete(() async {
        initialized = _controller.value.initialized;
        _volume = _controller.value.volume;
        // 总时长
        _formatTime(_controller.value.duration);
        _controller.setVolume(_currentVolume);
        eventBus.on().listen((event) {
          if (event is EventTabIndex) {
            _isCurrentPage = event.index == 1;
          }
          if (event is EventTabIndex &&
              (event.index != 1 || event.subIndex != 0)) {
            _pausePlaying();
          } else if (event is EventVideoOutOfScreen) {
            if (event.offset < 0) {
              if (!_controller.value.isPlaying) {
                return;
              }
              _pausePlaying(isScrollPause: true);
            } else if (_isScrollPause) {
              doPlay();
            }
          } else if (event is EventVideoPause) {
            _pausePlaying();
          }
        });
        if (AppUtils.sp.getBool(ONLY_WIFI) ?? true) {
          ConnectivityResult connectivityResult =
              await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.wifi) {
            doPlay();
          }
        } else {
          doPlay();
        }
        setState(() {});
      });
    _initializeVideoPlayerFuture.then((value) {});
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
    if (AppLifecycleState.inactive == state) {
      _pausePlaying();
    }
    print(state);
  }

  _pausePlaying({bool isScrollPause = false}) {
    if (_isPlaying) {
      print(
          "isScrollPause && _isPlaying -------------------> ${isScrollPause && _isPlaying}");
      _isScrollPause = isScrollPause && _isPlaying;
      _isPlaying = false;
      _controller.pause();
      if (_countDownTimer != null && _countDownTimer.isActive) {
        _countDownTimer.cancel();
        _countDownTimer = null;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot == null || snapshot.length == 0) {
      return widget.holder;
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 12, right: 20),
            child: Column(
              children: [
                header(context),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(child: buildVideoPreviewItem(context, snapshot[0])),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(child: buildItem(context, snapshot[1])),
                      Container(
                        width: 20,
                        color: Colors.white,
                      ),
                      Expanded(child: buildItem(context, snapshot[2])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 12,
            color: Colors.white,
          ),
          Container(
            color: ThemeColor.colorFFF9F9F9,
            width: double.infinity,
            height: 6,
          )
        ],
      ),
    );
  }
}
