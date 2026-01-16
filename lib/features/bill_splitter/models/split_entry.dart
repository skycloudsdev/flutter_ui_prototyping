import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/friend.dart';

@immutable
class SplitEntry {
  final Friend friend;
  final double amount;

  const SplitEntry({
    required this.friend,
    required this.amount,
  });

  double percentageOf(double total) {
    if (total == 0) return 0;
    return (amount / total) * 100;
  }

  SplitEntry copyWith({
    Friend? friend,
    double? amount,
  }) {
    return SplitEntry(
      friend: friend ?? this.friend,
      amount: amount ?? this.amount,
    );
  }
}
