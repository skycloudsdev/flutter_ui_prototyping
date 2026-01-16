import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';
import 'package:flutter_ui_prototyping/features/schedule/schedule_colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.onTap,
    required this.onOptionsTap,
    super.key,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onOptionsTap;

  @override
  Widget build(BuildContext context) {
    final isPersonal = task.type == TaskType.personal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPersonal
              ? ScheduleColors.taskCardLight
              : ScheduleColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: isPersonal
              ? null
              : Border(
                  left: BorderSide(
                    color: task.type.color,
                    width: 4,
                  ),
                ),
          boxShadow: isPersonal
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.subtitle != null && !isPersonal)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        task.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: task.type.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPersonal
                          ? ScheduleColors.textSecondary
                          : ScheduleColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (!isPersonal)
              IconButton(
                onPressed: onOptionsTap,
                icon: const Icon(
                  Icons.more_horiz,
                  color: ScheduleColors.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
