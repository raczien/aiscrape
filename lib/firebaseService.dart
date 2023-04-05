import 'package:aiscrape/Occupancy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{

  static Future<List<Occupancy>> getDataForToday() async {
    DateTime currentDate = DateTime.now();
    var collection = FirebaseFirestore.instance.collection('occupancy');
    var data = await collection.where(
          'date', isEqualTo: "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}"
    ).get().then(
            (value) =>
            value.docs.map((doc) => Occupancy.fromJson(doc.data())).toList());
    data.sort((a, b) => (a.dateTime).compareTo(b.dateTime));
    return data;
  }

  static Future<List<Occupancy>> getDataForDate(DateTime date) async {
    var collection = FirebaseFirestore.instance.collection('occupancy');
    var data = await collection.where(
        'date', isEqualTo: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
    ).get().then(
            (value) =>
            value.docs.map((doc) => Occupancy.fromJson(doc.data())).toList());
    data.sort((a, b) => (a.dateTime).compareTo(b.dateTime));
    return data;
  }

  static Future<List<Occupancy>> getAllData() async {
    return await FirebaseFirestore.instance.collection('occupancy').get().then(
            (value) =>
            value.docs.map((doc) => Occupancy.fromJson(doc.data())).toList());
  }
}