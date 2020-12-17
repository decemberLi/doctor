import 'package:flutter_easyloading/flutter_easyloading.dart';

extension falshEx on EasyLoading {
  static flash(Future Function() load,{String text = "加载中..."})async {
    EasyLoading.show(status: text);
    await load();
    EasyLoading.dismiss();
  }
}
