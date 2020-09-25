import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widget/loading.dart';
import 'package:doctor/http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '易药通',
      theme: ThemeData(
        primaryColor: ThemeColor.primaryColor,
        buttonTheme: ButtonThemeData(buttonColor: ThemeColor.primaryColor),
        iconTheme: IconThemeData(color: ThemeColor.primaryColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 为loading组件全局存储context
    // Loading.ctx = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text('请求测试'),
                onPressed: () async {
                  Response response = await HttpManager().request(
                      'post', '/user/login-by-pwd',
                      params: {
                        'mobile': '18866660000',
                        'password': '111111',
                        'system': 'DOCTOR'
                      },
                      options: HttpManagerOptions(showLoading: true));
                  print(response.data.toString());
                }),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
