import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:date_utils/date_utils.dart';

class Countrie {
  final int confirmed;
  final int deaths;
  final int active;
  final int recovered;
  final String date;

  Countrie({
    @required this.confirmed,
    @required this.deaths,
    @required this.date,
    @required this.recovered,
    @required this.active,
  });

  factory Countrie.fromJson(Map<String, dynamic> json) {
    //var parsedDate = DateFormat.yMMMMd('en_US').format(json['Date']);
    // print(json['Date']);
    // print(parsedDate);p
    DateTime dateTime = DateTime.parse(json['Date']);
    var formatter = new DateFormat.MMMMd('en_US');
    String formatted = formatter.format(dateTime);
    //print(formatted);

    return Countrie(
      confirmed: json['Confirmed'] as int,
      deaths: json['Deaths'] as int,
      recovered: json['Recovered'] as int,
      active: json['Active'] as int,
      date: formatted as String,
    );
  }
}
