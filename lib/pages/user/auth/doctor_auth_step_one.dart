import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:doctor/pages/qualification/image_choose_widget.dart';
import 'package:doctor/pages/user/auth/viewmodel/auth_step1_view_model.dart';
import 'package:doctor/route/fade_route.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_dialog.dart';
import 'package:doctor/widgets/photo_view_gallery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'crude_progress_widget.dart';

class DoctorAuthenticationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoctorAuthenticationPageState();
}

class _DoctorAuthenticationPageState extends State<DoctorAuthenticationPage> {
  var _model = AuthenticationViewModel();

  var _bankCardController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _bankCardFocusNode = FocusNode();
  String _idNotMatchErrorMsg;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        child: Scaffold(
          backgroundColor: ThemeColor.colorFFF3F5F8,
          appBar: AppBar(
            title: Text('医师身份认证'),
            elevation: 0,
          ),
          body: ChangeNotifierProvider<AuthenticationViewModel>.value(
            value: _model,
            child: Consumer<AuthenticationViewModel>(
              builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Container(
                    color: const Color(0xFFF3F5F8),
                    height: MediaQuery.of(context).size.height - 100,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              commonTips(),
                              CrudeProgressWidget(1),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 18),
                                    child: Column(
                                      children: [
                                        _buildIdCardWidget(model),
                                        if (model.needShowIdCardInfo)
                                          _buildItemWidget("姓名：",
                                              model.data.identityName ?? ''),
                                        if (model.needShowIdCardInfo)
                                          _buildItemWidget("身份证号：",
                                              model.data.identityNo ?? ''),
                                        _underLineContainer(
                                            _phoneNumberWidget(model)),
                                        _underLineContainer(
                                            _bankCardWidget(model))
                                      ],
                                    ),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 76, right: 76, top: 12),
                                child: agreement(),
                              ),
                              Container(height: 105, width: double.infinity)
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 30, right: 30, bottom: 30, top: 105),
                            child: AceButton(
                              width: double.infinity,
                              type: model.canNext
                                  ? AceButtonType.primary
                                  : AceButtonType.grey,
                              text: "下一步",
                              onPressed: () async {
                                _unFocus();
                                if (model.isCommitting) {
                                  return;
                                }
                                if (model.canNext) {
                                  model
                                      .commitAuthenticationData()
                                      .then((data) async {
                                    debugPrint("success -> $data");
                                    _resetFocus();
                                    if (data != null &&
                                        data is String &&
                                        !TextUtil.isEmpty(data)) {
                                      await showNoticeDialog(data);
                                    }
                                    _goNextStep();
                                  }).catchError((error) {
                                    debugPrint("error -> $error");
                                    if (error is DioError &&
                                        error.error is Map) {
                                      var errorCode =
                                          (error.error as Map)['errorCode'];
                                      var errorMsg =
                                          (error.error as Map)['errorMsg'];
                                      if ('00010010' == errorCode) {
                                        setState(() {
                                          _idNotMatchErrorMsg = errorMsg;
                                        });
                                      } else if ('00010009' == errorCode) {
                                        showNoticeDialog(errorMsg,
                                            number: model.customServicePhone);
                                      }
                                    } else if (error?.error != null &&
                                        error.error is String) {
                                      EasyLoading.showToast(error?.error);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        onTap: () {
          _unFocus();
        },
      ),
      onWillPop: () async {
        return showNoTitleConfirmDialog(
            context: context, content: '您还未完成医师身份认证，确定退出吗');
      },
    );
  }

  void _unFocus() {
    _bankCardFocusNode.unfocus();
    _mobileFocusNode.unfocus();
  }

  void _resetFocus() {
    if (_mobileFocusNode != null) {
      _mobileFocusNode.unfocus();
    }
    if (_bankCardFocusNode != null) {
      _bankCardFocusNode.unfocus();
    }
  }

  _goNextStep() async {
    var result = await Navigator.pushNamed(
        context, RouteManager.DOCTOR_AUTHENTICATION_PAGE);
    debugPrint("page poped , & value is $result");
  }

  showNoticeDialog(String content, {String number = null}) async {
    _contentTextStyle(color) {
      return TextStyle(fontSize: 14, color: color, height: 1.6);
    }

    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Column(
              children: [
                if (!TextUtil.isEmpty(number))
                  Text("温馨提示：", style: _contentTextStyle(Color(0xFF444444)))
              ],
            ),
            content: Container(
              padding:
                  EdgeInsets.only(top: 18, bottom: 18, right: 14, left: 14),
              child: Column(
                children: [
                  Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: content,
                              style: _contentTextStyle(Color(0xFF444444)),
                              recognizer: TapGestureRecognizer()),
                          if (!TextUtil.isEmpty(number))
                            TextSpan(
                              text: number,
                              style: _contentTextStyle(ThemeColor.primaryColor),
                              recognizer: _agreementTap
                                ..onTap = () async {
                                  await launch(number);
                                },
                            ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      textWidthBasis: TextWidthBasis.parent)
                ],
              ),
            ),
            actions: [
              FlatButton(
                height: 44,
                child: Text(
                  TextUtil.isEmpty(number) ? "继续" : "确定",
                  style: _contentTextStyle(ThemeColor.primaryColor),
                ),
                onPressed: () {
                  if (!TextUtil.isEmpty(number)) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  final _noneBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),
  );

  _phoneNumberWidget(AuthenticationViewModel model) {
    var mobileWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("手机号：", style: _style, textAlign: TextAlign.center),
        Expanded(
            child: TextField(
          controller: _phoneNumberController,
          maxLength: 11,
          decoration: InputDecoration(
            hintText: '请输入',
            hintStyle: TextStyle(fontSize: 14, color: ThemeColor.colorFF999999),
            counterText: '',
            focusedBorder: _noneBorder,
            enabledBorder: _noneBorder,
            border: _noneBorder,
          ),
          focusNode: _mobileFocusNode,
          obscureText: false,
          keyboardType: TextInputType.number,
          style: _style,
          onChanged: (value) {
            model.setSignaturePhoneNumber(_phoneNumberController.text);
          },
        )),
      ],
    );
    return mobileWidget;
  }

  Widget _bankCardWidget(AuthenticationViewModel model) {
    var bankWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("银行卡号：", style: _style, textAlign: TextAlign.center),
        Expanded(
            child: TextField(
          controller: _bankCardController,
          maxLength: 20,
          decoration: InputDecoration(
            hintText: '请输入',
            hintStyle: TextStyle(fontSize: 14, color: ThemeColor.colorFF999999),
            counterText: '',
            focusedBorder: _noneBorder,
            enabledBorder: _noneBorder,
            border: _noneBorder,
          ),
          focusNode: _bankCardFocusNode,
          obscureText: false,
          keyboardType: TextInputType.number,
          style: _style,
          onChanged: (value) {
            model.setBankCard(_bankCardController.text);
          },
        )),
        GestureDetector(
          child: Image.asset(
            "assets/images/img_scanner.png",
            width: 18,
            height: 17,
          ),
          onTap: bankOrc,
        ),
      ],
    );
    if (model.isScanBankCard) {
      _bankCardController.text = model.data.bankCard;
      _bankCardController.selection = TextSelection.fromPosition(
          TextPosition(offset: (_bankCardController.text ?? '').length));
      model.setIsScanBankCard(false);
    }
    return bankWidget;
  }

  commonTips() {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xFF88BEFF),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: Text(
        "注：以下信息仅供认证使用，请您放心填写，我们将严格保密",
        style: const TextStyle(fontSize: 12, color: Color(0xFF222222)),
      ),
    );
  }

  _buildIdCardWidget(AuthenticationViewModel model) {
    List<String> data = [];
    if (!TextUtil.isEmpty(model.data.idCardLicenseFront?.url)) {
      data.add(model.data.idCardLicenseFront?.url);
    }
    if (!TextUtil.isEmpty(model.data.idCardLicenseBehind?.url)) {
      data.add(model.data.idCardLicenseBehind?.url);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text('身份证（需拍摄原件）',
              style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF222222),
                  fontWeight: FontWeight.bold)),
        ),
        Row(
          children: [
            Expanded(
                child: ImageChooseWidget(
              hintText: '人像面照片',
              url: model.data.idCardLicenseFront?.url,
              addImgCallback: () => idCardFaceSideOcr(),
              removeImgCallback: () {
                _idNotMatchErrorMsg = null;
                _model.setIdCardFaceSide(null);
              },
              showOriginImgCallback: () {
                _showOriginImage(data, 0);
              },
            )),
            Container(
              width: 10,
            ),
            Expanded(
                child: ImageChooseWidget(
              hintText: '国徽面照片',
              url: model.data.idCardLicenseBehind?.url,
              addImgCallback: () => idCardBackSideOcr(),
              removeImgCallback: () {
                _idNotMatchErrorMsg = null;
                _model.setIdCardBackgroundSide(null);
              },
              showOriginImgCallback: () {
                _showOriginImage(data, 1);
              },
            )),
          ],
        ),
        if (!TextUtil.isEmpty(_idNotMatchErrorMsg))
          Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              _idNotMatchErrorMsg,
              style: TextStyle(fontSize: 10, color: const Color(0xFFF57575)),
            ),
          )
      ],
    );
  }

  final _style = const TextStyle(
      fontSize: 14,
      color: const Color(0xFF222222),
      fontWeight: FontWeight.bold);

  _buildItemWidget(title, value) {
    return _underLineContainer(Row(
      children: [
        Text(title, style: _style, textAlign: TextAlign.center),
        Text(
          value,
          style: _style,
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }

  Widget _underLineContainer(child) {
    return Container(
      height: 54,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: const Color(0x1A000000)))),
      child: child,
    );
  }

  _showOriginImage(List data, int idx) {
    Navigator.of(context).push(
      FadeRoute(
        page: PhotoViewGalleryScreen(
          images: data,
          index: idx,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _agreementTap.dispose();
    _resetFocus();
    super.dispose();
  }

  TapGestureRecognizer _agreementTap = TapGestureRecognizer();

  onAgreementTaped() {
    setState(() {
      _model.changeAgreeState(!_model.agree);
    });
  }

  agreement() {
    _testStyle(Color color) {
      return TextStyle(
          color: color, fontSize: 11, textBaseline: TextBaseline.ideographic);
    }

    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 1, right: 3),
              child: Icon(
                Icons.check_circle,
                color: _model.agree
                    ? ThemeColor.primaryColor
                    : ThemeColor.secondaryGeryColor,
                size: 16,
                textDirection: TextDirection.ltr,
              ),
            ),
            onTap: onAgreementTaped,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: "本人已阅读并同意与四川高灯企服科技有限公司签署",
                          style: _testStyle(ThemeColor.secondaryGeryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              onAgreementTaped();
                            }),
                      TextSpan(
                        text: "《共享经济合作伙伴协议》",
                        style: _testStyle(ThemeColor.primaryColor),
                        recognizer: _agreementTap
                          ..onTap = () {
                            MedcloudsNativeApi.instance().openWebPage(
                                'https://static.e-medclouds.com/web/other/protocols/license_partner.html');
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.parent),
            ),
          )
        ],
      ),
    );
  }

  bankOrc() async {
    MedcloudsNativeApi.instance().addProcessor("ocrBankCard", (args) {
      _model.processBankCardResult(args);
      return Future.value("OK");
    });
    MedcloudsNativeApi.instance().ocrBankCard();
  }

  idCardFaceSideOcr() async {
    MedcloudsNativeApi.instance().addProcessor("ocrIdCardFaceSide", (args) {
      _model.processIdCardFaceSideResult(args);
      return Future.value("OK");
    });
    MedcloudsNativeApi.instance().ocrIdCardFaceSide();
  }

  idCardBackSideOcr() async {
    print("idCardBackSideOcr ----------------------");
    MedcloudsNativeApi.instance().addProcessor("ocrIdCardBackSide", (args) {
      _model.processIdCardBackSideResult(args);
      return Future.value("OK");
    });
    MedcloudsNativeApi.instance().ocrIdCardBackSide();
  }
}
