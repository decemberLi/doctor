import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/common_spinner_input.dart';
import 'package:flutter/material.dart';

class MedicationListItem extends StatefulWidget {
  final DrugModel model;
  final Function(DrugModel data) onAdd;
  MedicationListItem(this.model, {this.onAdd});

  @override
  _MedicationListItemState createState() => _MedicationListItemState();
}

class _MedicationListItemState extends State<MedicationListItem> {
  // 药品总数
  double _quantity = 0;

  initialize() {
    _quantity = double.parse(widget.model.quantity ?? '0');
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(MedicationListItem oldWidget) {
    initialize();
    super.didUpdateWidget(oldWidget);
  }

  Widget renderBtn() {
    if (this._quantity == 0) {
      return AceButton(
        width: 100,
        height: 30,
        fontSize: 14,
        text: '加入处方笺',
        onPressed: () {
          // setState(() {
          //   this._quantity = 1;
          //   widget.model.quantity = this._quantity.toStringAsFixed(0);
          //   widget.onAdd(widget.model);
          // });
          widget.onAdd(widget.model);
        },
      );
    }
    return AceSpinnerInput(
      spinnerValue: this._quantity,
      onChange: (newValue) {
        setState(() {
          this._quantity = newValue;
        });
      },
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
            widget.model.pictures[0],
            width: 60.0,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.model.drugName, style: MyStyles.boldTextStyle),
                SizedBox(
                  height: 6,
                ),
                Text(widget.model.drugSize, style: MyStyles.boldTextStyle_12),
                SizedBox(
                  height: 6,
                ),
                Text('厂家：${widget.model.producer}',
                    style: MyStyles.boldTextStyle_12),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '￥ ${widget.model.drugPrice}',
                      style: TextStyle(
                        color: ThemeColor.colorFFFD4B40,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    renderBtn(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
