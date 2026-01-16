import 'package:flutter/material.dart';

abstract class BillSplitterColors {
  static const background = Color(0xFF3D3A5C);
  static const cardDark = Color(0xFF4A4872);
  static const cardLight = Color(0xFFE8D5B5);
  static const accent = Color(0xFF6B6398);
  static const buttonPrimary = Color(0xFF4A4872);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0ADC6);
  static const sliderTrackInactive = Color(0xFF5A5780);

  // Slider colors
  static const sliderOrange = Color(0xFFE8956D);
  static const sliderPurple = Color(0xFF9B8CD6);
  static const sliderYellow = Color(0xFFE8B86D);
  static const sliderTeal = Color(0xFF7ECEC6);
  static const sliderPink = Color(0xFFE86D8A);
  static const sliderBlue = Color(0xFF6DB5E8);

  static const List<Color> defaultSliderColors = [
    sliderOrange,
    sliderPurple,
    sliderYellow,
    sliderTeal,
    sliderPink,
    sliderBlue,
  ];

  // Avatar background colors
  static const List<Color> avatarColors = [
    Color(0xFFE8956D),
    Color(0xFF9B8CD6),
    Color(0xFFE8B86D),
    Color(0xFF7ECEC6),
    Color(0xFFE86D8A),
    Color(0xFF6DB5E8),
    Color(0xFFA8E86D),
    Color(0xFFE86DC4),
  ];
}
