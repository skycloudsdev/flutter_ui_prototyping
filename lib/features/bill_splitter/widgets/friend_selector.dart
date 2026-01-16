import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/friend_avatar.dart';

class FriendSelector extends StatelessWidget {
  final List<Friend> selectedFriends;
  final VoidCallback onAddFriend;

  const FriendSelector({
    required this.selectedFriends,
    required this.onAddFriend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BillSplitterColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Split with',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          if (selectedFriends.isEmpty)
            _buildAddButton()
          else
            _buildSelectedFriends(),
        ],
      ),
    );
  }

  Widget _buildSelectedFriends() {
    return Column(
      children: [
        ...selectedFriends
            .take(3)
            .map(
              (friend) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FriendAvatar(
                  friend: friend,
                  size: 40,
                  showName: false,
                ),
              ),
            ),
        if (selectedFriends.length > 3)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: BillSplitterColors.cardDark,
            ),
            child: Center(
              child: Text(
                '+${selectedFriends.length - 3}',
                style: const TextStyle(
                  color: BillSplitterColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddFriend,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: BillSplitterColors.sliderOrange,
          boxShadow: [
            BoxShadow(
              color: BillSplitterColors.sliderOrange.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
