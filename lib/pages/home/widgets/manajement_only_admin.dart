import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/app_routes.dart';
import 'package:sistem_informasi/pages/home/controller/home_controller.dart';
import 'package:sistem_informasi/utils/text.dart';

class ManajementOnlyAdminWidget extends StatelessWidget {
  final double sizeHeight, sizeWidth;
  const ManajementOnlyAdminWidget({
    super.key,
    required this.sizeHeight,
    required this.sizeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Column(
      children: [
        SizedBox(height: sizeHeight * 0.002),
        GestureDetector(
          onTap: () async {
            final result = await Get.toNamed(AppRoutes.eventManagement);
            if (result == true) {
              controller.refreshEvents();
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(sizeHeight * 0.01),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.event, color: Colors.white),
                SizedBox(width: sizeWidth * 0.01),
                TextGlobalWidget(text: "Manajemen Event", fontSize: 14),
              ],
            ),
          ),
        ),
        SizedBox(height: sizeHeight * 0.008),
        Container(
          margin: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(sizeHeight * 0.01),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person, color: Colors.white),
              SizedBox(width: sizeWidth * 0.01),
              TextGlobalWidget(text: "Manajemen Users", fontSize: 14),
            ],
          ),
        ),
        SizedBox(height: sizeHeight * 0.01),
      ],
    );
  }
}
