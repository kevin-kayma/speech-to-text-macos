import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages

extension DateTimeExtension on DateTime {
  String get getFormattedDateTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final day = twoDigits(this.day);
    final month = twoDigits(this.month);
    final year = this.year.toString();
    final hour = twoDigits(this.hour);
    final minute = twoDigits(this.minute);

    return '$day/$month/$year $hour:$minute';
  }

  DateTime get today {
    return DateTime(year, month, day);
  }

  DateTime get getMonth {
    return DateTime(year, month);
  }

  DateTime get yearOnly {
    return DateTime(year);
  }

  DateTime get nextMonth {
    return DateTime(year, (month + 1));
  }

  DateTime get previousMonth {
    return DateTime(year, (month - 1));
  }

  ///Returns a Date as a String in '01/01/2000' format
  String get dateOnly {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  ///Returns Hour and Time in 12 hour format as String From DateTime Object
  ///Format: '12:12 PM'
  String get timeOnly {
    int hours = hour;
    int minutes = minute;
    String period = (hours >= 12) ? 'PM' : 'AM';

    ///Convert to 12 hour format
    if (hours > 12) {
      hours -= 12;
    } else if (hours == 0) {
      hours = 12;
    }

    String formattedTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';

    return formattedTime;
  }

  ///Returns Hour and Time in 12 hour format as String From DateTime Object
  ///Format: '12 PM'
  String get hourOnly {
    int hours = hour;
    String period = (hours >= 12) ? 'PM' : 'AM';

    ///Convert to 12 hour format
    if (hours > 12) {
      hours -= 12;
    } else if (hours == 0) {
      hours = 12;
    }
    String formattedTime = '${hours.toString().padLeft(2, '0')}:00 $period';
    return formattedTime;
  }
}

extension TimeExtension on TimeOfDay {
  bool isEqual(TimeOfDay time) {
    return this == time;
  }

  bool isBefore(TimeOfDay time) {
    int startSeconds = (hour * 3600) + (minute * 60);
    int endSeconds = (time.hour * 3600) + (time.minute * 60);
    return startSeconds < endSeconds;
  }

  bool isAfter(TimeOfDay time) {
    int startSeconds = (hour * 3600) + (minute * 60);
    int endSeconds = (time.hour * 3600) + (time.minute * 60);
    return startSeconds > endSeconds;
  }
}
