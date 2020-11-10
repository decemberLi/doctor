import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/no_wifi_notice_helper.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'chewie/src/chewie_player.dart';
import 'chewie_ex/custom_controls.dart';
import 'chewie_ex/custom_player_with_controls.dart';

class ChewieVideo extends StatefulWidget {
  final VideoPlayerController controller;
  ChewieVideo({
    @required this.controller,
  });
  @override
  _ChewieVideoWidgetState createState() => _ChewieVideoWidgetState();
}

class _ChewieVideoWidgetState extends State<ChewieVideo> {
  ChewieController _chewieController;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isfirstPlay = true;
  VideoPlayerController _controller;

  void pauseVideo() {
    _chewieController?.pause();
    _chewieController?.dispose();
    _controller?.dispose();
    _chewieController = null;
    _controller = null;
  }

  _initialize() async {
    if (widget.controller != null) {
      _controller = widget.controller;
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoInitialize: true,
        autoPlay: false,
        showControls: true,
        customControls: CustomControls(),
        placeholder: new Container(
          color: Color.fromRGBO(0, 0, 0, 0.75),
        ),
      );
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
        print('Connectivity====${result.toString()}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._initialize();
  }

  @override
  void didUpdateWidget(ChewieVideo oldWidget) {
    this._initialize();
    super.didUpdateWidget(oldWidget);
  }

  //网络结束监听
  connectivityDispose() {
    _connectivitySubscription.cancel();
  }

  @override
  void dispose() {
    _chewieController?.pause();
    _chewieController?.dispose();
    _controller?.dispose();
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
    if (widget.controller == null) {
      return _buildIndicator();
    }
    return Chewie(
      controller: _chewieController,
      child: CustomPlayerWithControls(),
    );
  }
}
