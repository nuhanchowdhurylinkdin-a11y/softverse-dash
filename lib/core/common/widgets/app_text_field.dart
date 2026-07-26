import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/global_text_style.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color textColor;
  final Color hintColor;
  final Color labelColor;
  final InputBorder? border;
  final bool hasBorder;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.textColor = const Color(0xFF2B353D),
    this.hintColor = const Color(0xFF9CA3AF),
    this.labelColor = const Color(0xFF2B353D),
    this.border,
    this.hasBorder = false,
    this.contentPadding,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedBorder = border ??
        (hasBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              )
            : InputBorder.none);

    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: getTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: backgroundColor != null,
        fillColor: backgroundColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: hintColor,
        ),
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 4.h),
        border: resolvedBorder,
        enabledBorder: resolvedBorder,
        focusedBorder: resolvedBorder,
        errorBorder: resolvedBorder,
        focusedErrorBorder: resolvedBorder,
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        SizedBox(height: 9.h),
        field,
      ],
    );
  }
}
