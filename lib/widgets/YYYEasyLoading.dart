import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

extension falshEx on EasyLoading {
  flash(Future Function() load, {String text = "加载中..."}) async {
    EasyLoading.show(status: text);
    try {
      await load();
      EasyLoading.dismiss();
    }on DioError catch (e) {
      EasyLoading.showToast(e.message);
      rethrow;
    } catch (e){
      EasyLoading.dismiss();
    }
  }

  toastError(Future Function() load, ) async{
    try {
      await load();
    }on DioError catch (e) {
      EasyLoading.showToast(e.message);
      rethrow;
    }
  }

}
