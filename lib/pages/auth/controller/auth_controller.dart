import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sistem_informasi/api/api.dart';
import 'package:sistem_informasi/app_routes.dart';
import 'package:sistem_informasi/service/storage.dart';

import '../../../models/user.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final loggedIn = await StorageService.isLoggedIn();
      isLoggedIn.value = loggedIn;

      if (loggedIn) {
        final user = await StorageService.getUser();
        currentUser.value = user;
        if (user != null) {
          isAdmin.value = user.role == 'admin';
        } else {
          isAdmin.value = false;
        }
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      isLoading.value = true;

      final authResponse = await ApiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      // Save token and user data
      await StorageService.saveToken(authResponse.token);
      await StorageService.saveUser(authResponse.user);

      currentUser.value = authResponse.user;
      isLoggedIn.value = true;

      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        'Success',
        'Registration successful!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
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

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;

      final authResponse = await ApiService.login(
        email: email,
        password: password,
      );

      // Save token and user data
      await StorageService.saveToken(authResponse.token);
      await StorageService.saveUser(authResponse.user);

      currentUser.value = authResponse.user;
      isLoggedIn.value = true;

      Get.offAllNamed(AppRoutes.home);
      Get.snackbar(
        'Success',
        'Login successful!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
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

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await ApiService.logout();

      currentUser.value = null;
      isLoggedIn.value = false;

      // Get.offAllNamed(AppRoutes.home);
      Get.snackbar(
        'Success',
        'Logged out successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
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
}
