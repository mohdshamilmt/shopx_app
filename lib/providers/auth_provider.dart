import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? token;
  Map<String, dynamic>? user;
  bool isLoading = true;

  AuthProvider() {
    checkLogin();
  }

  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    if (token != null) {
      await fetchUserData();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("https://dummyjson.com/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        // "expiresInMins": 30,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['accessToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token!);

      await fetchUserData();
      notifyListeners();
      return true;
    } else {
      // 🔥 Add this to see exact error
      print("LOGIN FAILED RESPONSE: ${response.body}");
      return false;
    }
  }

  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/auth/me"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      user = jsonDecode(response.body);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = null;
    user = null;
    notifyListeners();
  }

  // nre add
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    if (token != null) {
      await fetchUserData();
    }
    notifyListeners();
  }
}
