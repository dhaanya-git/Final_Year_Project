import 'dart:convert';
import 'package:http/http.dart' as http;

class FirestoreServiceREST {
  final String projectId = "smartlease-aaf09";
  final String baseUrl;

  FirestoreServiceREST()
      : baseUrl =
            "https://firestore.googleapis.com/v1/projects/YOUR_PROJECT_ID/databases/(default)/documents";

  // Add a document
  Future<Map<String, dynamic>> addDocument(
      String collection, Map<String, dynamic> data, String idToken) async {
    final url = Uri.parse('$baseUrl/$collection');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        "fields": data.map(
            (key, value) => MapEntry(key, {"stringValue": value.toString()}))
      }),
    );
    return json.decode(response.body);
  }

  // Get documents
  Future<Map<String, dynamic>> getDocuments(
      String collection, String idToken) async {
    final url = Uri.parse('$baseUrl/$collection');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    return json.decode(response.body);
  }
}
