import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sistem_informasi/pages/auth/controller/auth_controller.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';
import 'package:sistem_informasi/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sizeWidth * 0.05),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: sizeHeight * 0.05),

                // Title
                TextGlobalWidget(
                  text: "Create Account",
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontColor: primaryColor,
                ),
                SizedBox(height: sizeHeight * 0.05),

                // Name Field
                TextFormField(
                  controller: nameController,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: primaryColor),
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person, color: primaryColor),
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
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: sizeHeight * 0.02),

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
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: sizeHeight * 0.02),

                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: primaryColor),
                    labelText: "Confirm Password",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: primaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
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
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: sizeHeight * 0.04),

                // Register Button
                Obx(
                  () => GestureDetector(
                    onTap:
                        authController.isLoading.value
                            ? null
                            : () {
                              if (formKey.currentState!.validate()) {
                                authController.register(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                  passwordConfirmation:
                                      confirmPasswordController.text,
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
                                  text: "Register",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontColor: Colors.white,
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sizeHeight * 0.02),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextGlobalWidget(
                      text: "Already have an account? ",
                      fontSize: 14,
                      fontColor: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: const TextGlobalWidget(
                        text: "Login here",
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
