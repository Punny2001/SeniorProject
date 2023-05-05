import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String formatDate(DateTime dateTime, String userType) {
  switch (userType) {
    case 'Staff':
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
      return DateFormat.yMMMMd().format(dateTime);
      break;
    case 'StaffShort':
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
      return DateFormat.yMMMd().format(dateTime);
      break;
    case 'Athlete':
      {
        Intl.defaultLocale = 'th';
        initializeDateFormatting();
        return DateFormat.yMMMMd('th').format(dateTime);
      }
      break;
    default:
  }
}

String formatTime(DateTime dateTime, String userType) {
  switch (userType) {
    case 'Staff':
      return DateFormat('hh:mm a').format(dateTime);
      break;

    case 'Athlete':
      return DateFormat('hh:mm').format(dateTime);
      break;
    default:
      break;
  }
}
