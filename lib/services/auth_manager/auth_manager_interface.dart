import 'package:flutter/material.dart';

import 'auth_manager_stub.dart'
if(dart.library.js) 'auth_manager_web.dart';

abstract class AuthManager extends ChangeNotifier{
  static AuthManager? _instance;

  static AuthManager? get instance {
    _instance ??= getManager();
    return _instance;
  }

  Future<String?> login({BuildContext? context});
  Future<String?> getActiveAccount();
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getAccessToken();

}