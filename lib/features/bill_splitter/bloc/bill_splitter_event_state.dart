import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';

sealed class BillSplitterEvent {
  const BillSplitterEvent();
}

class LoadFriendsEvent extends BillSplitterEvent {
  const LoadFriendsEvent();
}

class SelectFriendEvent extends BillSplitterEvent {
  final Friend friend;

  const SelectFriendEvent(this.friend);
}

class DeselectFriendEvent extends BillSplitterEvent {
  final Friend friend;

  const DeselectFriendEvent(this.friend);
}

class UpdateBillAmountEvent extends BillSplitterEvent {
  final double amount;

  const UpdateBillAmountEvent(this.amount);
}

class UpdateBillTitleEvent extends BillSplitterEvent {
  final String title;

  const UpdateBillTitleEvent(this.title);
}

class UpdateSplitAmountEvent extends BillSplitterEvent {
  final String friendId;
  final double amount;

  const UpdateSplitAmountEvent({
    required this.friendId,
    required this.amount,
  });
}

class InitializeSplitEvent extends BillSplitterEvent {
  const InitializeSplitEvent();
}

class ConfirmSplitEvent extends BillSplitterEvent {
  const ConfirmSplitEvent();
}

@immutable
class BillSplitterState {
  final double totalBill;
  final String billTitle;
  final List<Friend> availableFriends;
  final List<Friend> selectedFriends;
  final Map<String, double> splitAmounts;
  final double previousSplit;
  final bool isLoading;
  final String? errorMessage;
  final Friend currentUser;

  const BillSplitterState({
    required this.totalBill,
    required this.billTitle,
    required this.availableFriends,
    required this.selectedFriends,
    required this.splitAmounts,
    required this.previousSplit,
    required this.isLoading,
    required this.currentUser,
    this.errorMessage,
  });

  double get allocatedAmount {
    return splitAmounts.values.fold(0, (sum, amount) => sum + amount);
  }

  double get remainingAmount => totalBill - allocatedAmount;

  bool get isValidSplit => remainingAmount.abs() < 0.01;

  List<Friend> get allParticipants => [currentUser, ...selectedFriends];

  BillSplitterState copyWith({
    double? totalBill,
    String? billTitle,
    List<Friend>? availableFriends,
    List<Friend>? selectedFriends,
    Map<String, double>? splitAmounts,
    double? previousSplit,
    bool? isLoading,
    String? errorMessage,
    Friend? currentUser,
  }) {
    return BillSplitterState(
      totalBill: totalBill ?? this.totalBill,
      billTitle: billTitle ?? this.billTitle,
      availableFriends: availableFriends ?? this.availableFriends,
      selectedFriends: selectedFriends ?? this.selectedFriends,
      splitAmounts: splitAmounts ?? this.splitAmounts,
      previousSplit: previousSplit ?? this.previousSplit,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
