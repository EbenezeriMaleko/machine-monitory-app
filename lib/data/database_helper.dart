import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseHelper._internal();

  Future<void> insertData(String type, double value) async {
    await _firestore.collection(type).add({
      'value': value,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchData(String type) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(type)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      var timestamp = doc['timestamp'];
      return {
        'id': doc.id,
        'value': doc['value'],
        'timestamp': timestamp != null
            ? (doc['timestamp'] as Timestamp).toDate()
            : DateTime.now(),
      };
    }).toList();
  }
}
