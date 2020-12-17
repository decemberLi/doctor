import 'package:flutter_easyloading/flutter_easyloading.dart';

extension falshEx on EasyLoading {
  flash(Future Function() load, {String text = "加载中..."}) async {
    EasyLoading.show(status: text);
    try {
      await load();
    } catch (e) {
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
