import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/prescription/widgets/rp_list_item.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 处方药品列表
class RpList extends StatelessWidget {
  final List<DrugModel> list;

  final Function onAdd;

  final Function onItemQuantityChange;
  final Function onItemDelete;
  final Function onItemEdit;

  RpList({
    this.list = const <DrugModel>[],
    this.onAdd,
    this.onItemQuantityChange,
    this.onItemDelete,
    this.onItemEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ...list
              .map(
                (e) => RpListItem(
                    data: e,
                    index: list.indexOf(e),
                    onDelete: (val) {
                      list.remove(e);
                      this.onItemDelete(e);
                    },
                    onEdit: (val) {
                      this.onItemEdit(val);
                    },
                    onQuantityChange: (newQuantity) {
                      this.onItemQuantityChange(e, newQuantity);
                    }),
              )
              .toList(),
          AceButton(
            type: AceButtonType.secondary,
            onPressed: () async {
              if (list?.length != null && list.length >= 5) {
                EasyLoading.showToast('最多只能选择5种药品');
                return;
              }
              var addList = await Navigator.pushNamed(
                context,
                RouteManagerOld.MEDICATION_LIST,
                arguments: list,
              );
              // print(list);
              if (addList != null) {
                this.onAdd(addList);
              }
            },
            width: 295,
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 16,
                  color: ThemeColor.primaryColor,
                ),
                Text(
                  '添加药品',
                  style:
                      TextStyle(color: ThemeColor.primaryColor, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Icon(
                  Icons.circle,
                  size: 6,
                  color: ThemeColor.colorFFFD4B40,
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    '国家规定，对首诊患者进行医疗行为时，必须当面诊查。',
                    style: MyStyles.labelTextStyle_12.copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
