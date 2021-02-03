import 'dart:async';

import 'package:doctor/pages/doctors/model/banner_entity.dart';

import 'banner_view_model.dart';

class GossipViewModel {
  // ignore: close_sinks
  StreamController<List<BannerEntity>> _topBannerStreamController =
      StreamController<List<BannerEntity>>();
  BannerViewModel _topBannerModel = BannerViewModel("GOSSIP_TOP");


  get bannerStream => _topBannerStreamController.stream;

  dispose() {
    if (_topBannerStreamController != null &&
        !_topBannerStreamController.isClosed) {
      _topBannerStreamController.sink.close();
    }
  }

  refreshTopBanner() async {
    var banner = await _topBannerModel.getBanner();
    if(banner == null || banner.length == 0){
      return ;
    }
    _topBannerStreamController.sink.add(banner);
  }

  refresh() {
    refreshTopBanner();
  }
}
