import 'package:flutter/material.dart';
import 'package:aiscrape/Occupancy.dart';
import 'package:aiscrape/chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class ChartPage extends StatefulWidget {
  static String routeName = '/chartPage';

  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {

  Future<List<Occupancy>> getData() async {
    return await FirebaseFirestore.instance.collection('occupancy').get().then(
        (value) =>
            value.docs.map((doc) => Occupancy.fromJson(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Occupancy>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return OccupancyDataChart(
              data: data,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
