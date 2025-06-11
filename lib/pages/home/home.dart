import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/pages/home/widgets/banner.dart';
import 'package:sistem_informasi/pages/home/widgets/event.dart';
import 'package:sistem_informasi/pages/home/widgets/manajement_only_admin.dart';
import 'package:sistem_informasi/pages/home/widgets/shimmer_event.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';

import 'controller/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<HomeController>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 8),
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: sizeWidth * 0.03),
                  child: TextGlobalWidget(
                    text: "Belum login",
                    fontSize: 14,
                    fontColor: primaryColor,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(right: sizeWidth * 0.03),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(sizeHeight * 0.01),
                  ),
                  child: Row(
                    children: [
                      TextGlobalWidget(text: "Login", fontSize: 14),
                      const Icon(Icons.login, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
            BannerWidget(sizeHeight: sizeHeight, sizeWidth: sizeWidth),
            ManajementOnlyAdminWidget(
              sizeHeight: sizeHeight,
              sizeWidth: sizeWidth,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: TextGlobalWidget(
                text: "Acara",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontColor: primaryColor,
              ),
            ),
            SizedBox(height: sizeHeight * 0.002),
            // Events Section
            Obx(() {
              if (controller.isLoading.value && controller.events.isEmpty) {
                // Show shimmer loading for initial load
                return Column(
                  children: List.generate(
                    3,
                    (index) => EventShimmerWidget(
                      sizeHeight: sizeHeight,
                      sizeWidth: sizeWidth,
                    ),
                  ),
                );
              }

              if (controller.hasError.value && controller.events.isEmpty) {
                // Show error state
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      TextGlobalWidget(
                        text: "Failed to load events",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontColor: Colors.red,
                      ),
                      const SizedBox(height: 8),
                      TextGlobalWidget(
                        text: controller.errorMessage.value,
                        fontSize: 14,
                        fontColor: Colors.grey,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchEvents,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              if (controller.events.isEmpty) {
                // Show empty state
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.event_busy,
                        size: 60,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      TextGlobalWidget(
                        text: "No events available",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontColor: Colors.grey,
                      ),
                    ],
                  ),
                );
              }

              // Show events list
              return Column(
                children: [
                  ...controller.events.map(
                    (event) => EventWidget(
                      sizeHeight: sizeHeight,
                      sizeWidth: sizeWidth,
                      event: event,
                    ),
                  ),

                  // Loading more indicator
                  if (controller.isLoadingMore.value)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const CircularProgressIndicator(),
                    ),

                  // End of list indicator
                  if (!controller.hasMorePages.value &&
                      controller.events.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: TextGlobalWidget(
                        text: "No more events to load",
                        fontSize: 14,
                        fontColor: Colors.grey,
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
