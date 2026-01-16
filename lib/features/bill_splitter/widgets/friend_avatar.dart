import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';

class FriendAvatar extends StatelessWidget {
  final Friend friend;
  final double size;
  final bool showName;
  final bool isSelected;
  final VoidCallback? onTap;

  const FriendAvatar({
    required this.friend,
    super.key,
    this.size = 48,
    this.showName = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: friend.avatarColor,
                  border: isSelected
                      ? Border.all(
                          color: BillSplitterColors.textPrimary,
                          width: 2,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    friend.initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: size * 0.35,
                    height: size * 0.35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: size * 0.25,
                    ),
                  ),
                ),
            ],
          ),
          if (showName) ...[
            const SizedBox(height: 4),
            Text(
              friend.name,
              style: const TextStyle(
                color: BillSplitterColors.textPrimary,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
