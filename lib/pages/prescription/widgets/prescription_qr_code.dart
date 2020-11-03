import 'package:doctor/pages/prescription/service/service.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 加载处方二维码
class PrescriptionQRCode extends StatelessWidget {
  final String prescriptionNo;
  PrescriptionQRCode(this.prescriptionNo);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadBindQRCode(prescriptionNo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.network(snapshot.data,
              width: 182,
              height: 182,
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth, loadingBuilder: (BuildContext context,
                  Widget child, ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 182,
              height: 182,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ThemeColor.colorLine,
                ),
              ),
              child: CircularProgressIndicator(),
            );
          });
        }
        return Container(
          width: 182,
          height: 182,
        );
      },
    );
  }
}
