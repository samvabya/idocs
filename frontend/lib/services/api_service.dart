import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idocs/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = '$serverUrl/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: {'email': email, 'password': password},
      );

      var json = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200,
        'token': json['token'],
        'message': json['message'] ?? 'Login successful',
      };
    } catch (e) {
      debugPrint(e.toString());
      return {
        'success': false,
        'token': null,
        'message': "Error: $e",
      };
    }
  }

  static Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: {'email': email, 'password': password},
      );

      var json = jsonDecode(response.body);

      return {
        'success': response.statusCode == 201,
        'token': json['token'],
        'message': json['message'] ?? 'Registration successful',
      };
    } catch (e) {
      debugPrint(e.toString());
      return {
        'success': false,
        'token': null,
        'message': "Error: $e",
      };
    }
  }

  static Future<String?> verify() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) return null;

      var response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Authorization': 'Bearer $token'},
      );

      var json = jsonDecode(response.body);
      debugPrint(json['user']['email'].toString());

      if (response.statusCode == 200) {
        return json['user']['email'];
      }

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}