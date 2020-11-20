import 'package:common_utils/common_utils.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

HttpManager http = HttpManager('dtp');

class MedicationViewModel extends ViewStateRefreshListModel<DrugModel> {
  List<DrugModel> cartList = [];

  MedicationViewModel();

  /// 总价
  double get totalPrice => cartList.fold(
        0,
        (previousValue, drugModel) => NumUtil.add(
          previousValue,
          NumUtil.multiply(
            drugModel.drugPrice ?? 0,
            drugModel.quantity ?? 0,
          ),
        ),
      );

  @override
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  @override
  Future<List<DrugModel>> loadData({int pageNum}) async {
    List<DrugModel> list = [];
    try {
      var data =
          await http.post('/drug/list', params: {'ps': 10, 'pn': pageNum});
      list = data['records']
          .map<DrugModel>((item) => DrugModel.fromJson(item))
          .toList();
      combineListToCart(list);
    } catch (e) {}

    return list;
  }

  void combineListToCart(List<DrugModel> list) {
    for (var i = 0; i < list.length; i++) {
      DrugModel _model = list[i];
      int index =
          cartList.indexWhere((element) => element.drugId == _model.drugId);
      if (index != -1) {
        DrugModel _cartModel = cartList[index];
        _model.quantity = _cartModel.quantity;
        _model.frequency = _cartModel.frequency;
        _model.doseUnit = _cartModel.doseUnit;
        _model.singleDose = _cartModel.singleDose;
        _model.usePattern = _cartModel.usePattern;
        cartList[index] = _model;
      } else {
        /// 如果购物车为空，则全部置为空
        _model.quantity = null;
      }
    }
  }

  void initCart(List<DrugModel> data) {
    this.cartList = [...data];
    if (this.list.isNotEmpty) {
      combineListToCart(this.list);
      notifyListeners();
    }
  }

  bool checkCount(){
    if(cartList.length >=5){
      EasyLoading.showToast('最多只能选择5种药品');
      return false;
    }
    return true;
  }

  void addToCart(DrugModel item) {
    this.cartList.add(item);
    notifyListeners();
  }

  void removeFromCart(DrugModel item) {
    item.frequency = null;
    item.singleDose = null;
    item.doseUnit = null;
    item.usePattern = null;
    item.quantity = null;
    this.cartList.remove(item);
    notifyListeners();
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 药品详情viewModel
class MedicationDetailViewModel extends ViewStateModel {
  final int drugId;
  DrugModel data;

  MedicationDetailViewModel(this.drugId);

  initData() async {
    setBusy();
    data = await loadData();
    setIdle();
  }

  /// 获取处方详情
  Future<DrugModel> loadData() async {
    var res = await http.post(
      '/drug/query',
      params: {
        'drugId': this.drugId,
      },
    );
    return DrugModel.fromJson(res);
    // DrugModel res = DrugModel(
    //   drugId: drugId,
    //   drugName: '特制开菲尔-$drugId',
    //   producer: '石家庄龙泽制药股份有限公司',
    //   drugSize: '32',
    //   drugPrice: 347,
    //   frequency: '每日一次',
    //   singleDose: '32',
    //   doseUnit: '片/次',
    //   usePattern: '口服',
    //   quantity: 3,
    // );
    // return Future.delayed(Duration(seconds: 1), () => res);
  }
}
