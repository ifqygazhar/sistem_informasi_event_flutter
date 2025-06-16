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
    // Listen to currentUser changes
    ever(currentUser, (_) async {
      final user = await StorageService.getUser();
      if (user != null) {
        isAdmin.value = user.role == 'admin';
        debugPrint(
          'User changed - isAdmin: ${isAdmin.value}, role: ${user.role}',
        );
      } else {
        isAdmin.value = false;
        debugPrint('User is null - isAdmin set to false');
      }
    });

    // Listen to isLoggedIn changes
    ever(isLoggedIn, (bool loggedIn) {
      debugPrint('Login status changed: $loggedIn');
      if (!loggedIn) {
        currentUser.value = null;
        isAdmin.value = false;
      }
    });
  }

  Future<void> checkAuthStatus() async {
    try {
      final loggedIn = await StorageService.isLoggedIn();
      isLoggedIn.value = loggedIn;

      if (loggedIn) {
        final user = await StorageService.getUser();
        currentUser.value = user;
        debugPrint('Current user data: ${user?.toJson()}');
        if (user != null) {
          isAdmin.value = user.role == 'admin';
          debugPrint('User is admin: ${isAdmin.value}');
        } else {
          isAdmin.value = false;
          debugPrint('User data is null, setting isAdmin to false');
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

      debugPrint('Login response: ${authResponse.user.role}');

      // Save token and user data
      await StorageService.saveToken(authResponse.token);
      await StorageService.saveUser(authResponse.user);

      final user = currentUser.value = authResponse.user;
      isLoggedIn.value = true;

      if (user.role == 'admin') {
        isAdmin.value = true;
      } else {
        isAdmin.value = false;
      }

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
