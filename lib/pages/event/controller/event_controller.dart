import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/api/api.dart';
import 'package:sistem_informasi/models/event.dart';

class EventManagementController extends GetxController {
  final RxList<Event> myEvents = <Event>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final Rx<PaginationInfo?> pagination = Rx<PaginationInfo?>(null);

  @override
  void onInit() {
    super.onInit();
    loadMyEvents();
  }

  Future<void> loadMyEvents({int page = 1, bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        isRefreshing.value = true;
      } else {
        isLoading.value = true;
      }

      final response = await ApiService.getMyEvents(page: page);
      final List<Event> events = response['events'];
      final PaginationInfo paginationInfo = response['pagination'];

      if (page == 1) {
        myEvents.assignAll(events);
      } else {
        myEvents.addAll(events);
      }

      pagination.value = paginationInfo;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refreshEvents() async {
    await loadMyEvents(page: 1, isRefresh: true);
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Event'),
          content: const Text(
            'Are you sure you want to delete this event? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await ApiService.deleteEvent(eventId);

      // Close loading
      Get.back();

      // Remove from list
      myEvents.removeWhere((event) => event.id == eventId);

      Get.snackbar(
        'Success',
        'Event deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
