import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/friend_avatar.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/split_slider.dart';

class SplitParticipantRow extends StatelessWidget {
  final Friend friend;
  final double amount;
  final double maxAmount;
  final bool isCurrentUser;
  final ValueChanged<double> onAmountChanged;

  const SplitParticipantRow({
    required this.friend,
    required this.amount,
    required this.maxAmount,
    required this.onAmountChanged,
    super.key,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final sliderColor =
        friend.sliderColor ?? BillSplitterColors.defaultSliderColors[0];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              FriendAvatar(
                friend: friend,
                size: 40,
                showName: false,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCurrentUser ? 'Me' : friend.name,
                  style: const TextStyle(
                    color: BillSplitterColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: BillSplitterColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SplitSlider(
            value: amount,
            min: 0,
            max: maxAmount,
            activeColor: sliderColor,
            onChanged: onAmountChanged,
          ),
        ],
      ),
    );
  }
}
