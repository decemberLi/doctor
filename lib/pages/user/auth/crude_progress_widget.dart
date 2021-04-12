import 'package:doctor/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _State {
  final bool isFinish;
  final bool isCurrent;
  final int currStep;

  _State(this.isFinish, this.isCurrent, this.currStep);
}

class CrudeProgressWidget extends StatelessWidget {
  final allStep = 2;
  final int step;

  CrudeProgressWidget(this.step);

  @override
  Widget build(BuildContext context) {
    circle(state) {
      return Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: state.isFinish || state.isCurrent
                ? const Color(0xFF107BFD)
                : const Color(0xFF88BEFF),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: state.isFinish
            ? Icon(Icons.check_rounded,color: Colors.white,)
            : Text(
                "${state.currStep}",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
      );
    }

    _State fistStepState = _State(step > 1, step == 1, 1);
    _State secondStepState = _State(step > 2, step == 2, 2);
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              circle(fistStepState),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  '实名信息',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF414141),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 10, top: 4),
            child: Image.asset(
              'assets/images/icon_flow.png',
              width: 20,
              height: 22,
            ),
          ),
          Column(
            children: [
              circle(secondStepState),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  '医师身份信息',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF414141),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
