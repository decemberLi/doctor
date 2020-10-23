import 'package:doctor/http/http_manager.dart';
import 'package:doctor/model/attacements_model.dart';
import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager http = HttpManager('dtp');
HttpManager httpFoundation = HttpManager('foundation');

/// 开处方主页面viewModel
class PrescriptionViewModel extends ViewStateModel {
  PrescriptionModel data = PrescriptionModel();

  PrescriptionViewModel();

  Future<String> get prescriptionQRCode async {
    String qrCodeUrl = await this.loadQRCode();
    return qrCodeUrl;
  }

  /// 获取绑定二维码
  Future<String> loadQRCode() async {
    // var res = await httpFoundation.post(
    //   '/wechat-accounts/temp-qr-code',
    //   params: {
    //     'bizType': 'PRESCRIPTION_BIND',
    //     'bizId': data.prescriptionNo,
    //   },
    //   ignoreErrorTips: true,
    //   showLoading: false,
    // );
    // return res['qrCodeUrl'];
    String qrCodeUrl = await Future.delayed(
        Duration(seconds: 2),
        () =>
            'https://oss-dev.e-medclouds.com/Business-attachment/2020-07/100027/21212508-1595338102423.jpg');
    return qrCodeUrl;
  }

  List<String> get clinicaList => this.data.clinicalDiagnosis?.split(',') ?? [];

  set clinicaList(List<String> value) {
    if (value.isEmpty) {
      this.data.clinicalDiagnosis = null;
    } else {
      this.data.clinicalDiagnosis = value.join(',');
    }
  }

  /// 新增临床诊断
  addClinica(String value) {
    List<String> list = this.clinicaList;
    list.add(value);
    this.data.clinicalDiagnosis = list.join(',');
    notifyListeners();
  }

  /// 删除临床诊断
  removeClinica(int index) {
    List<String> list = this.clinicaList;
    list.removeAt(index);
    this.clinicaList = list;
    notifyListeners();
  }

  addByTemplate(PrescriptionTemplateModel data) {
    this.data.clinicalDiagnosis = data.clinicalDiagnosis;
    this.data.drugRp = data.drugRp;
    notifyListeners();
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 处方记录viewModel
class PrescriptionListViewModel extends ViewStateRefreshListModel {
  @override
  Future<List<PrescriptionModel>> loadData({int pageNum}) async {
    // var list = await httpDtp.post('/prescription/list', params: {
    //   'ps': 10,
    //   'pn': pageNum,
    // });
    // return list['records']
    //     .map<PrescriptionModel>((item) => PrescriptionModel.fromJson(item))
    //     .toList();
    List<PrescriptionModel> list = [];
    for (var i = 0; i < 10; i++) {
      String id = '$pageNum - $i';
      List<DrugModel> drugRp = [];
      for (var j = 0; j < 4; j++) {
        String drugId = '$id-$j';
        drugRp.add(
          DrugModel(
            drugId: drugId,
            drugName: '特制开菲尔-$drugId',
            producer: '石家庄龙泽制药股份有限公司',
            drugSize: '32',
            drugPrice: '347',
            frequency: '每日一次',
            singleDose: '32',
            doseUnit: '片/次',
            usePattern: '口服',
            quantity: '3',
          ),
        );
      }
      PrescriptionModel _model = PrescriptionModel(
        id: '$id',
        prescriptionNo: "NO-43243243-$id",
        prescriptionPatientName: '张三-$id',
        clinicalDiagnosis: '脑瘫,高血压-$id',
        prescriptionPatientAge: '23',
        prescriptionPatientSex: '0',
        status: 'WAIT_VERIFY',
        orderStatus: 'DONE',
        drugRp: drugRp,
        createTime: '1603366262120',
      );
      list.add(_model);
    }
    return Future.delayed(Duration(seconds: 1), () => list);
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 处方详情viewModel
class PrescriptionDetailModel extends ViewStateModel {
  final String prescriptionNo;
  PrescriptionModel data;

  PrescriptionDetailModel(this.prescriptionNo);

  initData() async {
    setBusy();
    data = await loadData();
    setIdle();
  }

  /// 获取处方详情
  Future<PrescriptionModel> loadData() async {
    // var res = await httpFoundation.post(
    //   '/prescription/query',
    //   params: {
    //     'prescriptionNo': this.prescriptionNo,
    //   },
    // );
    // return PrescriptionModel.fromJson(res);

    List<DrugModel> drugRp = [];
    List<AttacementsModel> attacements = [];
    for (var i = 0; i < 4; i++) {
      String drugId = '3232-$i';
      drugRp.add(
        DrugModel(
          drugId: drugId,
          drugName: '特制开菲尔-$drugId',
          producer: '石家庄龙泽制药股份有限公司',
          drugSize: '32',
          drugPrice: '347',
          frequency: '每日一次',
          singleDose: '32',
          doseUnit: '片/次',
          usePattern: '口服',
          quantity: '3',
        ),
      );
      attacements.add(AttacementsModel(
        ossId: '3432432',
        name: 'fdsafdsafd',
        url:
            'https://oss-dev.e-medclouds.com/Business-attachment/2020-07/100027/21212508-1595338102423.jpg',
      ));
    }
    String id = '323';
    PrescriptionModel _model = PrescriptionModel(
      id: '$id',
      prescriptionNo: "NO-43243243-$id",
      prescriptionPatientName: '张三-$id',
      clinicalDiagnosis: '脑瘫,高血压-$id',
      prescriptionPatientAge: '23',
      prescriptionPatientSex: '0',
      status: 'WAIT_VERIFY',
      orderStatus: 'DONE',
      drugRp: drugRp,
      createTime: '1603366262120',
      attachments: attacements,
    );
    return Future.delayed(Duration(seconds: 1), () => _model);
  }
}
