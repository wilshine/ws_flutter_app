

class WSDateUtil {
  static String parseTimeYYMMDD(DateTime time) {
    String month = '${time.month}'.padLeft(2, '0');
    String day = '${time.day}'.padLeft(2, '0');
    return '${time.year}-$month-$day';
  }

  ///解析时间 一天以内显示 12:12;超过一天显示 12-12 12:21;非今年显示： 2022-12-12 未读消息：超过99显示99+
  static String parseTime(DateTime time) {
    DateTime now = DateTime.now();
    if (time.year == now.year) {
      if (time.month == now.month && time.day == now.day) {
        return '${time.hour}:${time.minute}';
      } else {
        return '${time.month}-${time.day} ${time.hour}:${time.minute}';
      }
    } else {
      return '${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}';
    }
  }

  //将 unix 时间戳转换为特定时间文本，如年月日
  static String convertTime(int timestamp) {
    DateTime msgTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime nowTime = DateTime.now();

    if (nowTime.year == msgTime.year) {
      //同一年
      if (nowTime.month == msgTime.month) {
        //同一月
        if (nowTime.day == msgTime.day) {
          //同一天 时:分
          return "${msgTime.hour}:${msgTime.minute}";
        } else {
          if (nowTime.day - msgTime.day == 1) {
            //昨天
            return "yesterday";
          } else if (nowTime.day - msgTime.day < 7) {
            return _getWeekday(msgTime.weekday);
          }
        }
      }
    }
    return "${msgTime.year}/${msgTime.month}/${msgTime.day}";
  }

  ///是否需要显示时间，相差 5 分钟
  static bool needShowTime(int sentTime1, int sentTime2) {
    return (sentTime1 - sentTime2).abs() > 5 * 60 * 1000;
  }

  static String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "Sunday";
    }
  }
}