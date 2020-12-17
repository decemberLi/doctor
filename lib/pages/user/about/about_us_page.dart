import 'package:doctor/utils/adapt.dart';
import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '关于我们',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Adapt.screenH() * 0.83,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          margin: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 53),
                  child: Image.asset(
                    'assets/images/company.png',
                    width: 75,
                    height: 84,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 36, top: 36, right: 30),
                  child: Text(
                    '重庆易药云科技有限公司是一家专注于赋能生命科学领域企业营销数字化转型的高新技术企业。我们运用云平台，借助区块链、大数据、AI人工智能等互联网前沿技术，自主研发了一套帮助医药企业实现“行为标准化、信息数字化、数据结构化”的全域数据智能化SaaS平台。易药云致力于以互联网信息化手段为医药全产业链进行有效赋能，帮助企业真正实现向数字化、精细化、智能化的学术推广转型，并为企业提供标准化、定制化学术推广解决方案。',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 36, top: 20, right: 36),
                  width: double.infinity,
                  child: Text(
                    '客服邮箱：sales@e-medclouds.com',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 36, right: 36,top: 5),
                  width: double.infinity,
                  child: Text(
                    '客服电话：17345044368',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
