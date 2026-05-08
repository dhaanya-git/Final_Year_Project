import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServiceREST {
  final String apiKey = "AIzaSyAl_HNPnc-VAZ1DEpGGIfix9ayGplwuPfc";

  // Sign Up
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    return json.decode(response.body);
  }

  // Sign In
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    return json.decode(response.body);
  }
}
