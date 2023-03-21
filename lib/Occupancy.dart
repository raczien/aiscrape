import 'package:intl/intl.dart';

const int kMax = 485;

class Occupancy {
  final int amount;
  final double percent;
  final DateTime dateTime;
  final String weekDay;

  Occupancy({required this.amount, required this.percent, required this.dateTime, required this.weekDay});

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'percent': percent,
    'dateTime': dateTime,
    'weekDay': weekDay,
  };


  @override
  String toString() {
    return 'Occupancy{amount: $amount, percent: $percent, dateTime: $dateTime, weekDay: $weekDay}';
  }

  static Occupancy fromJson(Map<String, dynamic> json) {
    DateTime datetime = DateTime.parse(json['datetime']);
    return Occupancy(
      amount: ((json['percent'] as double) /100 * kMax).round(),
      percent: json['percent'],
      dateTime: datetime,
      weekDay: DateFormat('EEEE').format(datetime),
    );
  }
}