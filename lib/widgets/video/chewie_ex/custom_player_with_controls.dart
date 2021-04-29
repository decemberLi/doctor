import 'package:doctor/widgets/video/chewie/src/chewie_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomPlayerWithControls extends StatelessWidget {
  final double width;
  final double height;

  ///入参增加容器宽和高
  CustomPlayerWithControls({
    Key key,
    this.width = 375,
    this.height = 210,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    return _buildPlayerWithControls(chewieController, context);
  }

  // 视频play部分
  Container _buildPlayerWithControls(
      ChewieController chewieController, BuildContext context) {
    double _width = width;
    double _height = height;
    VideoPlayerValue value = chewieController?.videoPlayerController?.value;
    // 监听全面屏
    if (chewieController.isFullScreen) {
      if (value.size.width > value.size.height) {
        // 横屏视频
        _width = MediaQuery.of(context).size.width - 40;
        _height = MediaQuery.of(context).size.height;
      } else {
        _width = MediaQuery.of(context).size.width;
        _height = MediaQuery.of(context).size.height - 60;
      }
    }
    return Container(
      width: _width,
      height: _height,
      child: Stack(
        children: <Widget>[
          chewieController.placeholder ?? Container(),
          VideoPlayerContainer(_width, _height),
          chewieController.overlay ?? Container(),
          _buildControls(context, chewieController),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ChewieController chewieController,
  ) {
    return chewieController.showControls &&
            chewieController.customControls != null
        ? chewieController.customControls
        : Container();
  }
}

///与源码中的PlayerWithControls相比，VideoPlayerContainer继承了StatefulWidget.
///监听videoPlayerController的变化，拿到视频宽高比。
class VideoPlayerContainer extends StatefulWidget {
  final double maxWidth;
  final double maxHeight;

  ///根据入参的宽高，计算得到容器宽高比
  final double _viewRatio;

  VideoPlayerContainer(
    this.maxWidth,
    this.maxHeight, {
    Key key,
  })  : _viewRatio = maxWidth / maxHeight,
        super(key: key);

  @override
  _VideoPlayerContainerState createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  double _aspectRatio;
  ChewieController chewieController;

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    chewieController.videoPlayerController.removeListener(_updateState);
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    if (_oldController != chewieController) {
      _dispose();
      chewieController.videoPlayerController.addListener(_updateState);
      _updateState();
    }
    super.didChangeDependencies();
  }

  void _updateState() {
    VideoPlayerValue value = chewieController?.videoPlayerController?.value;
    if (value != null) {
      double newAspectRatio = value.size != null ? value.aspectRatio : null;
      if (newAspectRatio != null && newAspectRatio != _aspectRatio) {
        setState(() {
          _aspectRatio = newAspectRatio;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    var _viewRatio = widget._viewRatio;
    ChewieController _chewieController = chewieController;
    VideoPlayerValue value = chewieController?.videoPlayerController?.value;
    if (_aspectRatio == null || value == null) {
      return Container();
    }

    ///两个宽高比进行比较，保证VideoPlayer不超出容器，且不会产生变形
    double _maxWidth = widget.maxWidth;
    double _maxHeight = widget.maxHeight;

    if (_chewieController.isFullScreen) {
      _maxWidth = MediaQuery.of(context).size.width;
      _maxHeight = MediaQuery.of(context).size.height;
    }

    // 方案1：-----------------start-------------------
    // if (_aspectRatio > _viewRatio) {
    //   width = _maxWidth;
    //   height = _maxWidth / _aspectRatio;
    // } else {
    //   height = _maxHeight;
    //   width = _maxWidth * _aspectRatio;
    // }
    // 方案1：-----------------end-------------------

    // 方案2：-----------------start-------------------
    // if (_aspectRatio > _viewRatio) {
    //   width = _maxWidth;
    //   height = _maxWidth / _aspectRatio;
    // } else {
    //   height = _maxHeight;
    //   width = (_maxWidth * _aspectRatio) * (_maxHeight / _maxWidth);
    // }
    // 方案2：-----------------end-------------------

    // 方案3：-----------------start-------------------
    // 视频宽高对比
    if (value.size != null) {
      // print(
      //     '${value.size.width}<=>$_maxWidth<=width=${_chewieController.isFullScreen}==value.size==height=>${value.size.height}<=>$_maxHeight');
      if (value.size.width > value.size.height) {
        // 横屏视频
        if (_chewieController.isFullScreen) {
          width = _maxHeight * _aspectRatio;
          height = _maxHeight;
        } else {
          width = _maxWidth;
          height = _maxWidth / _aspectRatio;
        }
      } else {
        // 竖屏视频
        if (_chewieController.isFullScreen) {
          width = _maxHeight * _aspectRatio;
          height = _maxHeight;
        } else {
          width = _maxHeight * _aspectRatio;
          height = _maxWidth / _aspectRatio;
        }
      }
    } else {
      if (_aspectRatio > _viewRatio) {
        width = _maxWidth;
        height = _maxWidth / _aspectRatio;
      } else {
        width = (_maxWidth * _aspectRatio) / _viewRatio;
        height = _maxHeight;
      }
    }

    // 方案3：-----------------end-------------------

    // print(
    //     '_aspectRatio:$_aspectRatio---_viewRatio:$_viewRatio--视频大小数据value====》》》$value');
    return Center(
      child: Container(
        width: width,
        height: height,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Color(0xFFff484c)),
        // ),
        child: VideoPlayer(chewieController.videoPlayerController),
      ),
    );
  }
}
