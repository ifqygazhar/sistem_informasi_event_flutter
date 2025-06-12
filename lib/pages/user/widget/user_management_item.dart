import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/models/user_management.dart';
import 'package:sistem_informasi/pages/user/controller/user_controller.dart';
import 'package:sistem_informasi/pages/user/widget/user_form_dialog.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';
import 'package:intl/intl.dart';

class UserManagementItem extends StatelessWidget {
  final User user;
  final double sizeHeight;
  final double sizeWidth;

  const UserManagementItem({
    super.key,
    required this.user,
    required this.sizeHeight,
    required this.sizeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and role badge
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: TextGlobalWidget(
                    text:
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontColor: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),

                // Name and email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextGlobalWidget(
                        text: user.name,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontColor: Colors.black87,
                      ),
                      const SizedBox(height: 2),
                      TextGlobalWidget(
                        text: user.email,
                        fontSize: 14,
                        fontColor: Colors.grey[600],
                      ),
                    ],
                  ),
                ),

                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextGlobalWidget(
                    text: user.role.toUpperCase(),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // User info
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                TextGlobalWidget(
                  text:
                      'Joined: ${DateFormat('dd MMM yyyy').format(user.createdAt)}',
                  fontSize: 12,
                  fontColor: Colors.grey[500],
                ),
                const SizedBox(width: 16),
                if (user.emailVerifiedAt != null) ...[
                  Icon(Icons.verified, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  TextGlobalWidget(
                    text: 'Verified',
                    fontSize: 12,
                    fontColor: Colors.green,
                  ),
                ] else ...[
                  Icon(Icons.warning, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  TextGlobalWidget(
                    text: 'Unverified',
                    fontSize: 12,
                    fontColor: Colors.orange,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Action buttons
            Row(
              children: [
                // Edit button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      controller.setupEditUser(user);
                      Get.dialog(const UserFormDialog());
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Delete button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      controller.deleteUser(user.id, user.name);
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'user':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
