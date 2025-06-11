import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/api/api.dart';
import 'package:sistem_informasi/app_routes.dart';
import 'package:sistem_informasi/models/event.dart';
import 'package:sistem_informasi/pages/auth/controller/auth_controller.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';

class EventWidget extends StatelessWidget {
  final double sizeHeight, sizeWidth;
  final Event event;

  const EventWidget({
    super.key,
    required this.sizeHeight,
    required this.sizeWidth,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.eventDetail, arguments: event);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(sizeHeight * 0.02),
        ),
        child: Column(
          spacing: sizeHeight * 0.006,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(sizeHeight * 0.02),
                topRight: Radius.circular(sizeHeight * 0.02),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: sizeHeight * 0.2,
                width: double.infinity,
                imageUrl:
                    event.image ??
                    "https://images.pexels.com/photos/1324803/pexels-photo-1324803.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                placeholder:
                    (context, url) => Container(
                      height: sizeHeight * 0.2,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      height: sizeHeight * 0.2,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: Row(
                children: [
                  Expanded(
                    child: TextGlobalWidget(
                      text: event.title,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.group_add_outlined, size: 15, color: Colors.white),
                  TextGlobalWidget(
                    text:
                        " ${event.participantsCount}/${event.capacity ?? '∞'}",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 16),
                  SizedBox(width: sizeWidth * 0.01),
                  TextGlobalWidget(
                    text: event.creator?.name ?? "Unknown",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(width: sizeWidth * 0.01),
                  const Icon(Icons.location_on, color: Colors.white, size: 16),
                  SizedBox(width: sizeWidth * 0.01),
                  TextGlobalWidget(
                    text: event.location,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: TextGlobalWidget(
                text: event.description,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textOverflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: GestureDetector(
                onTap: () async {
                  if (!authController.isLoggedIn.value) {
                    Get.snackbar(
                      "Login Required",
                      "Please login first to register for events",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                      overlayBlur: 0,
                    );
                    return;
                  }

                  if (event.hasReachedCapacity) {
                    Get.snackbar(
                      "Registration Closed",
                      "This event has reached its capacity.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      overlayBlur: 0,
                    );
                    return;
                  }

                  try {
                    // Show loading
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    await ApiService.registerForEvent(event.id);

                    // Close loading dialog
                    Get.back();

                    // Show success message
                    Get.snackbar(
                      "Registration Successful",
                      "You have successfully registered for the event.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      overlayBlur: 0,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                    );
                  } catch (e) {
                    if (Get.isDialogOpen == true) {
                      Get.back();
                    }

                    // Extract clean error message
                    String errorMessage = e.toString();
                    if (errorMessage.contains('Exception: ')) {
                      errorMessage = errorMessage.replaceAll('Exception: ', '');
                    }
                    if (errorMessage.contains('Event registration error: ')) {
                      errorMessage = errorMessage.replaceAll(
                        'Event registration error: ',
                        '',
                      );
                    }
                    if (errorMessage.contains('Exception: ')) {
                      errorMessage = errorMessage.replaceAll('Exception: ', '');
                    }

                    // Show appropriate error message
                    Color backgroundColor = Colors.red;
                    IconData iconData = Icons.error;

                    if (errorMessage.toLowerCase().contains(
                          'sudah terdaftar',
                        ) ||
                        errorMessage.toLowerCase().contains(
                          'already registered',
                        )) {
                      backgroundColor = Colors.orange;
                      iconData = Icons.info;
                    } else if (errorMessage.toLowerCase().contains('network') ||
                        errorMessage.toLowerCase().contains('connection')) {
                      backgroundColor = Colors.blue;
                      iconData = Icons.wifi_off;
                    }

                    Get.snackbar(
                      "Registration Failed",
                      errorMessage,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: backgroundColor,
                      colorText: Colors.white,
                      overlayBlur: 0,
                      icon: Icon(iconData, color: Colors.white),
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
                child: Container(
                  height: sizeHeight * 0.04,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        event.hasReachedCapacity ? Colors.grey : Colors.white,
                    borderRadius: BorderRadius.circular(sizeHeight * 0.008),
                  ),
                  child: Obx(
                    () => TextGlobalWidget(
                      text:
                          (authController.isLoggedIn.value == true)
                              ? event.hasReachedCapacity
                                  ? "Full"
                                  : "Register"
                              : "Login or register first",
                      fontSize: 14,
                      fontColor:
                          event.hasReachedCapacity
                              ? Colors.white
                              : primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
