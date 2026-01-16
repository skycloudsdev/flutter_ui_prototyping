import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_data.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bloc/bill_splitter_event_state.dart';

class BillSplitterBloc extends Bloc<BillSplitterEvent, BillSplitterState> {
  BillSplitterBloc()
    : super(
        BillSplitterState(
          totalBill: kDummyBill.totalAmount,
          billTitle: kDummyBill.title,
          availableFriends: kDummyFriends,
          selectedFriends: const [],
          splitAmounts: const {},
          previousSplit: kPreviousSplitAmount,
          isLoading: false,
          currentUser: kCurrentUser,
        ),
      ) {
    on<LoadFriendsEvent>(_onLoadFriends);
    on<SelectFriendEvent>(_onSelectFriend);
    on<DeselectFriendEvent>(_onDeselectFriend);
    on<UpdateBillAmountEvent>(_onUpdateBillAmount);
    on<UpdateBillTitleEvent>(_onUpdateBillTitle);
    on<UpdateSplitAmountEvent>(_onUpdateSplitAmount);
    on<InitializeSplitEvent>(_onInitializeSplit);
    on<ConfirmSplitEvent>(_onConfirmSplit);
  }

  void _onLoadFriends(
    LoadFriendsEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    emit(state.copyWith(availableFriends: kDummyFriends));
  }

  void _onSelectFriend(
    SelectFriendEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    if (state.selectedFriends.contains(event.friend)) return;

    final updatedSelected = [...state.selectedFriends, event.friend];
    emit(state.copyWith(selectedFriends: updatedSelected));
  }

  void _onDeselectFriend(
    DeselectFriendEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    final updatedSelected = state.selectedFriends
        .where((f) => f.id != event.friend.id)
        .toList();
    final updatedAmounts = Map<String, double>.from(state.splitAmounts)
      ..remove(event.friend.id);

    emit(
      state.copyWith(
        selectedFriends: updatedSelected,
        splitAmounts: updatedAmounts,
      ),
    );
  }

  void _onUpdateBillAmount(
    UpdateBillAmountEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    emit(state.copyWith(totalBill: event.amount));
  }

  void _onUpdateBillTitle(
    UpdateBillTitleEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    emit(state.copyWith(billTitle: event.title));
  }

  void _onInitializeSplit(
    InitializeSplitEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    final participants = state.allParticipants;
    if (participants.isEmpty) return;

    final equalShare = state.totalBill / participants.length;
    final baseAmount = _roundToTwoDecimals(equalShare);

    final newSplitAmounts = <String, double>{};
    var allocatedTotal = 0.0;

    // Assign base amount to all except the first participant
    for (var i = 1; i < participants.length; i++) {
      newSplitAmounts[participants[i].id] = baseAmount;
      allocatedTotal += baseAmount;
    }

    // First participant (current user) gets the remainder
    final remainder = _roundToTwoDecimals(state.totalBill - allocatedTotal);
    newSplitAmounts[participants[0].id] = remainder;

    emit(state.copyWith(splitAmounts: newSplitAmounts));
  }

  void _onUpdateSplitAmount(
    UpdateSplitAmountEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    final participants = state.allParticipants;
    if (participants.length < 2) return;

    final newAmount = _roundToTwoDecimals(event.amount);
    final oldAmount = state.splitAmounts[event.friendId] ?? 0;
    final difference = newAmount - oldAmount;

    if (difference.abs() < 0.01) return;

    final newSplitAmounts = Map<String, double>.from(state.splitAmounts);
    newSplitAmounts[event.friendId] = newAmount;

    // Get other participants to adjust
    final othersToAdjust = participants
        .where((p) => p.id != event.friendId)
        .toList();

    if (othersToAdjust.isEmpty) return;

    // Calculate total amount currently allocated to others
    final othersTotal = othersToAdjust.fold<double>(
      0,
      (sum, p) => sum + (newSplitAmounts[p.id] ?? 0),
    );

    // New target for others
    final newOthersTotal = state.totalBill - newAmount;

    if (newOthersTotal < 0) {
      // Can't adjust, revert
      return;
    }

    // Distribute proportionally
    if (othersTotal > 0) {
      var distributed = 0.0;
      for (var i = 0; i < othersToAdjust.length; i++) {
        final participant = othersToAdjust[i];
        final currentAmount = newSplitAmounts[participant.id] ?? 0;
        final proportion = currentAmount / othersTotal;

        if (i == othersToAdjust.length - 1) {
          // Last one gets the remainder to ensure total matches
          final remainder = newOthersTotal - distributed;
          newSplitAmounts[participant.id] = _roundToTwoDecimals(remainder);
        } else {
          final adjusted = newOthersTotal * proportion;
          final adjustedAmount = _roundToTwoDecimals(adjusted);
          newSplitAmounts[participant.id] = adjustedAmount;
          distributed += adjustedAmount;
        }
      }
    } else {
      // Equal distribution if no previous amounts
      final equalShare = newOthersTotal / othersToAdjust.length;
      var distributed = 0.0;
      for (var i = 0; i < othersToAdjust.length; i++) {
        final participant = othersToAdjust[i];
        if (i == othersToAdjust.length - 1) {
          final remainder = newOthersTotal - distributed;
          newSplitAmounts[participant.id] = _roundToTwoDecimals(remainder);
        } else {
          final amount = _roundToTwoDecimals(equalShare);
          newSplitAmounts[participant.id] = amount;
          distributed += amount;
        }
      }
    }

    // Ensure no negative amounts
    for (final entry in newSplitAmounts.entries) {
      if (entry.value < 0) {
        newSplitAmounts[entry.key] = 0;
      }
    }

    emit(state.copyWith(splitAmounts: newSplitAmounts));
  }

  void _onConfirmSplit(
    ConfirmSplitEvent event,
    Emitter<BillSplitterState> emit,
  ) {
    // For MVP, just reset the state
    emit(
      state.copyWith(
        selectedFriends: const [],
        splitAmounts: const {},
        previousSplit: state.totalBill,
      ),
    );
  }

  double _roundToTwoDecimals(double value) {
    return (value * 100).roundToDouble() / 100;
  }
}
