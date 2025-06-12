import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_informasi/models/event.dart';
import 'package:sistem_informasi/models/user_management.dart' as UserManagement;
import 'package:sistem_informasi/models/user.dart' as UserModel;
import 'package:sistem_informasi/service/storage.dart';
import 'dart:convert';

import 'package:sistem_informasi/utils/endpoint.dart';

class ApiService {
  // Get headers with auth token
  static Future<Map<String, String>> getHeaders({
    bool requireAuth = false,
    bool isMultipart = false,
  }) async {
    Map<String, String> headers = {};

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    headers['Accept'] = 'application/json';

    if (requireAuth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static void _handleError(http.Response response) {
    final Map<String, dynamic> errorData = json.decode(response.body);

    if (errorData.containsKey('errors')) {
      // Validation errors
      final Map<String, dynamic> errors = errorData['errors'];
      final List<String> errorMessages = [];

      errors.forEach((field, messages) {
        if (messages is List) {
          errorMessages.addAll(messages.cast<String>());
        }
      });

      throw Exception(errorMessages.join(', '));
    } else if (errorData.containsKey('message')) {
      throw Exception(errorData['message']);
    } else {
      throw Exception('An error occurred: ${response.statusCode}');
    }
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

  // Get My Events (Protected)
  static Future<Map<String, dynamic>> getMyEvents({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/my-events?page=$page'),
        headers: await getHeaders(requireAuth: true),
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
        throw Exception('Failed to load my events: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching my events: $e');
      throw Exception('Error fetching my events: $e');
    }
  }

  static Future<Event> createEvent({
    required String title,
    required String description,
    required String startDate,
    required String endDate,
    required String location,
    String? maxParticipants,
    File? image,
    String status = 'published',
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/events'));

      // Add headers
      request.headers.addAll(
        await getHeaders(requireAuth: true, isMultipart: true),
      );

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['start_date'] = startDate;
      request.fields['end_date'] = endDate;
      request.fields['location'] = location;
      request.fields['status'] = status;

      // Fix: Convert int to string for multipart request
      if (maxParticipants != null) {
        request.fields['capacity'] = maxParticipants;
      }

      // Add image file if provided
      if (image != null && await image.exists()) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          image.path,
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Event.fromJson(data['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create event');
      }
    } catch (e) {
      debugPrint('Error creating event: $e');
      throw Exception('Create event error: $e');
    }
  }

  // Update Event (Protected) - Updated with multipart support
  static Future<Event> updateEvent({
    required int eventId,
    required String title,
    required String description,
    required String startDate,
    required String endDate,
    required String location,
    String? maxParticipants,
    File? image,
    String status = 'published',
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST', // Menggunakan POST dengan _method field untuk PUT
        Uri.parse('$baseUrl/events/$eventId'),
      );

      // Add headers
      request.headers.addAll(
        await getHeaders(requireAuth: true, isMultipart: true),
      );

      // Add method override for PUT
      request.fields['_method'] = 'PUT';

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['start_date'] = startDate;
      request.fields['end_date'] = endDate;
      request.fields['location'] = location;
      request.fields['status'] = status;

      // Fix: Convert int to string for multipart request
      if (maxParticipants != null) {
        request.fields['capacity'] = maxParticipants;
      }

      // Add image file if provided
      if (image != null && await image.exists()) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          image.path,
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Event.fromJson(data['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update event');
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
      throw Exception('Update event error: $e');
    }
  }

  // Delete Event (Protected)
  static Future<void> deleteEvent(int eventId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: await getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete event');
      }
    } catch (e) {
      debugPrint('Error deleting event: $e');
      throw Exception('Delete event error: $e');
    }
  }

  /// Get all users (Admin only)
  static Future<Map<String, dynamic>> getUsers({int page = 1}) async {
    try {
      final headers = await getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('$baseUrl/users?page=$page'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Debug print untuk melihat struktur response
        if (kDebugMode) {
          print('Users response structure: ${responseData.keys}');
          print('Data structure: ${responseData['data'].runtimeType}');
          if (responseData['data'] is Map) {
            print('Data keys: ${responseData['data'].keys}');
          }
        }

        // Berdasarkan sample response, data users ada di data.data
        final Map<String, dynamic> paginationData = responseData['data'];
        final List<dynamic> usersData = paginationData['data'] ?? [];

        // Parse users
        final List<UserManagement.User> users =
            usersData
                .map(
                  (userJson) => UserManagement.User.fromJson(
                    userJson as Map<String, dynamic>,
                  ),
                )
                .toList();

        // Parse pagination info - gunakan data pagination dari response
        final UserManagement.PaginationInfo pagination = UserManagement
            .PaginationInfo.fromJson(paginationData);

        return {'users': users, 'pagination': pagination};
      } else {
        _handleError(response);
        return {'users': <UserManagement.User>[], 'pagination': null};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting users: $e');
      }
      rethrow;
    }
  }

  /// Get specific user (Admin only)
  static Future<UserManagement.User> getUser(int userId) async {
    try {
      final headers = await getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserManagement.User.fromJson(data['data']);
      } else {
        _handleError(response);
        throw Exception('Failed to get user');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
      rethrow;
    }
  }

  /// Create new user (Admin only)
  static Future<UserManagement.User> createUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      final headers = await getHeaders(requireAuth: true);
      final body = json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserManagement.User.fromJson(data['data']);
      } else {
        _handleError(response);
        throw Exception('Failed to create user');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user: $e');
      }
      rethrow;
    }
  }

  /// Update user (Admin only)
  static Future<UserManagement.User> updateUser({
    required int userId,
    required String name,
    required String email,
    required String role,
    String? password,
    String? passwordConfirmation,
  }) async {
    try {
      final headers = await getHeaders(requireAuth: true);
      final Map<String, dynamic> bodyData = {
        'name': name,
        'email': email,
        'role': role,
      };

      // Add password fields if provided
      if (password != null && password.isNotEmpty) {
        bodyData['password'] = password;
        bodyData['password_confirmation'] = passwordConfirmation ?? password;
      }

      final body = json.encode(bodyData);

      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserManagement.User.fromJson(data['data']);
      } else {
        _handleError(response);
        throw Exception('Failed to update user');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
      rethrow;
    }
  }

  /// Delete user (Admin only)
  static Future<void> deleteUser(int userId) async {
    try {
      final headers = await getHeaders(requireAuth: true);
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return;
      } else {
        _handleError(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      rethrow;
    }
  }
}
