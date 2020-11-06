import 'package:doctor/pages/medication/view_model/medication_view_model.dart';
import 'package:doctor/pages/message/view_model/message_center_view_model.dart';
import 'package:doctor/pages/prescription/view_model/prescription_view_model.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

/// 独立的model
List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<PrescriptionViewModel>(
    create: (context) => PrescriptionViewModel(),
  ),
  // 暂时将药品的列表放在全局中，后面再移到页面中
  ChangeNotifierProvider<MedicationViewModel>(
    create: (context) => MedicationViewModel(),
  ),
  ChangeNotifierProvider<UserInfoViewModel>(
    create: (context) => UserInfoViewModel(),
  ),
  ChangeNotifierProvider<MessageCenterViewModel>(
    create: (context) => MessageCenterViewModel(),
  ),
];

/// 需要依赖的model
///
/// UserModel依赖globalFavouriteStateModel
List<SingleChildWidget> dependentServices = [
  // ChangeNotifierProxyProvider<GlobalFavouriteStateModel, UserModel>(
  //   create: null,
  //   update: (context, globalFavouriteStateModel, userModel) =>
  //   userModel ??
  //       UserModel(globalFavouriteStateModel: globalFavouriteStateModel),
  // )
];

List<SingleChildWidget> uiConsumableProviders = [
//  StreamProvider<User>(
//    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
//  )
];
