import 'package:flutter/material.dart';

@immutable
class Friend {
  final String id;
  final String name;
  final Color avatarColor;
  final Color? sliderColor;

  const Friend({
    required this.id,
    required this.name,
    required this.avatarColor,
    this.sliderColor,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Friend copyWith({
    String? id,
    String? name,
    Color? avatarColor,
    Color? sliderColor,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarColor: avatarColor ?? this.avatarColor,
      sliderColor: sliderColor ?? this.sliderColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Friend && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
