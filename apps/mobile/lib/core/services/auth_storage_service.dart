import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/constants/admin_claims.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Secure authentication storage service for EduLab mobile app.
/// Stores sensitive JWT tokens in encrypted hardware storage (iOS Keychain / Android EncryptedSharedPreferences)
/// and user profile metadata in SharedPreferences with automatic migration and fallback.
class AuthStorageService {
  static const String _userKey = 'user_info';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isLoggedInKey = 'is_logged_in';

  static SharedPreferences? _prefs;
  static FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Allows injection of custom or mock instances for testing.
  static void setMockStorage({
    FlutterSecureStorage? secureStorage,
    SharedPreferences? prefs,
    bool resetPrefs = false,
  }) {
    if (secureStorage != null) _secureStorage = secureStorage;
    if (prefs != null || resetPrefs) _prefs = prefs;
  }


  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
  }) async {
    // 1. Store tokens in encrypted hardware keychain/keystore
    try {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    } catch (_) {}

    final prefs = await _instance;
    // Clean up any unencrypted tokens from shared preferences if migrating
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);

    // 2. Enrich user payload with roles and claims decoded from JWT token
    final enrichedUser = Map<String, dynamic>.from(user);
    final jwtData = extractRolesAndClaimsFromJwt(accessToken);
    final jwtRoles = jwtData['roles'] ?? [];
    final jwtClaims = jwtData['claims'] ?? [];

    final existingRoles = _extractRolesFromMap(enrichedUser);
    final allRoles = <String>{...existingRoles, ...jwtRoles}.toList();
    if (allRoles.isNotEmpty) {
      enrichedUser['roles'] = allRoles;
      if (!enrichedUser.containsKey('role') || enrichedUser['role'] == null) {
        enrichedUser['role'] = allRoles.first;
      }
    }

    final existingClaims = _extractClaimsFromMap(enrichedUser);
    final allClaims = <String>{...existingClaims, ...jwtClaims}.toList();
    if (allClaims.isNotEmpty) {
      enrichedUser['claims'] = allClaims;
    }

    await prefs.setString(_userKey, json.encode(enrichedUser));
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // 1. Store tokens in encrypted hardware keychain/keystore
    try {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    } catch (_) {}

    final prefs = await _instance;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);

    // Update roles and claims from refreshed token if user is already saved
    final user = await getUser();
    if (user != null) {
      final enrichedUser = Map<String, dynamic>.from(user);
      final jwtData = extractRolesAndClaimsFromJwt(accessToken);
      final jwtRoles = jwtData['roles'] ?? [];
      final jwtClaims = jwtData['claims'] ?? [];

      final existingRoles = _extractRolesFromMap(enrichedUser);
      final allRoles = <String>{...existingRoles, ...jwtRoles}.toList();
      if (allRoles.isNotEmpty) {
        enrichedUser['roles'] = allRoles;
      }

      final existingClaims = _extractClaimsFromMap(enrichedUser);
      final allClaims = <String>{...existingClaims, ...jwtClaims}.toList();
      if (allClaims.isNotEmpty) {
        enrichedUser['claims'] = allClaims;
      }

      await prefs.setString(_userKey, json.encode(enrichedUser));
    }
  }

  static Future<String?> getAccessToken() async {
    try {
      final secureToken = await _secureStorage.read(key: _accessTokenKey);
      if (secureToken != null && secureToken.isNotEmpty) {
        return secureToken;
      }
    } catch (_) {}

    // Fallback & automatic migration from SharedPreferences
    final prefs = await _instance;
    final legacyToken = prefs.getString(_accessTokenKey);
    if (legacyToken != null && legacyToken.isNotEmpty) {
      try {
        await _secureStorage.write(key: _accessTokenKey, value: legacyToken);
        await prefs.remove(_accessTokenKey);
      } catch (_) {}
      return legacyToken;
    }
    return null;
  }

  static Future<String?> getRefreshToken() async {
    try {
      final secureToken = await _secureStorage.read(key: _refreshTokenKey);
      if (secureToken != null && secureToken.isNotEmpty) {
        return secureToken;
      }
    } catch (_) {}

    // Fallback & automatic migration from SharedPreferences
    final prefs = await _instance;
    final legacyToken = prefs.getString(_refreshTokenKey);
    if (legacyToken != null && legacyToken.isNotEmpty) {
      try {
        await _secureStorage.write(key: _refreshTokenKey, value: legacyToken);
        await prefs.remove(_refreshTokenKey);
      } catch (_) {}
      return legacyToken;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await _instance;
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      try {
        return json.decode(userStr) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _instance;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (_) {}

    final prefs = await _instance;
    await prefs.remove(_userKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<String?> getUserId() async {
    final user = await getUser();
    return user?['id']?.toString() ?? user?['userId']?.toString();
  }

  static Future<String> getUserName() async {
    final user = await getUser();
    return user?['fullName']?.toString() ?? user?['name']?.toString() ?? '';
  }

  static Future<String> getUserEmail() async {
    final user = await getUser();
    return user?['email']?.toString() ?? '';
  }

  static Future<String> getUserRole() async {
    final roles = await getUserRoles();
    if (roles.isNotEmpty) {
      return roles.first;
    }
    return 'Student';
  }

  static Future<List<String>> getUserRoles() async {
    final user = await getUser();
    if (user != null) {
      final roles = _extractRolesFromMap(user);
      if (roles.isNotEmpty) return roles;
    }

    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      final jwtData = extractRolesAndClaimsFromJwt(token);
      final roles = jwtData['roles'];
      if (roles != null && roles.isNotEmpty) return roles;
    }

    return ['Student'];
  }

  static Future<List<String>> getUserClaims() async {
    final user = await getUser();
    final claims = <String>{};
    if (user != null) {
      claims.addAll(_extractClaimsFromMap(user));
    }

    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      final jwtData = extractRolesAndClaimsFromJwt(token);
      final tokenClaims = jwtData['claims'] ?? [];
      claims.addAll(tokenClaims);
    }

    return claims.toList();
  }

  static Future<bool> isAdmin() async {
    final roles = await getUserRoles();
    final isRoleAdmin = roles.any(
      (r) => r.toLowerCase() == 'admin' || r.toLowerCase() == 'administrator',
    );
    if (isRoleAdmin) return true;

    return await hasAdminClaims();
  }

  static Future<bool> hasAdminClaims() async {
    final claims = await getUserClaims();
    final roles = await getUserRoles();
    return AdminClaims.hasAnyAdminClaim([...claims, ...roles]);
  }

  static Future<bool> isInstructor() async {
    final roles = await getUserRoles();
    return roles.any((r) => r.toLowerCase() == 'instructor');
  }

  /// Extracts roles and claims directly from the JWT payload
  static Map<String, List<String>> extractRolesAndClaimsFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return {'roles': [], 'claims': []};
      final normalized = base64Url.normalize(parts[1]);
      final payload = json.decode(utf8.decode(base64Url.decode(normalized)));
      if (payload is! Map<String, dynamic>) {
        return {'roles': [], 'claims': []};
      }

      final roles = <String>{};
      final claims = <String>{};

      for (final entry in payload.entries) {
        final key = entry.key;
        final value = entry.value;

        // Check if key represents roles
        final isRoleKey =
            key == 'role' ||
            key == 'Role' ||
            key == 'roles' ||
            key == 'Roles' ||
            key ==
                'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';

        if (isRoleKey) {
          if (value is List) {
            roles.addAll(value.map((e) => e.toString().trim()));
          } else if (value != null) {
            final vStr = value.toString().trim();
            if (vStr.contains(',')) {
              roles.addAll(vStr.split(',').map((e) => e.trim()));
            } else {
              roles.add(vStr);
            }
          }
          continue;
        }

        // Check if key itself matches AdminClaims
        if (AdminClaims.all.any((c) => c.toLowerCase() == key.toLowerCase())) {
          claims.add(key);
        }

        // Check if value (or list of values) matches claims
        if (value is List) {
          for (final item in value) {
            claims.add(item.toString().trim());
          }
        } else if (value is String && value.isNotEmpty) {
          claims.add(value.trim());
        }
      }

      return {'roles': roles.toList(), 'claims': claims.toList()};
    } catch (_) {
      return {'roles': [], 'claims': []};
    }
  }

  static List<String> _extractRolesFromMap(Map<String, dynamic> map) {
    if (map['roles'] is List) {
      return (map['roles'] as List).map((e) => e.toString().trim()).toList();
    } else if (map['Roles'] is List) {
      return (map['Roles'] as List).map((e) => e.toString().trim()).toList();
    } else if (map['role'] != null) {
      final r = map['role'].toString().trim();
      return r.contains(',') ? r.split(',').map((s) => s.trim()).toList() : [r];
    } else if (map['Role'] != null) {
      final r = map['Role'].toString().trim();
      return r.contains(',') ? r.split(',').map((s) => s.trim()).toList() : [r];
    }
    return [];
  }

  static List<String> _extractClaimsFromMap(Map<String, dynamic> map) {
    if (map['claims'] is List) {
      return (map['claims'] as List).map((e) => e.toString().trim()).toList();
    } else if (map['Claims'] is List) {
      return (map['Claims'] as List).map((e) => e.toString().trim()).toList();
    }
    return [];
  }
}
