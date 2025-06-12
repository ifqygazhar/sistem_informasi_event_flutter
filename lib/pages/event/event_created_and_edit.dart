import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/utils/text.dart';
import 'package:sistem_informasi/pages/event/controller/event_form_controller.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:intl/intl.dart';

class EventCreatedAndEditWidget extends StatelessWidget {
  const EventCreatedAndEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventFormController>();
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(
          () => TextGlobalWidget(
            text: controller.isEditMode.value ? "Edit Event" : "Create Event",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontColor: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sizeWidth * 0.05),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              _buildSectionTitle("Event Title"),
              SizedBox(height: sizeHeight * 0.01),
              TextFormField(
                controller: controller.titleController,
                decoration: _buildInputDecoration(
                  hintText: "Enter event title",
                  prefixIcon: Icons.event,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event title';
                  }
                  return null;
                },
              ),
              SizedBox(height: sizeHeight * 0.02),

              // Description Field
              _buildSectionTitle("Description"),
              SizedBox(height: sizeHeight * 0.01),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 4,
                decoration: _buildInputDecoration(
                  hintText: "Enter event description",
                  prefixIcon: Icons.description,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
              ),
              SizedBox(height: sizeHeight * 0.02),

              // Location Field
              _buildSectionTitle("Location"),
              SizedBox(height: sizeHeight * 0.01),
              TextFormField(
                controller: controller.locationController,
                decoration: _buildInputDecoration(
                  hintText: "Enter event location",
                  prefixIcon: Icons.location_on,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event location';
                  }
                  return null;
                },
              ),
              SizedBox(height: sizeHeight * 0.02),

              // Date and Time Section
              _buildSectionTitle("Date & Time"),
              SizedBox(height: sizeHeight * 0.01),

              // Start Date and Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextGlobalWidget(
                          text: "Start Date",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => GestureDetector(
                            onTap: controller.selectStartDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  TextGlobalWidget(
                                    text:
                                        controller.startDate.value != null
                                            ? DateFormat('dd MMM yyyy').format(
                                              controller.startDate.value!,
                                            )
                                            : "Select date",
                                    fontSize: 14,
                                    fontColor:
                                        controller.startDate.value != null
                                            ? Colors.black
                                            : Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextGlobalWidget(
                          text: "Start Time",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => GestureDetector(
                            onTap: controller.selectStartTime,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  TextGlobalWidget(
                                    text:
                                        controller.startTime.value != null
                                            ? controller.startTime.value!
                                                .format(context)
                                            : "Select time",
                                    fontSize: 14,
                                    fontColor:
                                        controller.startTime.value != null
                                            ? Colors.black
                                            : Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizeHeight * 0.015),

              // End Date and Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextGlobalWidget(
                          text: "End Date",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => GestureDetector(
                            onTap: controller.selectEndDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  TextGlobalWidget(
                                    text:
                                        controller.endDate.value != null
                                            ? DateFormat(
                                              'dd MMM yyyy',
                                            ).format(controller.endDate.value!)
                                            : "Select date",
                                    fontSize: 14,
                                    fontColor:
                                        controller.endDate.value != null
                                            ? Colors.black
                                            : Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextGlobalWidget(
                          text: "End Time",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => GestureDetector(
                            onTap: controller.selectEndTime,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  TextGlobalWidget(
                                    text:
                                        controller.endTime.value != null
                                            ? controller.endTime.value!.format(
                                              context,
                                            )
                                            : "Select time",
                                    fontSize: 14,
                                    fontColor:
                                        controller.endTime.value != null
                                            ? Colors.black
                                            : Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizeHeight * 0.02),

              // Capacity Field
              _buildSectionTitle("Maximum Participants (Optional)"),
              SizedBox(height: sizeHeight * 0.01),
              TextFormField(
                controller: controller.capacityController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration(
                  hintText:
                      "Enter maximum participants (leave empty for unlimited)",
                  prefixIcon: Icons.group,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final capacity = int.tryParse(value);
                    if (capacity == null || capacity <= 0) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: sizeHeight * 0.02),

              // Image Section
              _buildSectionTitle("Event Image"),
              SizedBox(height: sizeHeight * 0.01),

              // Image Preview
              Obx(() {
                if (controller.selectedImage.value != null) {
                  return _buildImagePreview(
                    controller.selectedImage.value!,
                    true,
                  );
                } else if (controller.imageController.text.isNotEmpty) {
                  return _buildImagePreview(
                    null,
                    false,
                    controller.imageController.text,
                  );
                } else {
                  return _buildImagePlaceholder();
                }
              }),

              SizedBox(height: sizeHeight * 0.01),

              // Image Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.showImageSourceDialog,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add Image'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    if (controller.selectedImage.value != null ||
                        controller.imageController.text.isNotEmpty) {
                      return Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.removeImage,
                          icon: const Icon(Icons.delete),
                          label: const Text('Remove'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
              SizedBox(height: sizeHeight * 0.02),

              // Status Field - FIXED
              _buildSectionTitle("Status"),
              SizedBox(height: sizeHeight * 0.01),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedStatus.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.publish,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    dropdownColor: Colors.white,
                    items:
                        controller.statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: TextGlobalWidget(
                              text: status.toUpperCase(),
                              fontSize: 14,
                              fontColor: Colors.black,
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedStatus.value = newValue;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: sizeHeight * 0.04),

              // Save Button
              Obx(
                () => GestureDetector(
                  onTap:
                      controller.isLoading.value ? null : controller.saveEvent,
                  child: Container(
                    width: double.infinity,
                    height: sizeHeight * 0.06,
                    decoration: BoxDecoration(
                      color:
                          controller.isLoading.value
                              ? Colors.grey
                              : primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child:
                          controller.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : TextGlobalWidget(
                                text:
                                    controller.isEditMode.value
                                        ? "Update Event"
                                        : "Create Event",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.white,
                              ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: sizeHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(File? imageFile, bool isFile, [String? imageUrl]) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:
            isFile
                ? Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 50),
                    );
                  },
                )
                : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 50),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 8),
          TextGlobalWidget(
            text: "No image selected",
            fontSize: 14,
            fontColor: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return TextGlobalWidget(
      text: title,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontColor: primaryColor,
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
