import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_data.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bloc/bloc.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/screens/split_details_screen.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/widgets.dart';

class BillSplitterHomeScreen extends StatelessWidget {
  static const id = '/bill-splitter';

  const BillSplitterHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BillSplitterBloc(),
      child: const _BillSplitterHomeView(),
    );
  }
}

class _BillSplitterHomeView extends StatelessWidget {
  const _BillSplitterHomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BillSplitterColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildMainCards(context),
              const SizedBox(height: 24),
              _buildPreviousSplit(context),
              const SizedBox(height: 24),
              _buildNearbyFriends(context),
              const SizedBox(height: 24),
              _buildRecentlySplit(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<BillSplitterBloc, BillSplitterState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orix',
                  style: TextStyle(
                    color: BillSplitterColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Bill Splitter',
                  style: TextStyle(
                    color: BillSplitterColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                FriendAvatar(
                  friend: state.currentUser,
                  size: 44,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainCards(BuildContext context) {
    return BlocBuilder<BillSplitterBloc, BillSplitterState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TotalBillCard(
                amount: state.totalBill,
                onSplitNow: () => _navigateToSplit(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FriendSelector(
                selectedFriends: state.selectedFriends,
                onAddFriend: () => _showFriendPicker(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPreviousSplit(BuildContext context) {
    return BlocBuilder<BillSplitterBloc, BillSplitterState>(
      builder: (context, state) {
        return Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: BillSplitterColors.cardDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.history,
                color: BillSplitterColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your previous split',
                  style: TextStyle(
                    color: BillSplitterColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${state.previousSplit.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: BillSplitterColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildNearbyFriends(BuildContext context) {
    return BlocBuilder<BillSplitterBloc, BillSplitterState>(
      builder: (context, state) {
        final nearbyFriends = state.availableFriends.take(3).toList();
        return NearbyFriendsSection(
          friends: nearbyFriends,
          selectedFriends: state.selectedFriends,
          onFriendTap: (friend) {
            final bloc = context.read<BillSplitterBloc>();
            if (state.selectedFriends.contains(friend)) {
              bloc.add(DeselectFriendEvent(friend));
            } else {
              bloc.add(SelectFriendEvent(friend));
            }
          },
          onSeeAll: () => _showFriendPicker(context),
        );
      },
    );
  }

  Widget _buildRecentlySplit(BuildContext context) {
    return BlocBuilder<BillSplitterBloc, BillSplitterState>(
      builder: (context, state) {
        final recentFriends = state.availableFriends.skip(3).take(4).toList();
        return RecentlySplitSection(friends: recentFriends);
      },
    );
  }

  void _navigateToSplit(BuildContext context) {
    final bloc = context.read<BillSplitterBloc>();
    if (bloc.state.selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one friend to split with'),
          backgroundColor: BillSplitterColors.cardDark,
        ),
      );
      return;
    }

    bloc.add(const InitializeSplitEvent());

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const SplitDetailsScreen(),
        ),
      ),
    );
  }

  void _showFriendPicker(BuildContext context) {
    final bloc = context.read<BillSplitterBloc>();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: BillSplitterColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return BlocProvider.value(
          value: bloc,
          child: BlocBuilder<BillSplitterBloc, BillSplitterState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Friends',
                      style: TextStyle(
                        color: BillSplitterColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: kDummyFriends.map((friend) {
                        final isSelected = state.selectedFriends.contains(
                          friend,
                        );
                        return FriendAvatar(
                          friend: friend,
                          size: 56,
                          isSelected: isSelected,
                          onTap: () {
                            if (isSelected) {
                              bloc.add(DeselectFriendEvent(friend));
                            } else {
                              bloc.add(SelectFriendEvent(friend));
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(modalContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BillSplitterColors.accent,
                          foregroundColor: BillSplitterColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Done (${state.selectedFriends.length} selected)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
