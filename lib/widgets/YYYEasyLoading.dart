import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

extension falshEx on EasyLoading {
  flash(Future Function() load, {String text = "加载中..."}) async {
    EasyLoading.show(status: text);
    try {
      await load();
      EasyLoading.dismiss();
    }on DioError catch (e) {
      if (e.error is SocketException){
        EasyLoading.showToast("网络错误");
      }else{
        EasyLoading.showToast(e.message);
      }
      rethrow;
    } catch (e){
      if (e is String){
        EasyLoading.showToast(e);
      }else{
        EasyLoading.dismiss();
      }
    }
  }

  toastError(Future Function() load ) async{
    try {
      await load();
    }on DioError catch (e) {
      if (e.error is SocketException){
        EasyLoading.showToast("网络错误");
      }else{
        EasyLoading.showToast(e.message);
      }
      rethrow;
    }catch(e){
      rethrow;
    }
  }

}
