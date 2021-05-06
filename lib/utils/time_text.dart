

class RelativeDateFormat {
  static final num oneMinute = 60000;
  static final num oneHour = 3600000;
  static final num oneDay = 86400000;
  static final num oneWeek = 604800000;

  // static final String ONE_SECOND_AGO = "秒前";
  static final String oneMinuteAgp = "分钟前";
  static final String oneHourAgp = "小时前";
  static final String oneDayAgo = "天前";
  static final String oneMonthAgo = "月前";
  static final String oneYearAgo = "年前";

//时间转换
  static String format(int date) {
    num delta = DateTime.now().millisecondsSinceEpoch - date;
    if (delta < 5 * oneMinute) {
      return '刚刚';
    }
    if (delta < 60 * oneMinute) {
      num minutes = toMinutes(delta);
      return (minutes < 5 ? 5 : minutes).toInt().toString() + oneMinuteAgp;
    }
    if (delta < 24 * oneHour) {
      num hours = toHours(delta);
      return (hours < 1 ? 1 : hours).toInt().toString() + oneHourAgp;
    }
    if (delta < 48 * oneHour) {
      return "昨天";
    }
    if (delta < 30 * oneDay) {
      num days = toDays(delta);
      return (days < 1 ? 1 : days).toInt().toString() + oneDayAgo;
    }
    if (delta < 12 * 4 * oneWeek) {
      num months = toMonths(delta);
      return (months < 1 ? 1 : months).toInt().toString() + oneMonthAgo;
    } else {
      num years = toYears(delta);
      return (years < 1 ? 1 : years).toInt().toString() + oneYearAgo;
    }
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 12;
  }
}
