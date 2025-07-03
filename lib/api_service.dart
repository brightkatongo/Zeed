import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for your API
  final String baseUrl;
  
  // Constructor
  ApiService({required this.baseUrl});
  
  // Store the JWT token
  String? _token;
  
  // User data
  Map<String, dynamic>? _userData;
  
  // Getter for user data
  Map<String, dynamic>? get userData => _userData;
  
  // Check if user is logged in
  bool get isLoggedIn => _token != null;
  
  // Initialize the API service
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    
    if (_token != null) {
      // Validate token and get user data
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/api/mobile/auth?token=$_token'),
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success']) {
            _userData = data['user'];
          } else {
            // Token is invalid, clear it
            _token = null;
            await prefs.remove('auth_token');
          }
        }
      } catch (e) {
        print('Error initializing API service: $e');
        _token = null;
        await prefs.remove('auth_token');
      }
    }
  }
  
  // Login method
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/mobile/auth'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success']) {
        _token = data['token'];
        _userData = data['user'];
        
        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        
        return {'success': true, 'user': _userData};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }
  
  // Logout method
  Future<void> logout() async {
    _token = null;
    _userData = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  // Generic GET request method
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('GET request error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }
  
  // Generic POST request method
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('POST request error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }
  
  // Generic PUT request method
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('PUT request error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }
  
  // Generic DELETE request method
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('DELETE request error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }
  
  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = json.decode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': data};
    } else if (response.statusCode == 401) {
      // Token might be expired, clear it
      _token = null;
      _userData = null;
      
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove('auth_token');
      });
      
      return {
        'success': false,
        'message': data['message'] ?? 'Authentication required',
        'unauthorized': true,
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Request failed',
        'statusCode': response.statusCode,
      };
    }
  }
}
