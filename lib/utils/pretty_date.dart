import 'package:intl/intl.dart';

String prettify(DateTime dt) {
  DateTime dtLocal = dt.toLocal();
  DateTime now = DateTime.now();

  if (dtLocal.day == now.day &&
      dtLocal.month == now.month &&
      dtLocal.year == now.year) {
    return DateFormat.jm().format(dtLocal);
  } else if (now.difference(dtLocal).inDays < 7 && !dtLocal.isAfter(now)) {
    // guardnig for time travel
    return DateFormat.EEEE().format(dtLocal);
  }
  return DateFormat.yMd().format(dtLocal);
}
