import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticatedUser {
  final String fullName;
  final String email;
  final String username;

  const AuthenticatedUser({
    required this.fullName,
    required this.email,
    required this.username,
  });
}

class LocalAuthService {
  static const String _usersKey = 'registered_users';

  // Read registered accounts from local storage.
  static Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsers = prefs.getString(_usersKey);

    if (savedUsers == null) return [];

    final decoded = jsonDecode(savedUsers) as List;

    return decoded
        .map((user) => Map<String, dynamic>.from(user as Map))
        .toList();
  }

  // Generate a random salt for password hashing.
  static String _generateSalt() {
    final random = Random.secure();

    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    return base64UrlEncode(bytes);
  }

  // Hash the password before saving it.
  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt:$password');

    return sha256.convert(bytes).toString();
  }

  // Register a new account.
  // Returns null if successful, or an error message.
  static Future<String?> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final users = await _getUsers();

      final normalizedEmail = email.trim().toLowerCase();
      final normalizedUsername = username.trim().toLowerCase();

      final alreadyExists = users.any((user) {
        return user['email'] == normalizedEmail ||
            user['username'] == normalizedUsername;
      });

      if (alreadyExists) {
        return 'Username or email is already registered.';
      }

      final salt = _generateSalt();

      final newUser = {
        'fullName': fullName.trim(),
        'email': normalizedEmail,
        'username': normalizedUsername,
        'salt': salt,
        'passwordHash': _hashPassword(password, salt),
      };

      users.add(newUser);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_usersKey, jsonEncode(users));

      return null;
    } catch (e) {
      return 'Registration failed. Please try again.';
    }
  }

  // Verify login credentials.
  static Future<AuthenticatedUser?> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final users = await _getUsers();

      final input = identifier.trim().toLowerCase();

      for (final user in users) {
        if (user['username'] == input || user['email'] == input) {
          final salt = user['salt'] as String;

          final enteredHash = _hashPassword(password, salt);

          if (enteredHash == user['passwordHash']) {
            return AuthenticatedUser(
              fullName: user['fullName'] as String,
              email: user['email'] as String,
              username: user['username'] as String,
            );
          }

          return null;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
