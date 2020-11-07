import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/widgets/prescription_status.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/route/fade_route.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/one_line_text.dart';
import 'package:doctor/widgets/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class PerscriptionDetail extends StatelessWidget {
  final PrescriptionModel data;
  final Widget bottom;
  PerscriptionDetail(
    this.data, {
    this.bottom,
  });

  List<Widget> renderRp() {
    if (data == null || data.drugRps.isEmpty) {
      return [];
    }
    return data?.drugRps
        ?.map(
          (e) => Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${data.drugRps.indexOf(e) + 1}、${e.drugName}',
                      style: MyStyles.inputTextStyle_12,
                    ),
                    Text(
                      'X${e.quantity.toStringAsFixed(0)}',
                      style: MyStyles.inputTextStyle_12,
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  '规格：${e.drugSize}',
                  style: MyStyles.greyTextStyle_12,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  '用法用量：${e.useInfo}',
                  style: MyStyles.inputTextStyle_12,
                ),
              ],
            ),
          ),
        )
        ?.toList();
  }

  List<Widget> renderImages(BuildContext context) {
    if (data == null || data.attachments == null || data.attachments.isEmpty) {
      return [];
    }
    return data.attachments.map(
      (e) {
        if (e.url == null) {
          return Container();
        }
        return GestureDetector(
          child: Image.network(
            e.url,
            width: 74,
            fit: BoxFit.fitWidth,
          ),
          onTap: () {
            Navigator.of(context).push(
              FadeRoute(
                page: PhotoViewGalleryScreen(
                  images: this.data.attachments.map((e) => e.url).toList(),
                ),
              ),
            );
          },
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    // if (data == null) {
    //   return Container();
    // }
    String defaultDepart =
        Provider.of<UserInfoViewModel>(context, listen: false)
                .data
                ?.departmentsName ??
            '';
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.topCenter,
      child: Card(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 0, child: PrescriptionStatus(data)),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '易学术互联网医院',
                          style: MyStyles.primaryTextStyle,
                        ),
                        Text(
                          '电子处方笺',
                          style: MyStyles.primaryTextStyle_bold,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(color: Color(0xFF3AA7FF)),
                      ),
                      child: Text(
                        '普通',
                        style: MyStyles.primaryTextStyle_12
                            .copyWith(color: Color(0xFF3AA7FF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data?.prescriptionNo ?? '',
                                style: MyStyles.greyTextStyle_12,
                              ),
                              Text(
                                data?.createTimeText ?? '',
                                style: MyStyles.greyTextStyle_12,
                              ),
                            ],
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '姓名：${data?.prescriptionPatientName ?? ''}',
                                style: MyStyles.inputTextStyle,
                              ),
                              Text(
                                '性别：${data?.prescriptionPatientSexLabel ?? ''}',
                                style: MyStyles.inputTextStyle,
                              ),
                              Text(
                                '年龄：${data?.prescriptionPatientAge ?? ''}',
                                style: MyStyles.inputTextStyle,
                              ),
                            ],
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '科室：${data?.depart ?? defaultDepart}',
                            style: MyStyles.inputTextStyle,
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: OneLineText(
                            '临床诊断：${data?.clinicalDiagnosis ?? ''}',
                            style: MyStyles.inputTextStyle,
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rp:',
                                style: MyStyles.inputTextStyle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...renderRp(),
                            ],
                          ),
                        ),
                        FormItem(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '纸质处方图片',
                                style: MyStyles.inputTextStyle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 6,
                                runSpacing: 10,
                                children: renderImages(context),
                              ),
                            ],
                          ),
                        ),
                        if (data?.doctorName != null)
                          FormItem(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: OneLineText(
                              '处方医生：${data?.doctorName ?? ''}',
                              style: MyStyles.inputTextStyle,
                            ),
                          ),
                        if (data?.pharmacist != null || data?.auditor != null)
                          FormItem(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '处方药师：',
                                  style: MyStyles.inputTextStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                data?.pharmacist != null
                                    ? FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: data?.pharmacist,
                                        width: 54,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Text(
                                        data?.auditor ?? '',
                                        style: MyStyles.inputTextStyle,
                                      ),
                              ],
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '特别提醒',
                                style: MyStyles.greyTextStyle_12,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '1、处方有效期为3天，请及时取药。',
                                style: MyStyles.greyTextStyle_12,
                              ),
                              Text(
                                '2、按照卫生部、国家中药管理局卫医发[2002]24号文件规定：为保证患者用药安全，药品一经发出，不得退换。',
                                style: MyStyles.greyTextStyle_12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (bottom != null) bottom,
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
