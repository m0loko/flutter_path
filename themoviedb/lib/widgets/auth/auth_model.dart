import 'dart:async';

import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/main_navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final loginController = TextEditingController();
  final passsworController = TextEditingController();
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginController.text;
    final password = passsworController.text;
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();
    String? sesionId;
    try {
      sesionId = await _apiClient.auth(username: login, password: password);
    } catch (e) {
      _errorMessage = 'Неправильный логин или пароль!';
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sesionId == null) {
      _errorMessage = 'Неизвестная ошиибка';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sesionId);
    unawaited(
      Navigator.of(
        context,
      ).pushReplacementNamed(MainNavigationRouteNames.mainScreen),
    );
  }
}
