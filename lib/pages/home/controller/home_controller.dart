import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/api/api.dart';
import 'package:sistem_informasi/models/event.dart';

class HomeController extends GetxController {
  // Observable variables
  final events = <Event>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Pagination
  final currentPage = 1.obs;
  final hasMorePages = true.obs;

  // ScrollController for infinite loading
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    fetchEvents();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && hasMorePages.value) {
        loadMoreEvents();
      }
    }
  }

  Future<void> fetchEvents({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasMorePages.value = true;
        events.clear();
      }

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await ApiService.getPublishedEvents(
        page: currentPage.value,
      );
      final List<Event> newEvents = result['events'];
      final PaginationInfo pagination = result['pagination'];

      if (refresh) {
        events.value = newEvents;
      } else {
        events.addAll(newEvents);
      }

      hasMorePages.value = pagination.hasMorePages;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load events: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreEvents() async {
    if (isLoadingMore.value || !hasMorePages.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final result = await ApiService.getPublishedEvents(
        page: currentPage.value,
      );
      final List<Event> newEvents = result['events'];
      final PaginationInfo pagination = result['pagination'];

      events.addAll(newEvents);
      hasMorePages.value = pagination.hasMorePages;
    } catch (e) {
      currentPage.value--; // Rollback page increment
      Get.snackbar(
        'Error',
        'Failed to load more events: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshEvents() async {
    await fetchEvents(refresh: true);
  }
}
