import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('关于我们'),
      ),
      body: Container(
        color: ThemeColor.colorFFF3F5F8,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Image.asset(
                      'assets/images/company.png',
                      width: 130,
                      height: 148,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      '       重庆易药云科技有限公司是一家专注于赋能生命科学领域企业营销数字化转型的高新技术企业。我们运用云平台，借助区块链、大数据、AI人工智能等互联网前沿技术，自主研发了一套帮助医药企业实现“行为标准化、信息数字化、数据结构化”的全域数据智能化SaaS平台。易药云致力于以互联网信息化手段为医药全产业链进行有效赋能，帮助企业真正实现向数字化、精细化、智能化的学术推广转型，并为企业提供标准化、定制化学术推广解决方案。',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
