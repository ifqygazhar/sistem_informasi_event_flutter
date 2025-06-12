import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sistem_informasi/api/api.dart';
import 'package:sistem_informasi/models/event.dart';
import 'package:sistem_informasi/pages/event/controller/event_controller.dart';

class EventFormController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);

  final RxString selectedStatus = 'published'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  final Rx<Event?> editingEvent = Rx<Event?>(null);

  // Image picker variables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString imageSource = 'url'.obs; // 'url' or 'file'
  final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> statusOptions = ['published', 'draft'];

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode
    final Event? event = Get.arguments as Event?;
    if (event != null) {
      isEditMode.value = true;
      editingEvent.value = event;
      _populateFields(event);
    }
  }

  void _populateFields(Event event) {
    titleController.text = event.title;
    descriptionController.text = event.description;
    locationController.text = event.location;
    capacityController.text = event.capacity?.toString() ?? '';
    imageController.text = event.image ?? '';
    selectedStatus.value = event.status;

    try {
      // Parse start date and time
      final startDateTime = DateTime.parse(event.startDate);
      startDate.value = startDateTime;
      startTime.value = TimeOfDay.fromDateTime(startDateTime);

      // Parse end date and time
      final endDateTime = DateTime.parse(event.endDate);
      endDate.value = endDateTime;
      endTime.value = TimeOfDay.fromDateTime(endDateTime);
    } catch (e) {
      debugPrint('Error parsing dates: $e');
    }
  }

  // ...existing image picker methods...

  Future<void> pickImageFromGallery() async {
    try {
      // Untuk Android 13+ dan iOS, permission handling berbeda
      PermissionStatus status;

      if (Platform.isAndroid) {
        // Untuk Android 13+ (API 33+), gunakan photos permission
        // Untuk Android dibawahnya, gunakan storage permission
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }
      } else {
        // Untuk iOS
        status = await Permission.photos.request();
      }

      // Check permission status
      if (status.isDenied) {
        _showPermissionDialog(
          'Gallery Access Required',
          'Please allow photo access to select images from gallery',
        );
        return;
      }

      if (status.isPermanentlyDenied) {
        _showPermissionDialog(
          'Permission Permanently Denied',
          'Please go to app settings and enable photo access manually',
        );
        return;
      }

      // Proceed with image picking
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        imageSource.value = 'file';
        imageController.clear();

        Get.snackbar(
          'Success',
          'Image selected successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      Get.snackbar(
        'Error',
        'Failed to select image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      // Check camera permission
      final status = await Permission.camera.request();

      if (status.isDenied) {
        _showPermissionDialog(
          'Camera Access Required',
          'Please allow camera access to take photos',
        );
        return;
      }

      if (status.isPermanentlyDenied) {
        _showPermissionDialog(
          'Permission Permanently Denied',
          'Please go to app settings and enable camera access manually',
        );
        return;
      }

      // Proceed with camera
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        imageSource.value = 'file';
        imageController.clear();

        Get.snackbar(
          'Success',
          'Photo taken successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Helper method untuk permission dialog
  void _showPermissionDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings(); // Membuka settings app
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeImage() {
    selectedImage.value = null;
    imageController.clear();
    imageSource.value = 'url';
  }

  // ...existing date/time methods...

  Future<void> selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      startDate.value = picked;
    }
  }

  Future<void> selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: startTime.value ?? TimeOfDay.now(),
    );

    if (picked != null) {
      startTime.value = picked;
    }
  }

  Future<void> selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: endDate.value ?? startDate.value ?? DateTime.now(),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      endDate.value = picked;
    }
  }

  Future<void> selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: endTime.value ?? TimeOfDay.now(),
    );

    if (picked != null) {
      endTime.value = picked;
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return combined.toIso8601String();
  }

  bool _validateDates() {
    if (startDate.value == null || startTime.value == null) {
      Get.snackbar('Error', 'Please select start date and time');
      return false;
    }

    if (endDate.value == null || endTime.value == null) {
      Get.snackbar('Error', 'Please select end date and time');
      return false;
    }

    final startDateTime = DateTime(
      startDate.value!.year,
      startDate.value!.month,
      startDate.value!.day,
      startTime.value!.hour,
      startTime.value!.minute,
    );

    final endDateTime = DateTime(
      endDate.value!.year,
      endDate.value!.month,
      endDate.value!.day,
      endTime.value!.hour,
      endTime.value!.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      Get.snackbar(
        'Error',
        'End date and time must be after start date and time',
      );
      return false;
    }

    return true;
  }

  // Method untuk refresh semua controller event yang terdaftar
  void _refreshAllEventControllers() {
    // Refresh Event Management Controller jika terdaftar
    if (Get.isRegistered<EventManagementController>()) {
      try {
        Get.find<EventManagementController>().refreshEvents();
      } catch (e) {
        debugPrint('Error refreshing EventManagementController: $e');
      }
    }

    // Jika ada controller event lainnya, tambahkan di sini
    // Contoh:
    // if (Get.isRegistered<EventListController>()) {
    //   try {
    //     Get.find<EventListController>().refreshEvents();
    //   } catch (e) {
    //     debugPrint('Error refreshing EventListController: $e');
    //   }
    // }
  }

  Future<void> saveEvent() async {
    if (!formKey.currentState!.validate()) return;
    if (!_validateDates()) return;

    try {
      isLoading.value = true;

      final startDateTimeStr = _formatDateTime(
        startDate.value!,
        startTime.value!,
      );
      final endDateTimeStr = _formatDateTime(endDate.value!, endTime.value!);

      final int? capacity =
          capacityController.text.isNotEmpty
              ? int.tryParse(capacityController.text)
              : null;

      // Handle image - kirim File langsung ke API
      File? imageFile;
      if (imageSource.value == 'file' && selectedImage.value != null) {
        imageFile = selectedImage.value!;
      }
      // Jika user memilih URL, kita tidak kirim file (server akan handle URL terpisah)

      if (isEditMode.value && editingEvent.value != null) {
        // Update existing event
        await ApiService.updateEvent(
          eventId: editingEvent.value!.id,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          startDate: startDateTimeStr,
          endDate: endDateTimeStr,
          location: locationController.text.trim(),
          maxParticipants: capacity.toString(),
          image: imageFile, // Kirim File langsung
          status: selectedStatus.value,
        );

        Get.snackbar(
          'Success',
          'Event updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Create new event
        await ApiService.createEvent(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          startDate: startDateTimeStr,
          endDate: endDateTimeStr,
          location: locationController.text.trim(),
          maxParticipants: capacity.toString(),
          image: imageFile, // Kirim File langsung
          status: selectedStatus.value,
        );

        Get.snackbar(
          'Success',
          'Event created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }

      // Refresh semua controller yang terdaftar sebelum kembali
      _refreshAllEventControllers();

      // Kembali ke halaman sebelumnya setelah delay singkat untuk memastikan refresh selesai
      await Future.delayed(const Duration(milliseconds: 500));

      // Kembali ke route sebelumnya
      Get.back(result: true); // result: true menandakan operasi berhasil
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
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    capacityController.dispose();
    imageController.dispose();
    super.onClose();
  }
}
