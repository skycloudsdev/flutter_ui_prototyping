import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

class ScheduleStarted extends ScheduleEvent {
  const ScheduleStarted();
}

class ScheduleDateSelected extends ScheduleEvent {
  const ScheduleDateSelected(this.date);

  final DateTime date;
}

class ScheduleTaskSelected extends ScheduleEvent {
  const ScheduleTaskSelected(this.task);

  final Task task;
}

class ScheduleTaskUpdated extends ScheduleEvent {
  const ScheduleTaskUpdated(this.task);

  final Task task;
}

class ScheduleTaskSheetDismissed extends ScheduleEvent {
  const ScheduleTaskSheetDismissed();
}

class ScheduleCategoryToggled extends ScheduleEvent {
  const ScheduleCategoryToggled(this.categoryId);

  final String categoryId;
}
