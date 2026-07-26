import 'package:flutter/material.dart';

class DashboardCategoryModel {
  final String name;
  final int quantity;
  final double price;
  final List<Color> gradientColors;

  const DashboardCategoryModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.gradientColors,
  });
}
