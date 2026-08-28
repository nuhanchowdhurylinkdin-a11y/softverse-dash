import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isLoggingIn = false.obs;

  void toggleObscurePassword() =>
      obscurePassword.value = !obscurePassword.value;

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoggingIn.value = true;
    final response = await _networkCaller.postRequest(
      ApiConstants.login,
      body: {
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'access': 'back_office',
      },
      token: '',
    );
    isLoggingIn.value = false;

    if (!response.isSuccess) {
      AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      return;
    }

    final data = Map<String, dynamic>.from(response.responseData as Map);
    final user = Map<String, dynamic>.from(data['user'] as Map);
    await StorageService.saveUserSession(
      id: user['id']?.toString() ?? '',
      fullName: user['fullName']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      accessToken: data['accessToken']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
    );

    Get.offAllNamed(AppRoute.getDashboardScreen());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
