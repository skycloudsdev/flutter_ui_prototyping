import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';
import 'package:flutter_ui_prototyping/features/schedule/schedule_colors.dart';
import 'package:flutter_ui_prototyping/features/schedule/widgets/task_card.dart';

class TimelineTaskList extends StatelessWidget {
  const TimelineTaskList({
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskOptionsTap,
    super.key,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onTaskTap;
  final ValueChanged<Task> onTaskOptionsTap;

  @override
  Widget build(BuildContext context) {
    // Group tasks by hour
    final tasksByHour = <int, List<Task>>{};
    for (final task in tasks) {
      final hour = task.startTime.hour;
      tasksByHour.putIfAbsent(hour, () => []).add(task);
    }

    // Generate time slots from 8:00 to 13:00
    final timeSlots = List.generate(6, (i) => 8 + i);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final hour = timeSlots[index];
        final tasksAtHour = tasksByHour[hour] ?? [];
        final timeLabel = '${hour.toString().padLeft(2, '0')}:00';

        return _TimelineRow(
          timeLabel: timeLabel,
          tasks: tasksAtHour,
          onTaskTap: onTaskTap,
          onTaskOptionsTap: onTaskOptionsTap,
          isLast: index == timeSlots.length - 1,
        );
      },
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.timeLabel,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskOptionsTap,
    required this.isLast,
  });

  final String timeLabel;
  final List<Task> tasks;
  final ValueChanged<Task> onTaskTap;
  final ValueChanged<Task> onTaskOptionsTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                timeLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: ScheduleColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: ScheduleColors.border,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: ScheduleColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: tasks.isEmpty
                  ? const SizedBox(height: 60)
                  : Column(
                      children: tasks.map((task) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TaskCard(
                            task: task,
                            onTap: () => onTaskTap(task),
                            onOptionsTap: () => onTaskOptionsTap(task),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
