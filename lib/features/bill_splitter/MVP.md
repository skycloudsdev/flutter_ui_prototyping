# Bill Splitter - MVP Implementation Plan

## 1. Overview

A sleek bill splitting application UI featuring a dark purple/navy theme with warm accent colors. The design consists of two main screens: a **Home Dashboard** for initiating splits and viewing history, and a **Split Details Screen** for adjusting individual contribution amounts using interactive sliders.

**Core Objective**: Enable users to split bills among friends with an intuitive visual interface that shows real-time contribution adjustments.

---

## 2. Technical Approach

### 2.1 State Management (BLoC Pattern)

The feature requires BLoC for managing:

- Selected friends for splitting
- Individual split amounts (slider values)
- Total bill validation (sum must equal total)

```
bill_splitter/
├── bloc/
│   ├── bill_splitter_bloc.dart
│   ├── bill_splitter_event.dart
│   └── bill_splitter_state.dart
├── models/
│   ├── friend.dart
│   ├── bill.dart
│   └── split_entry.dart
├── screens/
│   ├── bill_splitter_home_screen.dart
│   └── split_details_screen.dart
├── widgets/
│   ├── total_bill_card.dart
│   ├── friend_avatar.dart
│   ├── friend_selector.dart
│   ├── nearby_friends_section.dart
│   ├── recently_split_section.dart
│   ├── receipt_card.dart
│   ├── split_slider.dart
│   └── split_participant_row.dart
└── bill_splitter.dart (barrel export)
```

### 2.2 Rendering Strategy

| Component  | Widget Approach                                                      |
| ---------- | -------------------------------------------------------------------- |
| Background | `Container` with gradient or solid dark purple (#3D3A5C / #4A4872)   |
| Cards      | `Container` with `BoxDecoration`, `borderRadius`, and subtle shadows |
| Avatars    | `CircleAvatar` with `ClipOval` for profile images                    |
| Sliders    | Custom `SliderTheme` with gradient track and circular thumb          |
| Buttons    | `ElevatedButton` / `TextButton` with rounded corners                 |

### 2.3 Performance Optimizations

- Use `const` constructors for static widgets
- Implement `ListView.builder` for friend lists
- Cache avatar images with `CachedNetworkImage` or use local assets for MVP
- Debounce slider value changes to prevent excessive rebuilds
- Use `BlocSelector` to rebuild only affected widgets

### 2.4 UI/UX Analysis

**Design Patterns Identified:**

- **Card-based layout**: Information grouped in rounded containers
- **Visual hierarchy**: Large currency values, medium titles, small labels
- **Color coding**: Each participant has a unique slider color (orange, purple, yellow)
- **Affordances**: Clear tap targets with "Split Now", "Confirm Split" buttons

**Potential User Pain Points:**
| Pain Point | Solution |
|------------|----------|
| Slider precision for exact amounts | Add tap-to-edit input field on amount |
| Ensuring split totals match bill | Display remaining/overage amount in real-time |
| Unclear selected friends state | Visual feedback with checkmarks or elevation changes |
| Small touch targets for avatars | Minimum 48px touch area per Material guidelines |

---

## 3. MVP Features

### 3.1 Essential Widgets & Screens

#### Screen 1: Bill Splitter Home (`/bill-splitter`)

```
┌─────────────────────────────────────┐
│  Orix                        [Avatar]│
│  Bill Spliter                  Sajon │
├─────────────────────────────────────┤
│ ┌─────────────────┐  ┌─────────────┐│
│ │ Total Bill      │  │ Split with  ││
│ │ $750.86         │  │ [👤][👤][👤]││
│ │ [Split Now]     │  │     [+]     ││
│ └─────────────────┘  └─────────────┘│
├─────────────────────────────────────┤
│ ⏱ Your previous split              │
│   $678.56                           │
├─────────────────────────────────────┤
│ 🔍  Nearby Friends        See all > │
│     [👤Cody] [👤Khalifa] [👤Lisa]   │
├─────────────────────────────────────┤
│ Recently Split                      │
│ [👤Sing] [👤Alex] [👤Brain] [👤Mike]│
└─────────────────────────────────────┘
```

**Components:**

- `BillSplitterHomeScreen` - Main scaffold with dark theme
- `TotalBillCard` - Displays amount + "Split Now" button
- `FriendSelector` - Vertical list of selected friends with add button
- `NearbyFriendsSection` - Horizontal scrollable friend chips
- `RecentlySplitSection` - Horizontal scrollable avatar row
- `FriendAvatar` - Reusable avatar with name label

#### Screen 2: Split Details (`/bill-splitter/split`)

```
┌─────────────────────────────────────┐
│  <  Split Now                    ⋮  │
├─────────────────────────────────────┤
│           [ Recept ]                │
│  ┌───────────────────────────────┐  │
│  │ Title           Total Bill   │  │
│  │ Team Dinner     $750.86      │  │
│  │      [👤][👤][👤]            │  │
│  │      Splitting With          │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│  👤 Me                    $200.86   │
│  ●───────●───────○───────○───────○  │
├─────────────────────────────────────┤
│  👤 Cody                  $450      │
│  ○───────○───────●───────○───────○  │
├─────────────────────────────────────┤
│  👤 Khalifa               $100      │
│  ○───────●───────○───────○───────○  │
├─────────────────────────────────────┤
│  [Confirm Split]        Cancel      │
└─────────────────────────────────────┘
```

**Components:**

- `SplitDetailsScreen` - Split configuration screen
- `ReceiptCard` - Bill summary with title, total, and participants
- `SplitParticipantRow` - Avatar + name + amount + slider
- `SplitSlider` - Custom styled slider with color-coded track
- Action buttons row

### 3.2 Data Models

```dart
// friend.dart
class Friend {
  final String id;
  final String name;
  final String avatarUrl;
  final Color? sliderColor; // For personalized slider

  const Friend({...});
}

// bill.dart
class Bill {
  final String id;
  final String title;
  final double totalAmount;
  final DateTime createdAt;

  const Bill({...});
}

// split_entry.dart
class SplitEntry {
  final Friend friend;
  final double amount;
  final double percentage;

  const SplitEntry({...});
}
```

### 3.3 BLoC Events & States

```dart
// Events
sealed class BillSplitterEvent {}
class LoadFriends extends BillSplitterEvent {}
class SelectFriend extends BillSplitterEvent { final Friend friend; }
class DeselectFriend extends BillSplitterEvent { final Friend friend; }
class UpdateBillAmount extends BillSplitterEvent { final double amount; }
class UpdateBillTitle extends BillSplitterEvent { final String title; }
class UpdateSplitAmount extends BillSplitterEvent {
  final String friendId;
  final double amount;
}
class ConfirmSplit extends BillSplitterEvent {}

// State
class BillSplitterState {
  final double totalBill;
  final String billTitle;
  final List<Friend> availableFriends;
  final List<Friend> selectedFriends;
  final Map<String, double> splitAmounts;
  final double previousSplit;
  final bool isLoading;
  final String? errorMessage;

  double get remainingAmount => totalBill - splitAmounts.values.sum;
  bool get isValidSplit => remainingAmount == 0;
}
```

### 3.4 Dummy Data

```dart
// Mock data for MVP
const kDummyFriends = [
  Friend(id: '1', name: 'Cody', avatarUrl: 'assets/avatars/cody.png', sliderColor: Color(0xFF9B8CD6)),
  Friend(id: '2', name: 'Khalifa', avatarUrl: 'assets/avatars/khalifa.png', sliderColor: Color(0xFFE8B86D)),
  Friend(id: '3', name: 'Lisa', avatarUrl: 'assets/avatars/lisa.png', sliderColor: Color(0xFF7ECEC6)),
  Friend(id: '4', name: 'Sing', avatarUrl: 'assets/avatars/sing.png'),
  Friend(id: '5', name: 'Alex', avatarUrl: 'assets/avatars/alex.png'),
  Friend(id: '6', name: 'Brain', avatarUrl: 'assets/avatars/brain.png'),
  Friend(id: '7', name: 'Mike', avatarUrl: 'assets/avatars/mike.png'),
];

const kCurrentUser = Friend(
  id: 'me',
  name: 'Sajon',
  avatarUrl: 'assets/avatars/sajon.png',
  sliderColor: Color(0xFFE8956D), // Orange
);

const kDummyBill = Bill(
  id: 'bill_1',
  title: 'Team Dinner',
  totalAmount: 750.86,
  createdAt: DateTime.now(),
);

const kPreviousSplitAmount = 678.56;
```

### 3.5 Theme Constants

```dart
// bill_splitter_theme.dart
abstract class BillSplitterColors {
  static const background = Color(0xFF3D3A5C);
  static const cardDark = Color(0xFF4A4872);
  static const cardLight = Color(0xFFE8D5B5); // Beige/cream for receipt
  static const accent = Color(0xFF6B6398);
  static const buttonPrimary = Color(0xFF4A4872);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0ADC6);

  // Slider colors
  static const sliderOrange = Color(0xFFE8956D);
  static const sliderPurple = Color(0xFF9B8CD6);
  static const sliderYellow = Color(0xFFE8B86D);
}
```

---

## 4. Design Decisions

| Decision         | Choice                                              |
| ---------------- | --------------------------------------------------- |
| Avatar images    | Placeholder colored circles with initials           |
| Slider behavior  | Auto-adjust other sliders to maintain total         |
| Decimal handling | Assign remainder to the first person (current user) |
| Navigation       | "Split Now" navigates to a separate details screen  |

---

## 5. Possible Concerns

| Concern                             | Mitigation                                                       |
| ----------------------------------- | ---------------------------------------------------------------- |
| Slider sync when totals don't match | Auto-adjust other participants proportionally                    |
| Currency formatting differences     | Use `NumberFormat.currency()` from `intl` package                |
| Avatar images for dummy data        | Use colored `CircleAvatar` with initials                         |
| Complex slider customization        | Create custom `SliderThemeData` or use `CustomPainter`           |
| Decimal precision in splits         | Round to 2 decimal places, assign remainder to first participant |

---

## 5. Route Registration

```dart
// In router.dart
BillSplitterHomeScreen.id: (_) => const BillSplitterHomeScreen(),
SplitDetailsScreen.id: (_) => const SplitDetailsScreen(),

// In home_screen.dart games list
(name: 'Bill Splitter', route: '/bill-splitter'),
```

---

## 6. Implementation Priority

1. **Phase 1**: Models + BLoC scaffold + basic home screen layout
2. **Phase 2**: TotalBillCard + FriendSelector widgets
3. **Phase 3**: Split Details screen with sliders
4. **Phase 4**: Polish animations + edge cases
5. **Phase 5**: Testing + refinements
