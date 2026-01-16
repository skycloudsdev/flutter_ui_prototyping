import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';
import 'package:flutter_ui_prototyping/features/schedule/schedule_colors.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    required this.member,
    this.size = 48,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  final Member member;
  final double size;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: ScheduleColors.primary, width: 2)
              : null,
        ),
        child: ClipOval(
          child: Image.network(
            member.avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => ColoredBox(
              color: ScheduleColors.taskCardLight,
              child: Icon(
                Icons.person,
                size: size * 0.5,
                color: ScheduleColors.textMuted,
              ),
            ),
            loadingBuilder: (_, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const ColoredBox(
                color: ScheduleColors.taskCardLight,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddMemberButton extends StatelessWidget {
  const AddMemberButton({
    required this.onTap,
    this.size = 48,
    super.key,
  });

  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ScheduleColors.taskCardLight,
          ),
          child: Icon(
            Icons.add,
            color: ScheduleColors.textMuted,
          ),
        ),
      ),
    );
  }
}
