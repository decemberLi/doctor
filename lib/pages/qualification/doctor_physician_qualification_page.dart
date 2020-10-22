import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhysicianQualificationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhysicianQualificationWidgetState();
  }
}

class _PhysicianQualificationWidgetState
    extends State<PhysicianQualificationWidget> {
  TextStyle _titleStyle = TextStyle(
      color: ThemeColor.colorFF222222,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  TextStyle _imgHintText =
      TextStyle(color: ThemeColor.primaryColor, fontSize: 12);

  EdgeInsetsGeometry _containerPadding =
      const EdgeInsets.only(right: 18, top: 14, bottom: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('基本信息确认'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              _buildAvatarWidget(),
              _buildIdCardWidget(),
              _buildPracticeWidget(),
              _buildPhysicianWidget(),
              _buildProfessionWidget(),
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 20),
                child: AceButton(text: '提交', onPressed: () {}),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildAvatarWidget() {
    return Container(
      color: Colors.white,
      padding: _containerPadding,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget('头像'),
          Wrap(
            direction: Axis.horizontal,
            children: [
              Row(
                children: [
                  _uploadPicWidget(),
                  Container(
                    margin: EdgeInsets.only(top: 12, left: 24),
                    width: 85,
                    height: 85,
                    decoration: DashedDecoration(
                      dashedColor: ThemeColor.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/avatar_sample.png',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _hintTextUI('个人正面免冠头像'),
                        _hintTextUI('背景尽量使用白色'),
                        _hintTextUI('着装需穿着工作服'),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildIdCardWidget() {
    return _container(
      title: '身份证（需拍摄原件）',
      children: [
        Wrap(
          direction: Axis.horizontal,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10, left: 18),
                      width: 144,
                      height: 85,
                      decoration: DashedDecoration(
                        dashedColor: ThemeColor.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/camera.png'),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            child: Text('人像照片面', style: _imgHintText),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12, left: 19, bottom: 10),
                      width: 144,
                      height: 85,
                      decoration: DashedDecoration(
                        dashedColor: ThemeColor.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/camera.png'),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            child: Text('国会面照片', style: _imgHintText),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 18),
          child: _hintTextUI('医师执业证、资格证、专业技术资格证（支持原件或彩色扫描件）'),
        ),
      ],
    );
  }

  _buildPracticeWidget() {
    return _container(
      title: '医师执业证（至少需上传编码页和执业地点页）',
      children: [
        _uploadPicWidget(),
        _sampleWidget('assets/images/practice.png')
      ],
    );
  }

  _buildPhysicianWidget() {
    return _container(
      title: '医师资格证（至少需上传头像页和毕业院校页）',
      children: [
        _uploadPicWidget(),
        _sampleWidget('assets/images/physician.png'),
      ],
    );
  }

  _buildProfessionWidget() {
    return _container(
      title: '专业技术资格证',
      children: [
        _uploadPicWidget(),
        _sampleWidget('assets/images/profession.png'),
      ],
    );
  }

  _hintTextUI(String text) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ThemeColor.primaryColor),
          ),
          Text(
            text,
            style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 10),
          )
        ],
      ),
    );
  }

  _uploadPicWidget() {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 18),
      width: 85,
      height: 85,
      decoration: DashedDecoration(
        dashedColor: ThemeColor.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/camera.png'),
          Container(
            margin: EdgeInsets.only(top: 6),
            child: Text('上传照片', style: _imgHintText),
          )
        ],
      ),
    );
  }

  _sampleWidget(String pic) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 24),
      width: 85,
      height: 85,
      decoration: DashedDecoration(
        dashedColor: ThemeColor.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        pic,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  _container({String title, List<Widget> children}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: _containerPadding,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(title),
          Wrap(
            direction: Axis.horizontal,
            children: children,
          )
        ],
      ),
    );
  }

  _titleWidget(String text) {
    return Container(
      margin: EdgeInsets.only(left: 18),
      child: Text(text, style: _titleStyle),
    );
  }
}
