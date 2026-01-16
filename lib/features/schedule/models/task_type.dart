import 'package:flutter/material.dart';

enum TaskType {
  design(Color(0xFF4B5EFC), 'Design meeting'),
  development(Color(0xFF8B5CF6), 'Development'),
  meeting(Color(0xFF6366F1), 'Company meeting'),
  mentoring(Color(0xFF3B82F6), 'Mentoring'),
  personal(Color(0xFFE5E7EB), 'Personal');

  const TaskType(this.color, this.label);

  final Color color;
  final String label;
}
