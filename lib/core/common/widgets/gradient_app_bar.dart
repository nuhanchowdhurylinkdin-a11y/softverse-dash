import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/global_text_style.dart';

/// A gradient-backgrounded AppBar with an optional trailing widget and an
/// optional [bottom] row (e.g. a secondary nav/date bar), used by screens
/// with a branded gradient header (dashboard, CDS home, etc).
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Color> gradientColors;
  final Widget? leading;
  final Widget? trailing;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;
  final double titleFontSize;
  final double? titleLetterSpacing;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradientColors,
    this.leading,
    this.trailing,
    this.bottom,
    this.toolbarHeight = 55,
    this.titleFontSize = 18,
    this.titleLetterSpacing,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight.h + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: leading,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: toolbarHeight.h,
        titleSpacing: 16.w,
        title: Text(
          title,
          style: getTextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: titleLetterSpacing,
          ),
        ),
        actions: trailing == null
            ? null
            : [Padding(padding: EdgeInsets.only(right: 16.w), child: trailing!)],
        bottom: bottom,
      ),
    );
  }
}
