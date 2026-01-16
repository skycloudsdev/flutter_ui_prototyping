import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/friend_avatar.dart';

class NearbyFriendsSection extends StatelessWidget {
  final List<Friend> friends;
  final List<Friend> selectedFriends;
  final ValueChanged<Friend> onFriendTap;
  final VoidCallback? onSeeAll;

  const NearbyFriendsSection({
    required this.friends,
    required this.selectedFriends,
    required this.onFriendTap,
    super.key,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BillSplitterColors.cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: BillSplitterColors.cardLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.black54,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Nearby Friends',
                style: TextStyle(
                  color: BillSplitterColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      color: BillSplitterColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: friends.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final friend = friends[index];
                final isSelected = selectedFriends.contains(friend);
                return FriendAvatar(
                  friend: friend,
                  size: 50,
                  isSelected: isSelected,
                  onTap: () => onFriendTap(friend),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
