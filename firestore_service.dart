import 'package:flutter/foundation.dart';
import 'firestore_service_rest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final restService = FirestoreServiceREST();

  Future<void> addDocument(
      String collection, Map<String, dynamic> data, String? token) async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      await restService.addDocument(collection, data, token ?? '');
    } else {
      await FirebaseFirestore.instance.collection(collection).add(data);
    }
  }

  Future<List<Map<String, dynamic>>> getDocuments(
      String collection, String? token) async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      final result = await restService.getDocuments(collection, token ?? '');
      return (result['documents'] ?? []).map<Map<String, dynamic>>((doc) {
        final fields = doc['fields'] as Map<String, dynamic>;
        return fields.map((key, value) => MapEntry(key, value['stringValue']));
      }).toList();
    } else {
      final snapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    }
  }
}
