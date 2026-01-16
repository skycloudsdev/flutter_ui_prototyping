import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/friend_avatar.dart';

class ReceiptCard extends StatelessWidget {
  final String title;
  final double totalAmount;
  final List<Friend> participants;

  const ReceiptCard({
    required this.title,
    required this.totalAmount,
    required this.participants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Bill',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...participants
                  .take(4)
                  .map(
                    (friend) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FriendAvatar(
                        friend: friend,
                        size: 36,
                        showName: false,
                      ),
                    ),
                  ),
              if (participants.length > 4)
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BillSplitterColors.cardDark,
                  ),
                  child: Center(
                    child: Text(
                      '+${participants.length - 4}',
                      style: const TextStyle(
                        color: BillSplitterColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Splitting With',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
