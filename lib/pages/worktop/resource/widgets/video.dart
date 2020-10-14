import 'package:doctor/http/common_service.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetail extends StatefulWidget {
  final ResourceModel data;
  VideoDetail(this.data);
  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  initData() async {
    var files = await CommonService.getFile({
      'ossIds': [widget.data.attachmentOssId]
    });
    print(files[0]['tmpUrl']);
    // _controller = VideoPlayerController.network(
    //   files[0]['tmpUrl'],
    // );
    // _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void initState() {
    this.initData();
    _controller = VideoPlayerController.network(
      'https://oss-dev.e-medclouds.com/Business-attachment/2020-07/100027/21210849-1595337473013.mp4?Expires=1602669459&OSSAccessKeyId=LTAI4G4YMh1PB4BdD6BpC4qU&Signature=cIBMCgX8DPA1FkDLc%2BVtpT8vDxY%3D',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the VideoPlayer.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              height: 240,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
    // return Container(
    //   alignment: Alignment.topCenter,
    //   child: Column(
    //     children: [
    //       FutureBuilder(
    //         future: _initializeVideoPlayerFuture,
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.done) {
    //             // If the VideoPlayerController has finished initialization, use
    //             // the data it provides to limit the aspect ratio of the VideoPlayer.
    //             return AspectRatio(
    //               aspectRatio: _controller.value.aspectRatio,
    //               // Use the VideoPlayer widget to display the video.
    //               child: VideoPlayer(_controller),
    //             );
    //           } else {
    //             return Container(
    //               alignment: Alignment.center,
    //               height: 240,
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //         },
    //       ),
    //       Expanded(
    //         child: Container(
    //           color: Colors.white,
    //           alignment: Alignment.topCenter,
    //           child: Column(
    //             children: [
    //               Container(
    //                 height: 44.0,
    //                 alignment: Alignment.center,
    //                 decoration: BoxDecoration(
    //                   border: Border(
    //                     bottom: BorderSide(color: ThemeColor.colorFFF0EDF1),
    //                   ),
    //                 ),
    //                 child: Text(
    //                   '资料介绍',
    //                   style: TextStyle(
    //                     color: ThemeColor.primaryColor,
    //                     fontSize: 16.0,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //               SingleChildScrollView(),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
