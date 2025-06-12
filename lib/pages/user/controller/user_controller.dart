import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/api/api.dart';
import 'package:sistem_informasi/models/user_management.dart';

class UserController extends GetxController {
  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final Rx<PaginationInfo?> pagination = Rx<PaginationInfo?>(null);

  // Form controllers for create/edit user
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final RxString selectedRole = 'user'.obs;
  final RxBool isEditMode = false.obs;
  final Rx<User?> editingUser = Rx<User?>(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> roleOptions = ['user', 'admin'];

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  /// Load users with pagination
  Future<void> loadUsers({int page = 1, bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        isRefreshing.value = true;
      } else {
        isLoading.value = true;
      }

      final response = await ApiService.getUsers(page: page);
      final List<User> usersList = response['users'];
      final PaginationInfo paginationInfo = response['pagination'];

      if (page == 1) {
        users.assignAll(usersList);
      } else {
        users.addAll(usersList);
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

  /// Refresh users
  Future<void> refreshUsers() async {
    await loadUsers(page: 1, isRefresh: true);
  }

  /// Load more users
  Future<void> loadMoreUsers() async {
    if (pagination.value?.hasMorePages == true) {
      final currentPage = pagination.value?.currentPage ?? 1;
      await loadUsers(page: currentPage + 1);
    }
  }

  /// Set up for creating new user
  void setupCreateUser() {
    isEditMode.value = false;
    editingUser.value = null;
    _clearForm();
  }

  /// Set up for editing user
  void setupEditUser(User user) {
    isEditMode.value = true;
    editingUser.value = user;
    _populateForm(user);
  }

  /// Clear form fields
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    selectedRole.value = 'user';
  }

  /// Populate form with user data
  void _populateForm(User user) {
    nameController.text = user.name;
    emailController.text = user.email;
    passwordController.clear();
    passwordConfirmationController.clear();
    selectedRole.value = user.role;
  }

  /// Save user (create or update)
  Future<void> saveUser() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      if (isEditMode.value && editingUser.value != null) {
        // Update user
        await ApiService.updateUser(
          userId: editingUser.value!.id,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          role: selectedRole.value,
          password:
              passwordController.text.isNotEmpty
                  ? passwordController.text
                  : null,
          passwordConfirmation:
              passwordConfirmationController.text.isNotEmpty
                  ? passwordConfirmationController.text
                  : null,
        );

        Get.snackbar(
          'Success',
          'User updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Create user
        await ApiService.createUser(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          passwordConfirmation: passwordConfirmationController.text,
          role: selectedRole.value,
        );

        Get.snackbar(
          'Success',
          'User created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }

      // Refresh users list
      await refreshUsers();

      // Clear form and close dialog/page
      _clearForm();
      Get.back(result: true);
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

  /// Delete user
  Future<void> deleteUser(int userId, String userName) async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete User'),
          content: Text(
            'Are you sure you want to delete user "$userName"? This action cannot be undone.',
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

      await ApiService.deleteUser(userId);

      // Close loading
      Get.back();

      // Remove from list
      users.removeWhere((user) => user.id == userId);

      Get.snackbar(
        'Success',
        'User deleted successfully',
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }
}
