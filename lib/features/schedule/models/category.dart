import 'package:flutter/material.dart';

class TaskCategory {
  const TaskCategory({
    required this.id,
    required this.name,
    required this.color,
    this.isSelected = false,
  });

  final String id;
  final String name;
  final Color color;
  final bool isSelected;

  TaskCategory copyWith({
    String? id,
    String? name,
    Color? color,
    bool? isSelected,
  }) {
    return TaskCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
