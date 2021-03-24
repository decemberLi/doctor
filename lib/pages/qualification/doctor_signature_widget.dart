import 'dart:ui';

import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/signer_board_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

class DoctorSignatureWidget extends StatefulWidget {

  DoctorSignatureWidget();

  @override
  State<StatefulWidget> createState() => _DoctorSignatureWidgetState();
}

class _DoctorSignatureWidgetState extends State<DoctorSignatureWidget> {
  @override
  Widget build(BuildContext context) {
    var signerBoard = SignerBoardWidget();
    return WillPopScope(
        child: Scaffold(
          backgroundColor: ThemeColor.colorFFF3F5F8,
          body: Container(
            padding: EdgeInsets.only(left: 33, top: 33, right: 33),
            child: Column(
              children: [
                Expanded(
                  child: signerBoard,
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 36, right: 36, top: 16, bottom: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ThemeColor.primaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                color: Colors.white),
                            child: Text(
                              '返回',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ThemeColor.primaryGeryColor,
                                  fontSize: 16),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(width: 24),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            height: 44,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ThemeColor.primaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                color: Colors.white),
                            child: Text(
                              '清空',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ThemeColor.primaryGeryColor,
                                  fontSize: 16),
                            ),
                          ),
                          onTap: () {
                            signerBoard.reset();
                          },
                        ),
                      ),
                      Container(width: 24),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            height: 44,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                color: ThemeColor.primaryColor),
                            child: Text(
                              '确认',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          onTap: () async {
                            if (signerBoard.isPaintted()) {
                              EasyLoading.showToast('请输入电子签名');
                              return;
                            }
                            var image = await signerBoard.capture();
                            var pngBytes = await image.toByteData(
                                format: ImageByteFormat.png);
                            var dir;
                            if (Platform.isIOS) {
                              dir = await getApplicationDocumentsDirectory();
                            } else {
                              dir = await getExternalStorageDirectory();
                            }
                            var path = '${dir.path}/doctor_signature.png';
                            var file = File(path);
                            file.writeAsBytesSync(
                                pngBytes.buffer.asUint8List());
                            Navigator.pop(context, file.path);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
