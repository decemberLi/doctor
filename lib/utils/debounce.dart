// debounce.dart

var event = [-1, -1];

/// 函数防抖
///
/// [func]: 要执行的方法
/// [delay]: 要迟延的时长
Function debounce(Function func, {int duration = 300}) {
  return () {
    var nowClickMills = DateTime.now().millisecondsSinceEpoch;
    if (event[0] == -1 && event[1] == -1) {
      print('sure click');
      event[1] = nowClickMills;
      func();
    }
    event[0] = event[1];
    event[1] = nowClickMills;
    print('clicked time ---> $nowClickMills, duration --> ${event[1] - event[0]}');
    if (event[1] - event[0] > duration) {
      // 有效点击
      print('有效点击 ----------------');
      event[1] = nowClickMills;
      func();
      return;
    }

    print('无有效点击 ----------------');
  };
}
