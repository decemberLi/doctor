import 'dart:async';

// import 'package:chewie/chewie.dart';
import 'package:connectivity/connectivity.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/no_wifi_notice_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

/// 项目通用视频播放
class AceVideo extends StatefulWidget {
  final VideoPlayerController controller;

  AceVideo({
    @required this.controller,
  });
  @override
  _AceVideoState createState() => _AceVideoState();
}

class _AceVideoState extends State<AceVideo> {
  VideoPlayerController _controller;

  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _isfirstPlay = true;

  _initialize() async {
    if (widget.controller != null) {
      _controller = widget.controller;
      _controller.addListener(() async {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying && _isfirstPlay) {
          _isfirstPlay = false;
          var onlyWifi = AppUtils.sp.getBool(ONLY_WIFI) ?? true;
          if (onlyWifi) {
            _controller.pause();
            bool confirm = await NoWifiNoticeHelper.checkConnect(
              context: context,
              message: '当前使用非WIFI网络，播放将消耗流量，确认要播放该视频吗?',
            );
            if (confirm) {
              _controller.play();
            }
          }
        }
      });
    }
    connectivityInitState();
  }

//网络初始状态
  connectivityInitState() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        if (!mounted) {
          return;
        }
        print('====${result.toString()}');
        // final bool isPlaying = _controller.value.isPlaying;
        // if (isPlaying) {
        //   var preference = await SharedPreferences.getInstance();
        //   var onlyWifi = preference.getBool(ONLY_WIFI) ?? true;
        //   if (onlyWifi) {
        //     _controller.pause();
        //     ConnectivityResult connectivityResult =
        //         await (Connectivity().checkConnectivity());
        //     if (connectivityResult == ConnectivityResult.mobile) {
        //       bool confirm = await confirmDialog();
        //       if (confirm) {
        //         _controller.play();
        //       }
        //     }
        //   }
        // }
      }
    });
  }

//网络结束监听
  connectivityDispose() {
    _connectivitySubscription.cancel();
  }

  @override
  initState() {
    this._initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(AceVideo oldWidget) {
    this._initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    connectivityDispose();
    super.dispose();
  }

  Widget _buildIndicator() {
    return Container(
      alignment: Alignment.center,
      height: 240,
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return _buildIndicator();
    }
    return _buildIndicator();
    // return Chewie(
    //   controller: ChewieController(
    //     videoPlayerController: _controller,
    //     aspectRatio: 3 / 2,
    //     // aspectRatio: _controller.value.aspectRatio,
    //     autoPlay: false,
    //     autoInitialize: true,
    //   ),
    // );
  }
}
