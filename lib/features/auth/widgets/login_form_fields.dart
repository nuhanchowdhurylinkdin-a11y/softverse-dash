import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/common/widgets/app_text_field.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/auth_controller.dart';

class LoginFormFields extends StatelessWidget {
  final AuthController controller;

  const LoginFormFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: controller.emailController,
          label: 'Email',
          hintText: 'johndheere@gmail.com',
          keyboardType: TextInputType.emailAddress,
          validator: controller.validateEmail,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.authFieldDivider),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => AppTextField(
            controller: controller.passwordController,
            label: 'Password',
            hintText: '********',
            obscureText: controller.obscurePassword.value,
            validator: controller.validatePassword,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.authFieldDivider),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword.value
                    ? Iconsax.eye_slash
                    : Iconsax.eye,
                color: AppColors.authTextDark,
                size: 20.sp,
              ),
              onPressed: controller.toggleObscurePassword,
            ),
          ),
        ),
      ],
    );
  }
}
