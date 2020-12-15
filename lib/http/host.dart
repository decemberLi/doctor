import 'package:http_manager/api.dart';

extension hostAPI on API {
  String get defaultHost => "https://gateway-dev.e-medclouds.com";
  String get defaultSystem => "doctor";
  String get defaultClient => "mobile";
}
