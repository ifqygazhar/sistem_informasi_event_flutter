import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_informasi/models/event.dart';
import 'dart:convert';
import '../utils/endpoint.dart';

class ApiService {
  // Get Published Events with Pagination (Public)
  static Future<Map<String, dynamic>> getPublishedEvents({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$event/published?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
        Uri.parse('$event/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
}
