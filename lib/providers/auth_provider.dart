import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthAPI authAPI;
  final StorageService _storage = StorageService();
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String _token = '';
  String? _error;
  User? _currentUser;

  AuthProvider(this.authAPI) {
    loadToken();
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get token => _token;
  String? get error => _error;
  User? get currentUser => _currentUser;
  bool get hasError => _error != null;

  void updateFrom(AuthProvider? previous) {
    if (previous != null) {
      _isAuthenticated = previous._isAuthenticated;
      _token = previous._token;
      _isLoading = previous._isLoading;
      _error = previous._error;
      _currentUser = previous._currentUser;
      notifyListeners();
    }
  }

  Future<void> login(User user, BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await authAPI.login(user);
      if (response.statusCode == 200 && response.data['token'] != null) {
        _token = response.data['token'];
        _isAuthenticated = true;
        _currentUser = user;
        await _storage.saveToken(_token);
        _error = null;

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/chat');
        }
      } else {
        _error = response.data['message'] ?? "Error en el inicio de sesión";
        _isAuthenticated = false;
      }
    } catch (e) {
      _error = "Error de conexión: ${e.toString()}";
      _isAuthenticated = false;
      print("Error en login: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(User user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await authAPI.signup(user);
      if (response.statusCode == 200) {
        _error = null;
        return true;
      } else {
        _error = response.data['message'] ?? "Error en el registro";
        return false;
      }
    } catch (e) {
      _error = "Error en el registro: ${e.toString()}";
      print("Error en el registro: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _storage.removeToken();
      _token = '';
      _isAuthenticated = false;
      _currentUser = null;
      _error = null;

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _error = "Error al cerrar sesión: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadToken() async {
    try {
      _isLoading = true;
      notifyListeners();

      _token = await _storage.getToken() ?? '';
      _isAuthenticated = _token.isNotEmpty;
      
      if (_isAuthenticated) {
        // Aquí podrías cargar los datos del usuario si es necesario
        // await loadUserData();
      }

    } catch (e) {
      _error = "Error al cargar token: ${e.toString()}";
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Método para obtener el estado actual del provider
  Map<String, dynamic> getState() {
    return {
      'isAuthenticated': _isAuthenticated,
      'isLoading': _isLoading,
      'hasToken': _token.isNotEmpty,
      'hasError': hasError,
      'error': _error,
      'currentUser': _currentUser?.username,
    };
  }
}