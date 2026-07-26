import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/auth_controller.dart';
import '../../widgets/login_form_fields.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 447.h,
                child: ColoredBox(
                  color: AppColors.authBackground,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 134.h),
                      child: SizedBox(
                        width: 273.w,
                        height: 222.h,
                        child: Image.asset(
                          'assets/icons/Logo-white.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 79.h, 16.w, 79.h),
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoginFormFields(controller: controller),
                          SizedBox(height: 12.h),
                          Text(
                            'Forgot password',
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.authLink,
                            ),
                          ),
                          SizedBox(height: 38.h),
                          Obx(
                            () => AppButton(
                              label: 'Sign in',
                              isLoading: controller.isLoggingIn.value,
                              onPressed: controller.login,
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.authGradientStart,
                                  AppColors.authGradientEnd,
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 22.h),
                          SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have account ? ",
                                    style: getTextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.authTextDark,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Register Now',
                                    style: getTextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.authLink,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
