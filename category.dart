import 'package:flutter/material.dart';

  enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class SubCategory {
  final String title;
  final String emoji;

  const SubCategory(this.title, this.emoji);
}

class Category {
  const Category(this.title, this.emoji,[this.subcategories = const[]]);

  final String title;
  final String emoji;
  final List<SubCategory> subcategories;
}