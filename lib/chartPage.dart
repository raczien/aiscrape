import 'package:flutter/material.dart';

import 'calendar.dart';
import 'chart.dart';

class ChartPage extends StatefulWidget {
  static String routeName = '/chartPage';

  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  DateTime pickedDate = DateTime.now();

  DateTime getPickedDate() => pickedDate;

  setNewPickedDate(DateTime newDateTime) {
    setState(() {
      pickedDate = newDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 1000
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Calendar(
                  getDate: getPickedDate,
                  setDate: setNewPickedDate,
                ),
                OccupancyChart(
                  getDate: getPickedDate,
                  setDate: setNewPickedDate,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
