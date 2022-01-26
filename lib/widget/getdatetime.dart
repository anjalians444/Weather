

import 'package:intl/intl.dart';

getCustomFormattedDateTime(String givenDateTime, String dateFormat) {
  // dateFormat = 'MM/dd/yy';
  final DateTime docDateTime = DateTime.parse(givenDateTime);
  return DateFormat(dateFormat).format(docDateTime);
  //DateTime now = DateTime.now();
}
getCustomFormattedTime() {
  final now = new DateTime.now();
  String formatter =    new DateFormat.jm().format(now);
}