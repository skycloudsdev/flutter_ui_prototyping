import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/models/models.dart';

// Current user
final kCurrentUser = Friend(
  id: 'me',
  name: 'Sajon',
  avatarColor: BillSplitterColors.avatarColors[0],
  sliderColor: BillSplitterColors.sliderOrange,
);

// Dummy friends data
final kDummyFriends = [
  Friend(
    id: '1',
    name: 'Cody',
    avatarColor: BillSplitterColors.avatarColors[1],
    sliderColor: BillSplitterColors.sliderPurple,
  ),
  Friend(
    id: '2',
    name: 'Khalifa',
    avatarColor: BillSplitterColors.avatarColors[2],
    sliderColor: BillSplitterColors.sliderYellow,
  ),
  Friend(
    id: '3',
    name: 'Lisa',
    avatarColor: BillSplitterColors.avatarColors[3],
    sliderColor: BillSplitterColors.sliderTeal,
  ),
  Friend(
    id: '4',
    name: 'Sing',
    avatarColor: BillSplitterColors.avatarColors[4],
  ),
  Friend(
    id: '5',
    name: 'Alex',
    avatarColor: BillSplitterColors.avatarColors[5],
  ),
  Friend(
    id: '6',
    name: 'Brain',
    avatarColor: BillSplitterColors.avatarColors[6],
  ),
  Friend(
    id: '7',
    name: 'Mike',
    avatarColor: BillSplitterColors.avatarColors[7],
  ),
];

// Dummy bill
final kDummyBill = Bill(
  id: 'bill_1',
  title: 'Team Dinner',
  totalAmount: 750.86,
  createdAt: DateTime.now(),
);

const kPreviousSplitAmount = 678.56;
