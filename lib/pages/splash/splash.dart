import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/utils/text.dart';

import '../../app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [TextGlobalWidget(text: "SplashScreen", fontSize: 20)],
        ),
      ),
    );
  }
}
