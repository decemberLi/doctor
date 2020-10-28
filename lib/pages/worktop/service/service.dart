import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('server');

/// 提交学习计划
Future learnSubmit(params) async {
  return await http.post('/learn-plan/submit', params: params);
}
