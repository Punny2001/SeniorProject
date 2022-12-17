import 'package:easy_localization/easy_localization.dart';

String formatDate(DateTime date, String userType) {
  Map<String, String> months = {
    "January": "มกราคม",
    "February": "กุมภาพันธ์",
    "March": "มีนาคม",
    "April": "เมษายน",
    "May": "พฤษภาคม",
    "June": "มิถุนายน",
    "July": "กรกฎาคม",
    "August": "สิงหาคม",
    "September": "กันยายน",
    "October": "ตุลาคม",
    "November": "พฤศจิกายน",
    "December": "ธันวาคม",
  };

  print(date);
  switch (userType) {
    case 'Staff':
      return DateFormat.yMMMMd().format(date);
      break;
    case 'Athlete':
      {
        String date_in_Thai = DateFormat.yMMMMd().format(date);
        date_in_Thai.s
      }
      break;
    default:
  }
}
