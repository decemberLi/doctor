import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_create_btn.dart';
import 'package:doctor/pages/prescription/widgets/prescription_detail.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 处方预览页面
class PrescriptionPreviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonStack(
      appBar: AppBar(
        title: Text(
          "处方预览",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Consumer<PrescriptionViewModel>(
        builder: (_, model, child) {
          return PerscriptionDetail(
            model.data,
            bottom: child,
          );
        },
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AceButton(
                width: 138,
                type: AceButtonType.grey,
                textColor: Colors.white,
                text: '去修改',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              PrescriptionCreateBtn(),
            ],
          ),
        ),
      ),
      // positionedChild: Positioned(
      //   bottom: 100,
      //   width: MediaQuery.of(context).size.width,
      //   child: ,
      // ),
    );
  }
}
