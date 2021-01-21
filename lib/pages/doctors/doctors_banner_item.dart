import 'dart:ui';

import 'package:flutter/material.dart';

class DoctorBannerItemGrass extends StatelessWidget {
  final dynamic data;

  DoctorBannerItemGrass(this.data);

  Widget bg() {
    return Stack(
      children: [
        Container(
          color: Colors.blue,
          child: Center(
            child: Text("this is bg"),
          ),
        ),
      ],
    );
  }

  Widget forground() {
    return Container(
      height: 140,
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          bg(),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              color: Colors.white10,
              padding: EdgeInsets.only(bottom: 22,left: 20,right: 20),
              alignment: Alignment.bottomCenter,
              child: forground(),
            ),
          )
          ,
        ],
      ),
    );
  }
}

class DoctorBannerItemNormal extends StatelessWidget {
  final dynamic data;

  DoctorBannerItemNormal(this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }

}
