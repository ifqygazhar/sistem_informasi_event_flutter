import 'package:intl/intl.dart';

class DateFormatter {
  static String formatEventDate(String isoDate) {
    try {
      final DateTime dateTime = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return isoDate; // Return original if parsing fails
    }
  }

  static String formatDateOnly(String isoDate) {
    try {
      final DateTime dateTime = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  static String formatTimeOnly(String isoDate) {
    try {
      final DateTime dateTime = DateTime.parse(isoDate);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  static String formatDateRange(String startDate, String endDate) {
    try {
      final DateTime start = DateTime.parse(startDate);
      final DateTime end = DateTime.parse(endDate);

      // If same day, show: 30 Apr 2025, 13:24 - 13:19
      if (start.day == end.day &&
          start.month == end.month &&
          start.year == end.year) {
        return "${DateFormat('dd MMM yyyy').format(start)}, ${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}";
      }

      // If different days: 30 Apr 2025, 13:24 - 1 May 2025, 13:19
      return "${DateFormat('dd MMM yyyy').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}";
    } catch (e) {
      return "$startDate - $endDate";
    }
  }
}
