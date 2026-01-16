import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';
import 'package:flutter_ui_prototyping/features/schedule/schedule_colors.dart';
import 'package:flutter_ui_prototyping/features/schedule/widgets/category_chip.dart';
import 'package:flutter_ui_prototyping/features/schedule/widgets/member_avatar.dart';

class TaskDetailSheet extends StatelessWidget {
  const TaskDetailSheet({
    required this.task,
    required this.categories,
    required this.members,
    required this.onDone,
    required this.onCategoryToggle,
    required this.onAddCategory,
    required this.onAddMember,
    super.key,
  });

  final Task task;
  final List<TaskCategory> categories;
  final List<Member> members;
  final VoidCallback onDone;
  final ValueChanged<String> onCategoryToggle;
  final VoidCallback onAddCategory;
  final VoidCallback onAddMember;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ScheduleColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Task name header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Task name',
                      style: TextStyle(
                        fontSize: 12,
                        color: ScheduleColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ScheduleColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ScheduleColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Categories section
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ScheduleColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...categories.map(
                (category) => CategoryChip(
                  category: category,
                  onTap: () => onCategoryToggle(category.id),
                ),
              ),
              AddCategoryChip(onTap: onAddCategory),
            ],
          ),
          const SizedBox(height: 24),

          // Members section
          const Text(
            'Add members',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ScheduleColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...members.map(
                (member) => MemberAvatar(
                  member: member,
                  isSelected: task.memberIds.contains(member.id),
                ),
              ),
              AddMemberButton(onTap: onAddMember),
            ],
          ),
          const SizedBox(height: 24),

          // Deadline section
          const Text(
            'Deadline',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ScheduleColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _DeadlineOption(
                icon: Icons.calendar_today_outlined,
                label: task.deadline != null
                    ? _formatDeadline(task.deadline!)
                    : 'Set deadline',
                isSelected: task.deadline != null,
                onTap: () {
                  // TODO: Show date picker
                },
              ),
              const SizedBox(width: 12),
              _DeadlineOption(
                label: 'No deadline',
                isSelected: task.deadline == null,
                onTap: () {
                  // TODO: Clear deadline
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    final day = deadline.day.toString().padLeft(2, '0');
    final month = deadline.month.toString().padLeft(2, '0');
    final year = deadline.year;
    final hour = deadline.hour.toString().padLeft(2, '0');
    final minute = deadline.minute.toString().padLeft(2, '0');
    return '$day-$month-$year, $hour:$minute';
  }
}

class _DeadlineOption extends StatelessWidget {
  const _DeadlineOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final IconData? icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ScheduleColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ScheduleColors.primary : ScheduleColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? ScheduleColors.primary
                    : ScheduleColors.textMuted,
              ),
              const SizedBox(width: 8),
            ] else
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? ScheduleColors.primary
                        : ScheduleColors.textMuted,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: ScheduleColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? ScheduleColors.primary
                    : ScheduleColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
