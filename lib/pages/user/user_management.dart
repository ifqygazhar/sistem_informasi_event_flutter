import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/pages/user/controller/user_controller.dart';
import 'package:sistem_informasi/pages/user/widget/user_management_item.dart';
import 'package:sistem_informasi/pages/user/widget/user_form_dialog.dart';
import 'package:sistem_informasi/utils/text.dart';
import 'package:sistem_informasi/utils/colors.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
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
          text: "User Management",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontColor: primaryColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: primaryColor),
            onPressed: controller.refreshUsers,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshUsers,
        child: Obx(() {
          if (controller.isLoading.value && controller.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  SizedBox(height: sizeHeight * 0.02),
                  TextGlobalWidget(
                    text: "No users found",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.grey[600],
                  ),
                  SizedBox(height: sizeHeight * 0.01),
                  TextGlobalWidget(
                    text: "Create your first user to get started",
                    fontSize: 14,
                    fontColor: Colors.grey[500],
                  ),
                  SizedBox(height: sizeHeight * 0.03),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.setupCreateUser();
                      Get.dialog(const UserFormDialog());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create User'),
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

          return Column(
            children: [
              // Statistics card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.people,
                      label: 'Total Users',
                      value: '${controller.pagination.value?.total ?? 0}',
                    ),
                    _buildStatItem(
                      icon: Icons.admin_panel_settings,
                      label: 'Admins',
                      value:
                          '${controller.users.where((u) => u.role == 'admin').length}',
                    ),
                    _buildStatItem(
                      icon: Icons.person,
                      label: 'Users',
                      value:
                          '${controller.users.where((u) => u.role == 'user').length}',
                    ),
                  ],
                ),
              ),

              // Users list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.users.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.users.length) {
                      // Load more indicator
                      if (controller.pagination.value?.hasMorePages == true) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: controller.loadMoreUsers,
                              child: const Text('Load More'),
                            ),
                          ),
                        );
                      }
                      return const SizedBox(height: 80); // Space for FAB
                    }

                    final user = controller.users[index];
                    return UserManagementItem(
                      user: user,
                      sizeHeight: sizeHeight,
                      sizeWidth: sizeWidth,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.setupCreateUser();
          Get.dialog(const UserFormDialog());
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(height: 4),
        TextGlobalWidget(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontColor: primaryColor,
        ),
        TextGlobalWidget(
          text: label,
          fontSize: 12,
          fontColor: Colors.grey[600],
        ),
      ],
    );
  }
}
