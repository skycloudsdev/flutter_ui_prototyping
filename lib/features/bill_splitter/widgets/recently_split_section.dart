import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/friend_avatar.dart';

class RecentlySplitSection extends StatelessWidget {
  final List<Friend> friends;

  const RecentlySplitSection({
    required this.friends,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recently Split',
          style: TextStyle(
            color: BillSplitterColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: friends.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendAvatar(
                friend: friend,
                size: 50,
              );
            },
          ),
        ),
      ],
    );
  }
}
