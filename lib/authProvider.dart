import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/auth_service.dart';
import 'models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;

  // Khởi tạo trạng thái đăng nhập khi mở app
 // Trong class AuthProvider, hàm initAuth()
  Future<void> initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (_isLoggedIn) {
      _user = User(
        id: prefs.getInt('userId'),
        username: prefs.getString('username') ?? '', // Load username mới từ đây
        email: prefs.getString('email') ?? '',
        password: '',
        phone: prefs.getString('phone') ?? '',
        address: prefs.getString('address') ?? '',
      );
    }
    notifyListeners();
  }
  Future<bool> login(String username, String password) async {
    final userResult = await _authService.login(username, password);
    
    if (userResult != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', userResult.id!);
      await prefs.setString('username', userResult.username);
      await prefs.setString('email', userResult.email);

      _isLoggedIn = true;
      _user = userResult;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}
