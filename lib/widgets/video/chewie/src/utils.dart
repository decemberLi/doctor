String formatDuration(Duration position) {
  // final ms = position.inMilliseconds;
  //
  // int seconds = ms ~/ 1000;
  // final int hours = seconds ~/ 3600;
  // seconds = seconds % 3600;
  // var minutes = seconds ~/ 60;
  // seconds = seconds % 60;
  //
  // final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';
  //
  // final minutesString =
  //     minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';
  //
  // final secondsString =
  //     seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';
  //
  // final formattedTime =
  //     '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

  var seconds = (position.inMilliseconds / 1000).floor();
  if (seconds <= 0) {
    return "00:00";
  }
  var secondsStr = (seconds % 60).floor();
  var minutes = (seconds / 60).floor();

  var secondString = "$secondsStr";
  var minutesStr = "$minutes";
  if (secondsStr < 10) {
    secondString = "0$secondsStr";
  }
  if (minutes < 10) {
    minutesStr = "0$minutes";
  }

  return "$minutesStr:$secondString";
}
