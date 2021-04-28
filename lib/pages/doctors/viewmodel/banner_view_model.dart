import 'package:dio/dio.dart';
import 'package:doctor/http/foundationSystem.dart';
import 'package:doctor/pages/doctors/model/banner_entity.dart';
import 'package:http_manager/api.dart';

class BannerViewModel {
  final String bannerType;

  BannerViewModel(this.bannerType);

  getBanner() async {
    try {
      var list =
          await API.shared.foundationSys.getBanner({"bannerLocation": bannerType});
      List<BannerEntity> result = list['records']
          .map<BannerEntity>((item) => BannerEntity.fromJson(item))
          .toList();
      return Future.value(result);
    } on DioError catch (e) {
      return Future.value(null);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }
}
