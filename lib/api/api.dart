import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_informasi/models/event.dart';
import 'package:sistem_informasi/models/user.dart' as UserModel;
import 'package:sistem_informasi/service/storage.dart';
import 'dart:convert';

import 'package:sistem_informasi/utils/endpoint.dart';

class ApiService {
  // Get headers with auth token
  static Future<Map<String, String>> getHeaders({
    bool requireAuth = false,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Register
  static Future<UserModel.AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: await getHeaders(),
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.AuthResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      debugPrint('Error registering: $e');
      throw Exception('Registration error: $e');
    }
  }

  // Login
  static Future<UserModel.AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: await getHeaders(),
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.AuthResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      debugPrint('Error logging in: $e');
      throw Exception('Login error: $e');
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: await getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        await StorageService.clearAuthData();
      } else {
        throw Exception('Logout failed');
      }
    } catch (e) {
      debugPrint('Error logging out: $e');
      // Clear local data even if API call fails
      await StorageService.clearAuthData();
      throw Exception('Logout error: $e');
    }
  }

  // Get user profile
  static Future<User> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: await getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data['data']);
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      debugPrint('Error getting profile: $e');
      throw Exception('Profile error: $e');
    }
  }

  // Get Published Events with Pagination (Public)
  static Future<Map<String, dynamic>> getPublishedEvents({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/published?page=$page'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> eventsData = data['data'] ?? [];
        final Map<String, dynamic> paginationData = data['pagination'] ?? {};

        return {
          'events': eventsData.map((json) => Event.fromJson(json)).toList(),
          'pagination': PaginationInfo.fromJson(paginationData),
        };
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }

  // Get Specific Event (Public)
  static Future<Event> getEventById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/$id'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Event.fromJson(data['data']);
      } else {
        throw Exception('Failed to load event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }

  // Register for event
  static Future<void> registerForEvent(int eventId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events/$eventId/register'),
        headers: await getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        return;
      } else {
        // Parse error response
        final errorData = json.decode(response.body);
        String errorMessage = 'Registration failed';

        if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        } else if (errorData['error'] != null) {
          errorMessage = errorData['error'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error registering for event: $e');

      // Check if it's already our custom exception
      if (e.toString().contains('Exception: ')) {
        rethrow; // Keep the original message
      } else {
        throw Exception('Network error: Please check your connection');
      }
    }
  }
}
