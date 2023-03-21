import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Occupancy.dart';

class OccupancyDataChart extends StatefulWidget {
  final List<Occupancy> data;

  const OccupancyDataChart({super.key, required this.data});

  @override
  State<OccupancyDataChart> createState() => _OccupancyDataChartState();
}

class _OccupancyDataChartState extends State<OccupancyDataChart> {
  List<Color> gradientColors = [
    Colors.tealAccent,
    Colors.teal.shade700,
  ];

  DateTime nearestQuarter(DateTime val) {
    return DateTime(val.year, val.month, val.day, val.hour,
        [15, 30, 45, 60][(val.minute / 15).floor()]);
  }

  DateTime selectedDate = DateTime.now();
  DateTime focussedDate = DateTime.now();

  List<Occupancy> findMinMaxDate() {
    List<Occupancy> sortedList = widget.data;
    sortedList.sort((a, b) => (a.dateTime).compareTo(b.dateTime));
    return [sortedList.first, sortedList.last];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 1000
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                color: Colors.teal.shade400,
                child: ClipRRect(
                  child: TableCalendar(
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    firstDay: findMinMaxDate()[0].dateTime,
                    lastDay: findMinMaxDate()[1].dateTime,
                    focusedDay: selectedDate,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.white,
                      ),
                      weekendStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                        color: Colors.teal.shade700,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.teal.shade900,
                        shape: BoxShape.circle,
                      ),
                      disabledTextStyle: const TextStyle(
                        color: Colors.black26,
                        fontSize: 20,
                      ),
                      outsideDaysVisible: false,
                      defaultTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      weekendTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    onPageChanged: (focusedDay) {
                      selectedDate = focusedDay;
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDate = selectedDay;
                        focussedDate = focusedDay;
                      });
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDate, date);
                    },
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18,
                        left: 12,
                        top: 24,
                        bottom: 12,
                      ),
                      child: LineChart(
                        mainData(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var currData = getDataForDate(selectedDate);
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("01:00:00"))
      text = const Text('1:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("02:00:00"))
      text = const Text('\n2:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("06:00:00"))
      text = const Text('\n6:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("07:00:00"))
      text = const Text('7:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("08:00:00"))
      text = const Text('\n8:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("09:00:00"))
      text = const Text('9:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("10:00:00"))
      text = const Text('\n10:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("11:00:00"))
      text = const Text('11:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("12:00:00"))
      text = const Text('\n12:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("13:00:00"))
      text = const Text('13:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("14:00:00"))
      text = const Text('\n14:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("15:00:00"))
      text = const Text('15:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("16:00:00"))
      text = const Text('\n16:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("17:00:00"))
      text = const Text('17:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("18:00:00"))
      text = const Text('\n18:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("19:00:00"))
      text = const Text('19:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("20:00:00"))
      text = const Text('\n20:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("21:00:00"))
      text = const Text('21:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("22:00:00"))
      text = const Text('\n22:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("23:00:00"))
      text = const Text('23:00', style: style);
    else if (nearestQuarter(currData[value.toInt()].dateTime)
        .toString()
        .contains("00:00:00"))
      text = const Text('\n00:00', style: style);
    else
      text = Text('');

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
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

  List<Occupancy> getDataForDate(DateTime day) {
    List<Occupancy> dayData = widget.data
        .where((element) =>
            DateTime(day.year, day.month, day.day) ==
            DateTime(element.dateTime.year, element.dateTime.month,
                element.dateTime.day))
        .toList();
    dayData.sort((a, b) => (a.dateTime).compareTo(b.dateTime));
    return dayData;
  }

  List<FlSpot> getFLSpotForDate(DateTime day) {
    List<Occupancy> dayData = widget.data
        .where((element) =>
            DateTime(day.year, day.month, day.day) ==
            DateTime(element.dateTime.year, element.dateTime.month,
                element.dateTime.day))
        .toList();
    dayData.sort((a, b) => (a.dateTime).compareTo(b.dateTime));
    return dayData
        .map((e) => FlSpot(dayData.indexOf(e) as double, e.amount as double))
        .toList();
  }

  LineChartData mainData() {
    var maxYVal =
        widget.data.map((e) => e.amount).toList().reduce(max).toDouble();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 5,
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
          tooltipBgColor: Colors.grey,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots
                .map((e) => LineTooltipItem(
                    "${getDataForDate(selectedDate)[e.x.toInt()].amount}\n(${getDataForDate(selectedDate)[e.x.toInt()].percent} %)",
                    TextStyle()))
                .toList();
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
      maxX: getDataForDate(selectedDate).length.toDouble() - 1,
      minY: 0,
      maxY: maxYVal * 1.1,
      lineBarsData: [
        LineChartBarData(
          spots: getFLSpotForDate(selectedDate),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
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
      ],
    );
  }
}
