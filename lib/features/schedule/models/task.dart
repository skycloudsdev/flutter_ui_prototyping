import 'package:flutter_ui_prototyping/features/schedule/models/task_type.dart';

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.type,
    required this.startTime,
    this.subtitle,
    this.endTime,
    this.categoryIds = const [],
    this.memberIds = const [],
    this.deadline,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String? subtitle;
  final TaskType type;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> categoryIds;
  final List<String> memberIds;
  final DateTime? deadline;
  final bool isCompleted;

  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    TaskType? type,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? categoryIds,
    List<String>? memberIds,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      categoryIds: categoryIds ?? this.categoryIds,
      memberIds: memberIds ?? this.memberIds,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
