import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/app_routes.dart';
import 'package:sistem_informasi/pages/event/controller/event_controller.dart';
import 'package:sistem_informasi/pages/event/widget/event_management_item.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';

class EventManagementPage extends StatelessWidget {
  const EventManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventManagementController>();
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
          ),
          onPressed: () => Get.back(result: true),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextGlobalWidget(
          text: "Event Management",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontColor: primaryColor,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshEvents,
        child: Obx(() {
          if (controller.isLoading.value && controller.myEvents.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.myEvents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                  SizedBox(height: sizeHeight * 0.02),
                  TextGlobalWidget(
                    text: "No events found",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.grey[600],
                  ),
                  SizedBox(height: sizeHeight * 0.01),
                  TextGlobalWidget(
                    text: "Create your first event to get started",
                    fontSize: 14,
                    fontColor: Colors.grey[500],
                  ),
                  SizedBox(height: sizeHeight * 0.03),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Get.toNamed(AppRoutes.createEvent);
                      // Jika ada result dan berhasil, refresh akan otomatis terjadi
                      // karena sudah di-handle di EventFormController
                      if (result == true) {
                        // Optional: tambahan aksi jika diperlukan
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Event'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.myEvents.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.myEvents.length) {
                // Load more indicator
                if (controller.pagination.value?.hasMorePages == true) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final currentPage =
                              controller.pagination.value?.currentPage ?? 1;
                          controller.loadMyEvents(page: currentPage + 1);
                        },
                        child: const Text('Load More'),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final event = controller.myEvents[index];
              return EventManagementItem(
                event: event,
                sizeHeight: sizeHeight,
                sizeWidth: sizeWidth,
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed(AppRoutes.createEvent);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
