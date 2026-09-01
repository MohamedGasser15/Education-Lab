import 'package:flutter/material.dart';

class FilterChipItem {
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const FilterChipItem({
    required this.label,
    this.icon,
    this.iconColor,
  });
}

class CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String coursesCount;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.coursesCount,
  });
}

class CourseItem {
  final String id;
  final String title;
  final String arabicTitle;
  final String instructor;
  final double rating;
  final String reviews;
  final String price;
  final String originalPrice;
  final String category;
  final bool isBestseller;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String duration;
  final IconData icon;
  final List<Color> gradient;

  const CourseItem({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.instructor,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.isBestseller,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.duration,
    required this.icon,
    required this.gradient,
  });
}
