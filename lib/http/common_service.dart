import 'package:doctor/http/http_manager.dart';

HttpManager foundation = HttpManager('foundation');

/// 通用service
class CommonService {
  static Future getFile(params) async {
    var data = foundation.post('/ali-oss/tmp-url-batch',
        params: params, showLoading: false);
    return data;
  }
}
