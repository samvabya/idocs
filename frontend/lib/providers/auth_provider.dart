import 'package:flutter/material.dart';
import 'package:idocs/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String _email = '';
  bool _isDarkMode = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get email => _email;
  bool get isDarkMode => _isDarkMode;

  AuthProvider() {
    _checkAuthStatus();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> _getEmail() async {
    _email = await ApiService.verify() ?? '';
    notifyListeners();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      _isAuthenticated = token != null && token.isNotEmpty;

      if (_isAuthenticated) {
        await _getEmail();
      }
    } catch (e) {
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _isAuthenticated = false;
    notifyListeners();
  }
}
