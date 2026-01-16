import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bloc/bloc.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/widgets/widgets.dart';

class SplitDetailsScreen extends StatelessWidget {
  static const id = '/bill-splitter/split';

  const SplitDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BillSplitterColors.background,
      appBar: AppBar(
        backgroundColor: BillSplitterColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: BillSplitterColors.textPrimary,
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Split Now',
          style: TextStyle(
            color: BillSplitterColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: BillSplitterColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<BillSplitterBloc, BillSplitterState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 8),
              _buildReceiptTab(),
              const SizedBox(height: 16),
              ReceiptCard(
                title: state.billTitle,
                totalAmount: state.totalBill,
                participants: state.allParticipants,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _buildParticipantsList(context, state),
              ),
              _buildActionButtons(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReceiptTab() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: BillSplitterColors.cardDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Receipt',
          style: TextStyle(
            color: BillSplitterColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsList(BuildContext context, BillSplitterState state) {
    final participants = state.allParticipants;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: participants.length,
      separatorBuilder: (context, index) => Divider(
        color: BillSplitterColors.cardDark.withValues(alpha: 0.5),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final participant = participants[index];
        final amount = state.splitAmounts[participant.id] ?? 0.0;
        final isCurrentUser = participant.id == state.currentUser.id;

        return SplitParticipantRow(
          friend: participant,
          amount: amount,
          maxAmount: state.totalBill,
          isCurrentUser: isCurrentUser,
          onAmountChanged: (newAmount) {
            context.read<BillSplitterBloc>().add(
              UpdateSplitAmountEvent(
                friendId: participant.id,
                amount: newAmount,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, BillSplitterState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: state.isValidSplit
                  ? () {
                      context.read<BillSplitterBloc>().add(
                        const ConfirmSplitEvent(),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Split confirmed!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: BillSplitterColors.accent,
                foregroundColor: BillSplitterColors.textPrimary,
                disabledBackgroundColor: BillSplitterColors.cardDark.withValues(
                  alpha: 0.5,
                ),
                disabledForegroundColor: BillSplitterColors.textSecondary
                    .withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Confirm Split',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: BillSplitterColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
