import 'package:http_manager/manager.dart';
import 'host.dart';

extension devAPI on API {
  Developer get developer => Developer();
}

class Developer extends SubAPI {
  String get middle =>
      "/medclouds-foundation/developer/${API.shared.defaultClient}";

  dictList() async => await normalPost(
        "/dict/list-data-dict",
        params: {
          'pn': 1,
          'ps': 10,
          'code': 'ios_app_store',
          'type': 'doctor',
        },
      );
  dictCategoryList() async => await normalPost(
        "/dict/list-data-dict",
        params: {
          'pn': 1,
          'ps': 10,
          'code': 'doctor_category_config',
          'type': 'doctor',
        },
      );
  customServicePhone() async => await normalPost(
    "/dict/list-data-dict",
    params: {
      'pn': 1,
      'ps': 10,
      'code': 'custom_service_phone',
      'type': 'doctor',
    },
  );
}
