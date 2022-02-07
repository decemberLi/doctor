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
    return await doNormalPost(path, params);
  }

  Future doNormalPost(String path, Map<String, dynamic> params) async {
    var url = _fullURL(path);
    return (await HttpManager.shared.post(url, params: params)).data;
  }
}
