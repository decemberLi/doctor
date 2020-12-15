import 'package:http_manager/manager.dart';
import 'host.dart';

extension serverAPI on API {
  Server get server => Server();
}

class Server {
  String get _host => API.shared.defaultHost;

  String get _middle =>
      "/medclouds-server/${API.shared.defaultSystem}/${API.shared.defaultClient}";

  favoriteList(int page,{int ps = 10}) async {
    var url = _host + _middle + "/favorite/list";
    var result = await HttpManager.shared.post(url,params: {'pn':page,'ps':ps});
    return result;
  }
}
