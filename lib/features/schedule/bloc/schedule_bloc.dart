import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/schedule/bloc/schedule_event.dart';
import 'package:flutter_ui_prototyping/features/schedule/bloc/schedule_state.dart';
import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(const ScheduleState()) {
    on<ScheduleStarted>(_onStarted);
    on<ScheduleDateSelected>(_onDateSelected);
    on<ScheduleTaskSelected>(_onTaskSelected);
    on<ScheduleTaskUpdated>(_onTaskUpdated);
    on<ScheduleTaskSheetDismissed>(_onTaskSheetDismissed);
    on<ScheduleCategoryToggled>(_onCategoryToggled);
  }

  void _onStarted(
    ScheduleStarted event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(status: ScheduleStatus.loading));

    final now = DateTime.now();
    final selectedDate = DateTime(now.year, now.month, now.day);

    emit(
      state.copyWith(
        status: ScheduleStatus.loaded,
        selectedDate: selectedDate,
        tasks: _dummyTasks,
        categories: _dummyCategories,
        members: _dummyMembers,
      ),
    );
  }

  void _onDateSelected(
    ScheduleDateSelected event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onTaskSelected(
    ScheduleTaskSelected event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(selectedTask: event.task));
  }

  void _onTaskUpdated(
    ScheduleTaskUpdated event,
    Emitter<ScheduleState> emit,
  ) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == event.task.id ? event.task : task;
    }).toList();

    emit(
      state.copyWith(
        tasks: updatedTasks,
        selectedTask: event.task,
      ),
    );
  }

  void _onTaskSheetDismissed(
    ScheduleTaskSheetDismissed event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(clearSelectedTask: true));
  }

  void _onCategoryToggled(
    ScheduleCategoryToggled event,
    Emitter<ScheduleState> emit,
  ) {
    final updatedCategories = state.categories.map((category) {
      if (category.id == event.categoryId) {
        return category.copyWith(isSelected: !category.isSelected);
      }
      return category;
    }).toList();

    emit(state.copyWith(categories: updatedCategories));
  }

  // Dummy data - generated dynamically for current date
  static List<Task> get _dummyTasks {
    final now = DateTime.now();
    return [
      Task(
        id: '1',
        title: 'UI Strategy',
        subtitle: 'Design meeting',
        type: TaskType.design,
        startTime: DateTime(now.year, now.month, now.day, 8),
        categoryIds: ['1'],
        memberIds: ['0', '1', '2'],
        deadline: DateTime(now.year, now.month, now.day, 17),
      ),
      Task(
        id: '2',
        title: 'Deploy PWA',
        subtitle: 'Development',
        type: TaskType.development,
        startTime: DateTime(now.year, now.month, now.day, 9),
        categoryIds: ['2'],
      ),
      Task(
        id: '3',
        title: 'Lunch break',
        type: TaskType.personal,
        startTime: DateTime(now.year, now.month, now.day, 10),
      ),
      Task(
        id: '4',
        title: 'Financial plan',
        subtitle: 'Company meeting',
        type: TaskType.meeting,
        startTime: DateTime(now.year, now.month, now.day, 11),
      ),
      Task(
        id: '5',
        title: 'Onboarding a...',
        subtitle: 'Mentoring',
        type: TaskType.mentoring,
        startTime: DateTime(now.year, now.month, now.day, 12),
      ),
    ];
  }

  static const _dummyCategories = [
    TaskCategory(
      id: '1',
      name: 'Design',
      color: Color(0xFF4B5EFC),
      isSelected: true,
    ),
    TaskCategory(
      id: '2',
      name: 'Frontend',
      color: Color(0xFF6B7280),
    ),
  ];

  static final _dummyMembers = List.generate(
    6,
    (i) => Member(
      id: '$i',
      name: 'Member $i',
      avatarUrl: 'https://i.pravatar.cc/150?img=${i + 1}',
    ),
  );
}
