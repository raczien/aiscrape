import 'dart:math';

import 'package:aiscrape/firebaseService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'Occupancy.dart';

class OccupancyChart extends StatefulWidget {
  final Function getDate;
  final Function(DateTime) setDate;

  const OccupancyChart({Key? key, required this.getDate, required this.setDate})
      : super(key: key);

  @override
  State<OccupancyChart> createState() => _OccupancyChartState();
}

class _OccupancyChartState extends State<OccupancyChart> {
  Future<List<Occupancy>> getData() async {
    return await FirebaseService.getDataForDate(widget.getDate());
  }

  late List<Occupancy> data;
  List<LineChartBarData> lineBarsData = [];
  List<Occupancy> lastWeekData = [];
  var currentSelectedDate = DateTime.now();
  bool checkLastWeekSummary = false;

  @override
  Widget build(BuildContext context) {
    var calendarDate = widget.getDate();
    if (DateTime(currentSelectedDate.year, currentSelectedDate.month,
            currentSelectedDate.day) !=
        DateTime(calendarDate.year, calendarDate.month, calendarDate.day)) {
      lineBarsData = [];
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FilledButton.tonal(
            onPressed: setLastWeekLineBarData,
            /*style:
                OutlinedButton.styleFrom(primary: Colors.teal.shade500),*/
            child: const Text(
              "Vergleich mit Vorwoche",
              style: TextStyle(
                color: Color.fromRGBO(165, 187, 65, 1.0),
                fontSize: 20,
              ),
            ),
          ),
        ),
        FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                currentSelectedDate = widget.getDate();
                data = snapshot.data ?? [];
                return AspectRatio(
                  aspectRatio: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 24,
                      bottom: 12,
                    ),
                    child: LineChart(
                      checkLastWeekSummary ? mainData() : mainData(),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    );
  }

  setLastWeekLineBarData() async {
    var spots = await getFLSpotForLastWeek(
        (widget.getDate() as DateTime).subtract(const Duration(days: 7)));
    var data = LineChartBarData(
      spots: spots,
      isCurved: false,
      gradient: const LinearGradient(
        colors: [Colors.orange, Colors.deepOrange],
      ),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
    );
    setState(() {
      lineBarsData.add(data);
    });
  }

  LineChartData mainData() {
    var allData = data + lastWeekData;
    var maxYVal = allData.map((e) => e.amount).toList().reduce(max).toDouble();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 4,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.lightBlue,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.teal,
            strokeWidth: 1,
          );
        },
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((e) {
              return LineTooltipItem("${e.y} (${(e.y / 485 * 100).toInt()} %)",
                  const TextStyle(color: Colors.tealAccent));
            }).toList();
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 55,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: data.length.toDouble() - 1,
      minY: 0,
      maxY: maxYVal * 1.1,
      lineBarsData: [
        LineChartBarData(
          spots: getFLSpotForDate(),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
        ...lineBarsData,
      ],
    );
  }

  List<Color> gradientColors = [
    Colors.tealAccent,
    Colors.teal.shade700,
  ];

  List<FlSpot> getFLSpotForDate() {
    return data
        .map((e) => FlSpot(data.indexOf(e) as double, e.amount as double))
        .toList();
  }

  Future<List<FlSpot>> getFLSpotForLastWeek(DateTime day) async {
    var lastWeeksData = await FirebaseService.getDataForDate(day);
    lastWeeksData.sort((a, b) => (a.dateTime).compareTo(b.dateTime));
    setState(() {
      lastWeekData = lastWeeksData;
    });
    var spots = lastWeeksData
        .where((element) {
          bool exists = false;
          for (var d in data) {
            if (element.dateTime.hour == d.dateTime.hour &&
                element.dateTime.minute == d.dateTime.minute) {
              exists = true;
            }
          }
          return exists;
        })
        .map((e) =>
            FlSpot(lastWeeksData.indexOf(e) as double, e.amount as double))
        .toList();
    return spots;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 25:
        text = '25';
        break;
      case 50:
        text = '50';
        break;
      case 75:
        text = '75';
        break;
      case 100:
        text = '100';
        break;
      case 125:
        text = '125';
        break;
      case 150:
        text = '150';
        break;
      case 175:
        text = '175';
        break;
      case 200:
        text = '200';
        break;
      case 225:
        text = '225';
        break;
      case 250:
        text = '250';
        break;
      case 275:
        text = '375';
        break;
      case 300:
        text = '300';
        break;
      case 325:
        text = '325';
        break;
      case 350:
        text = '350';
        break;
      case 375:
        text = '375';
        break;
      case 400:
        text = '400';
        break;
      case 425:
        text = '425';
        break;
      case 450:
        text = '450';
        break;
      case 475:
        text = '475';
        break;
      case 500:
        text = '500';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (checkTime(value, "01:00")) {
      text = const Text('1:00', style: style);
    } else if (checkTime(value, "02:00")) {
      text = const Text('\n2:00', style: style);
    } else if (checkTime(value, "06:00")) {
      text = const Text('\n6:00', style: style);
    } else if (checkTime(value, "07:00")) {
      text = const Text('7:00', style: style);
    } else if (checkTime(value, "08:00")) {
      text = const Text('\n8:00', style: style);
    } else if (checkTime(value, "09:00")) {
      text = const Text('9:00', style: style);
    } else if (checkTime(value, "10:00")) {
      text = const Text('\n10:00', style: style);
    } else if (checkTime(value, "11:00")) {
      text = const Text('11:00', style: style);
    } else if (checkTime(value, "12:00")) {
      text = const Text('\n12:00', style: style);
    } else if (checkTime(value, "13:00")) {
      text = const Text('13:00', style: style);
    } else if (checkTime(value, "14:00")) {
      text = const Text('\n14:00', style: style);
    } else if (checkTime(value, "15:00")) {
      text = const Text('15:00', style: style);
    } else if (checkTime(value, "16:00")) {
      text = const Text('\n16:00', style: style);
    } else if (checkTime(value, "17:00")) {
      text = const Text('17:00', style: style);
    } else if (checkTime(value, "18:00")) {
      text = const Text('\n18:00', style: style);
    } else if (checkTime(value, "19:00")) {
      text = const Text('19:00', style: style);
    } else if (checkTime(value, "20:00")) {
      text = const Text('\n20:00', style: style);
    } else if (checkTime(value, "21:00")) {
      text = const Text('21:00', style: style);
    } else if (checkTime(value, "22:00")) {
      text = const Text('\n22:00', style: style);
    } else if (checkTime(value, "23:00")) {
      text = const Text('23:00', style: style);
    } else if (checkTime(value, "00:00")) {
      text = const Text('\n00:00', style: style);
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  bool checkTime(double value, String time) {
    return data[value.toInt()].dateTime.toString().split(" ")[1].contains(time);
  }
}
