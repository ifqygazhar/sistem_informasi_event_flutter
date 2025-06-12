import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/pages/user/controller/user_controller.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';

class UserFormDialog extends StatelessWidget {
  const UserFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: sizeWidth * 0.9,
        constraints: BoxConstraints(maxHeight: sizeHeight * 0.8, maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TextGlobalWidget(
                        text:
                            controller.isEditMode.value
                                ? "Edit User"
                                : "Create User",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontColor: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Form content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field
                      _buildSectionTitle("Full Name"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.nameController,
                        decoration: _buildInputDecoration(
                          hintText: "Enter full name",
                          prefixIcon: Icons.person,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      _buildSectionTitle("Email Address"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          hintText: "Enter email address",
                          prefixIcon: Icons.email,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Role field
                      _buildSectionTitle("Role"),
                      const SizedBox(height: 8),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedRole.value,
                          decoration: _buildInputDecoration(
                            hintText: "Select role",
                            prefixIcon: Icons.admin_panel_settings,
                          ),
                          items:
                              controller.roleOptions.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role.toUpperCase()),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedRole.value = value;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password fields
                      _buildSectionTitle(
                        controller.isEditMode.value
                            ? "Password (Leave empty to keep current)"
                            : "Password",
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: _buildInputDecoration(
                          hintText: "Enter password",
                          prefixIcon: Icons.lock,
                        ),
                        validator: (value) {
                          if (!controller.isEditMode.value) {
                            // For create mode, password is required
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                          } else {
                            // For edit mode, validate only if password is provided
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildSectionTitle("Confirm Password"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.passwordConfirmationController,
                        obscureText: true,
                        decoration: _buildInputDecoration(
                          hintText: "Confirm password",
                          prefixIcon: Icons.lock_outline,
                        ),
                        validator: (value) {
                          final password = controller.passwordController.text;

                          if (!controller.isEditMode.value) {
                            // For create mode, confirmation is required
                            if (value != password) {
                              return 'Passwords do not match';
                            }
                          } else {
                            // For edit mode, validate only if password is provided
                            if (password.isNotEmpty && value != password) {
                              return 'Passwords do not match';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(
                              () => ElevatedButton(
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.saveUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child:
                                    controller.isLoading.value
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : TextGlobalWidget(
                                          text:
                                              controller.isEditMode.value
                                                  ? "Update User"
                                                  : "Create User",
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontColor: Colors.white,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return TextGlobalWidget(
      text: title,
      fontSize: 14,
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
