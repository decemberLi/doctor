
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorFeedsReadModel extends ChangeNotifier {
  static var shared = DoctorFeedsReadModel._();
  Set<String> ids = Set<String>();
  SharedPreferences _sp;
  DoctorFeedsReadModel._(){
    SharedPreferences.getInstance().then((sp) {
       try {
         _sp = sp;
         List<String> list = sp.get("DoctorFeedsReadIds");
         ids = list.toSet();
         notifyListeners();
       }catch(e){

       }
    });
  }
  void addRead(int id){
    ids.add("$id");
    notifyListeners();
    _sp.setStringList("DoctorFeedsReadIds", ids.toList());
  }

  bool isRead(int id){
    return ids.contains("$id");
  }
}