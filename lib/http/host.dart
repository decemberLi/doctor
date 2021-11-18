import 'package:dio/dio.dart';
import 'package:doctor/http/host_provider.dart';
import 'package:http_manager/manager.dart';

extension hostAPI on API {
  String get defaultHost => ApiHost.instance.apiHost;

  String get defaultSystem => "doctor";

  String get defaultClient => "mobile";
}

abstract class SubAPI {
  String get host => API.shared.defaultHost;

  String get middle;

  String _fullURL(String path) => host + middle + path;

  Future<dynamic> normalPost(String path, {Map<String, dynamic> params}) async {
    if (ApiHost.instance.enableCNHost) {
      return await doNormalPost(path, params);
    }
    try {
      Response ret = await HttpManager.shared.post(
        host + '/medclouds-foundation/developer/mobile/dict/list-data-dict',
        params: {
          'pn': 1,
          'ps': 10,
          'code': 'service_enable',
          'type': 'doctor',
        },
      );
      if (ret.statusCode == 200 && ret.data != null) {
        var records = ret.data["records"] as List;
        if (records != null && records.isNotEmpty) {
          var item = records[0];
          var enable = item["value"];
          ApiHost.instance.enableCNHost = 'true' == enable;
        }
      }
    } catch (err) {
      print(err);
      ApiHost.instance.enableCNHost = false;
    }
    return await doNormalPost(path, params);
  }

  Future doNormalPost(String path, Map<String, dynamic> params) async {
    var url = _fullURL(path);
    return (await HttpManager.shared.post(url, params: params)).data;
  }
}
