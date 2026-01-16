import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/schedule/models/models.dart';
import 'package:flutter_ui_prototyping/features/schedule/schedule_colors.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.category,
    required this.onTap,
    super.key,
  });

  final TaskCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: category.isSelected ? category.color : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: category.isSelected ? category.color : ScheduleColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              category.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: category.isSelected
                    ? Colors.white
                    : ScheduleColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCategoryChip extends StatelessWidget {
  const AddCategoryChip({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ScheduleColors.border, width: 1.5),
        ),
        child: const Icon(
          Icons.add,
          color: ScheduleColors.textMuted,
          size: 20,
        ),
      ),
    );
  }
}
