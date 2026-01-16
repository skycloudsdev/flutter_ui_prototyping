import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';

enum ScheduleStatus { initial, loading, loaded, error }

class ScheduleState {
  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.selectedDate,
    this.tasks = const [],
    this.categories = const [],
    this.members = const [],
    this.selectedTask,
    this.errorMessage,
  });

  final ScheduleStatus status;
  final DateTime? selectedDate;
  final List<Task> tasks;
  final List<TaskCategory> categories;
  final List<Member> members;
  final Task? selectedTask;
  final String? errorMessage;

  ScheduleState copyWith({
    ScheduleStatus? status,
    DateTime? selectedDate,
    List<Task>? tasks,
    List<TaskCategory>? categories,
    List<Member>? members,
    Task? selectedTask,
    String? errorMessage,
    bool clearSelectedTask = false,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      tasks: tasks ?? this.tasks,
      categories: categories ?? this.categories,
      members: members ?? this.members,
      selectedTask: clearSelectedTask
          ? null
          : (selectedTask ?? this.selectedTask),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<Task> get filteredTasks {
    if (selectedDate == null) return tasks;
    return tasks.where((task) {
      return task.startTime.year == selectedDate!.year &&
          task.startTime.month == selectedDate!.month &&
          task.startTime.day == selectedDate!.day;
    }).toList();
  }
}
