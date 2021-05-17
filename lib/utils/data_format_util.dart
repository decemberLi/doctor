_format(int number) {
  if (number < 10) {
    return '0$number';
  }
  return '$number';
}

dateFormat(num timeMillis) {
  if (timeMillis == null) {
    return '';
  }
  var msgDateTime = DateTime.fromMillisecondsSinceEpoch(timeMillis);
  var now = DateTime.now();
  var toDayStartTime = DateTime(now.year, now.month, now.day);
  // 当日
  if (timeMillis >= toDayStartTime.millisecondsSinceEpoch) {
    return '${_format(msgDateTime.hour)}:${_format(msgDateTime.minute)}';
  }
  // 昨天
  var yesterday = now.subtract(new Duration(days: 1));
  var yesterdayStartTime =
      DateTime(yesterday.year, yesterday.month, yesterday.day);
  if (timeMillis >= yesterdayStartTime.millisecondsSinceEpoch) {
    return '昨天';
  } else {
    // 其他
    //2020/10/12
    return '${_format(msgDateTime.year)}/${_format(msgDateTime.month)}/${_format(msgDateTime.day)}';
  }
}

normalDateFormate(int timeMillis){
  var msgDateTime = DateTime.fromMillisecondsSinceEpoch(timeMillis);
  return '${_format(msgDateTime.year)}年${_format(msgDateTime.month)}月${_format(msgDateTime.day)}日';
}
