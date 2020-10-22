import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:doctor/pages/prescription/view_model/medication_view_model.dart';
import 'package:doctor/pages/prescription/widgets/medication_add_sheet.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_modal.dart';
import 'package:doctor/widgets/common_spinner_input.dart';
import 'package:doctor/widgets/one_line_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 药品列表页面列表项
class MedicationListItem extends StatefulWidget {
  final DrugModel item;
  final bool showEdit;
  final bool showExtra;
  final Function(DrugModel data) onAdd;
  MedicationListItem(
    this.item, {
    this.onAdd,
    this.showEdit = false,
    this.showExtra = false,
  });

  @override
  _MedicationListItemState createState() => _MedicationListItemState();
}

class _MedicationListItemState extends State<MedicationListItem> {
  // 药品总数
  double _quantity = 0;

  initialize() {
    _quantity = double.parse(widget.item.quantity ?? '0');
  }

  @override
  void initState() {
    print('${widget.item.drugName} --- ${widget.item.quantity}');
    initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(MedicationListItem oldWidget) {
    print(
        'didUpdateWidget --- ${widget.item.drugName} --- ${widget.item.quantity}');
    initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  didChangeDependencies() {
    // print('didChangeDependencies');
    super.didChangeDependencies();
  }

  // 显示药品添加弹窗
  Future<void> _showMedicationInfoSheet(Function onSave) {
    return CommonModal.showBottomSheet(
      context,
      title: '药品用法用量',
      height: 560,
      child: MedicationAddSheet(
        widget.item,
        onSave: () {
          onSave();
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget renderBtn(context, MedicationViewModel model, child) {
    if (this._quantity == 0) {
      return AceButton(
        width: 100,
        height: 30,
        fontSize: 14,
        text: '加入处方笺',
        onPressed: () {
          _showMedicationInfoSheet(() {
            model.addToCart(widget.item);
          });
        },
      );
    }
    return AceSpinnerInput(
      spinnerValue: this._quantity,
      onChange: (newValue) {
        setState(() {
          this._quantity = newValue;
          widget.item.quantity = this._quantity.toStringAsFixed(0);
          model.changeDataNotify();
        });
      },
    );
  }

  Widget renderEdit(context, MedicationViewModel model, child) {
    if (!widget.showEdit) {
      return Container();
    }
    return Container(
      width: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _showMedicationInfoSheet(() {
                model.changeDataNotify();
              });
            },
            child: Text(
              '编辑',
              style: MyStyles.primaryTextStyle_12,
            ),
          ),
          GestureDetector(
            onTap: () {
              model.removeFromCart(widget.item);
            },
            child: Text(
              '删除',
              style: MyStyles.primaryTextStyle_12,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderExtra() {
    if (!widget.showExtra) {
      return Container();
    }
    return OneLineText(
      '用法用量：${widget.item.useInfo}',
      style: MyStyles.labelTextStyle_12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.item.pictures[0],
            width: 60.0,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(widget.item.drugName,
                          style: MyStyles.boldTextStyle),
                    ),
                    Consumer<MedicationViewModel>(
                      builder: renderEdit,
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(widget.item.drugSize, style: MyStyles.boldTextStyle_12),
                SizedBox(
                  height: 6,
                ),
                Text('厂家：${widget.item.producer}',
                    style: MyStyles.boldTextStyle_12),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '￥ ${widget.item.drugPrice}',
                      style: TextStyle(
                        color: ThemeColor.colorFFFD4B40,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Consumer<MedicationViewModel>(
                      builder: renderBtn,
                    ),
                  ],
                ),
                renderExtra(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
