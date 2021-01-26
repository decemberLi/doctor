import 'dart:ui';

import 'package:flutter/material.dart';

class DoctorBannerItemGrass extends StatelessWidget {
  final dynamic data;
  final Function(dynamic) onClick;

  DoctorBannerItemGrass(this.data, {this.onClick});

  Widget bg() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(data.bannerUrl),
        ),
      ),
    );
  }

  Widget forground() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(data.bannerUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick(data);
        }
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            bg(),
            Container(
              child:  BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: Container(
                  padding: EdgeInsets.only(bottom: 22, left: 20, right: 20),
                  alignment: Alignment.bottomCenter,
                  child: forground(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorBannerItemNormal extends StatelessWidget {
  final dynamic data;
  final Function(dynamic) onClick;

  DoctorBannerItemNormal(this.data, {this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick(data);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(data.bannerUrl),
          ),
        ),
      ),
    );
  }
}
