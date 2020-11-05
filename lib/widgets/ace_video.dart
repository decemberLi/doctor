import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:connectivity/connectivity.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
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
    if (_controller == null && widget.controller != null) {
      _controller = widget.controller;
      _controller.addListener(() async {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying && _isfirstPlay) {
          _isfirstPlay = false;
          var preference = await SharedPreferences.getInstance();
          var onlyWifi = preference.getBool(ONLY_WIFI) ?? true;
          if (onlyWifi) {
            _controller.pause();
            ConnectivityResult connectivityResult =
                await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.mobile) {
              bool confirm = await confirmDialog();
              if (confirm) {
                _controller.play();
              }
            }
          }
        }
      });
    }
    connectivityInitState();
  }

  Future<bool> confirmDialog() {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text("当前使用非WIFI网络，播放将消耗流量，确认要播放该视频吗?"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            FlatButton(
              child: Text(
                "确定",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

//网络初始状态
  connectivityInitState() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
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
    return Chewie(
      controller: ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 3 / 2,
        autoPlay: false,
        autoInitialize: true,
      ),
    );
  }
}
