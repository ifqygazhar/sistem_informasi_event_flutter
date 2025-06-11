import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/api/api.dart';
import 'package:sistem_informasi/models/event.dart';
import 'package:sistem_informasi/pages/auth/controller/auth_controller.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/date_format.dart';
import 'package:sistem_informasi/utils/text.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Event event = Get.arguments as Event;
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
          ),
        ),
        title: TextGlobalWidget(
          text: "Event Detail",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontColor: primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            SizedBox(
              height: sizeHeight * 0.3,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl:
                    event.image ??
                    "https://images.pexels.com/photos/1324803/pexels-photo-1324803.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, size: 50),
                    ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(sizeWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  Row(
                    children: [
                      Expanded(
                        child: TextGlobalWidget(
                          text: event.title,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontColor: primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              event.status == 'active'
                                  ? Colors.green
                                  : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextGlobalWidget(
                          text: event.status.toUpperCase(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sizeHeight * 0.02),

                  // Creator Info
                  Row(
                    children: [
                      const Icon(Icons.person, color: primaryColor, size: 20),
                      SizedBox(width: sizeWidth * 0.02),
                      TextGlobalWidget(
                        text: "Created by: ${event.creator?.name ?? 'Unknown'}",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontColor: Colors.grey[700],
                      ),
                    ],
                  ),

                  SizedBox(height: sizeHeight * 0.01),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: sizeWidth * 0.02),
                      Expanded(
                        child: TextGlobalWidget(
                          text: event.location,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontColor: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sizeHeight * 0.01),

                  // Date Range
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: sizeWidth * 0.02),
                      Expanded(
                        child: TextGlobalWidget(
                          text: DateFormatter.formatDateRange(
                            event.startDate,
                            event.endDate,
                          ), // Update this line
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontColor: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizeHeight * 0.02),

                  // Participants Info
                  Container(
                    padding: EdgeInsets.all(sizeWidth * 0.04),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.group, color: primaryColor, size: 24),
                        SizedBox(width: sizeWidth * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextGlobalWidget(
                              text: "Participants",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontColor: primaryColor,
                            ),
                            TextGlobalWidget(
                              text:
                                  "${event.participantsCount}/${event.capacity ?? '∞'} registered",
                              fontSize: 14,
                              fontColor: Colors.grey[600],
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (event.hasReachedCapacity)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const TextGlobalWidget(
                              text: "FULL",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: sizeHeight * 0.02),

                  // Description
                  TextGlobalWidget(
                    text: "Description",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontColor: primaryColor,
                  ),
                  SizedBox(height: sizeHeight * 0.01),
                  TextGlobalWidget(
                    text: event.description,
                    fontSize: 16,
                    fontColor: Colors.grey[700],
                    textAlign: TextAlign.justify,
                  ),

                  SizedBox(height: sizeHeight * 0.03),

                  // Participants List (if any)
                  if (event.participants.isNotEmpty) ...[
                    TextGlobalWidget(
                      text: "Participants (${event.participants.length})",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontColor: primaryColor,
                    ),
                    SizedBox(height: sizeHeight * 0.01),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          event.participants.length > 5
                              ? 5
                              : event.participants.length,
                      itemBuilder: (context, index) {
                        final participant = event.participants[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: TextGlobalWidget(
                              text:
                                  participant.name.isNotEmpty
                                      ? participant.name[0].toUpperCase()
                                      : "?",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            ),
                          ),
                          title: TextGlobalWidget(
                            text: participant.name,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontColor: primaryColor,
                          ),
                          subtitle: TextGlobalWidget(
                            text: participant.email,
                            fontSize: 14,
                            fontColor: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                    if (event.participants.length > 5)
                      TextButton(
                        onPressed: () {
                          // Show all participants
                        },
                        child: TextGlobalWidget(
                          text: "View all participants",
                          fontSize: 14,
                          fontColor: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    SizedBox(height: sizeHeight * 0.02),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(sizeWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
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

              if (errorMessage.toLowerCase().contains('sudah terdaftar') ||
                  errorMessage.toLowerCase().contains('already registered')) {
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
            height: sizeHeight * 0.06,
            decoration: BoxDecoration(
              color: event.hasReachedCapacity ? Colors.grey : primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Obx(
                () => TextGlobalWidget(
                  text:
                      (authController.isLoggedIn.value == true)
                          ? event.hasReachedCapacity
                              ? "Full"
                              : "Register"
                          : "Login or register first",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
