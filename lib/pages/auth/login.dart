import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/pages/auth/controller/auth_controller.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';
import 'package:sistem_informasi/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(sizeWidth * 0.05),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Title
                TextGlobalWidget(
                  text: "Login",
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontColor: primaryColor,
                ),
                SizedBox(height: sizeHeight * 0.05),

                // Email Field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: primaryColor),
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: sizeHeight * 0.02),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: primaryColor),
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: sizeHeight * 0.04),

                // Login Button
                Obx(
                  () => GestureDetector(
                    onTap:
                        authController.isLoading.value
                            ? null
                            : () {
                              if (formKey.currentState!.validate()) {
                                authController.login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                );
                              }
                            },
                    child: Container(
                      width: double.infinity,
                      height: sizeHeight * 0.06,
                      decoration: BoxDecoration(
                        color:
                            authController.isLoading.value
                                ? Colors.grey
                                : primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child:
                            authController.isLoading.value
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const TextGlobalWidget(
                                  text: "Login",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontColor: Colors.white,
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sizeHeight * 0.02),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextGlobalWidget(
                      text: "Don't have an account? ",
                      fontSize: 14,
                      fontColor: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: const TextGlobalWidget(
                        text: "Register here",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
