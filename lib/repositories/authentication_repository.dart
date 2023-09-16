import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:tomato_schedule/configs/config.dart';
import 'package:tomato_schedule/model/user_model.dart';
import 'package:http/http.dart' as http;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository();

  final _controller = StreamController<AuthenticationStatus>();
  final storage = const FlutterSecureStorage();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.authenticated;
    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  Future<User> logIn({
    required String username,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      const apiPath = '/user/login';
      final response = await http.post(Uri.parse(urlEndPoint + apiPath),
          body: {"username": username, "password": password});

      if (response.statusCode == 200) {
        final user = userFromJson(response.body);

        await _saveUserData(user);
        _controller.add(AuthenticationStatus.authenticated);
        return user;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<User?> tryAutoLogIn() async {
    try {
      return _readUserData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> logOut({
    required User user,
  }) async {
    try {
      await _clearUserData();
      _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _saveUserData(User user) async {
    await storage.write(key: userKey, value: jsonEncode(user.toJson()));
  }

  Future<User?> _readUserData() async {
    final jsonString = await storage.read(key: userKey);
    if (jsonString != null) {
      return userFromJson(jsonString);
    }
    return null;
  }

  Future<void> _clearUserData() async {
    await storage.delete(key: userKey);
  }
}
