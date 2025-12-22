import 'package:flutter/material.dart';

class BottomNavModel {
  final String title;
  final String activeImageUrl;
  final String disableImageUrl;

  BottomNavModel({
    required this.activeImageUrl,
    required this.disableImageUrl,
    required this.title,
  });
}

class BottomNavIconModel {
  final String title;
  final IconData activeImageUrl;
  final IconData disableImageUrl;

  BottomNavIconModel({
    required this.activeImageUrl,
    required this.disableImageUrl,
    required this.title,
  });
}
