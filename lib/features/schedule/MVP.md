# Task Scheduler UI - MVP Implementation Plan

## 1. Overview

A task scheduling and planning interface that displays daily tasks in a timeline format with a horizontal date picker. Users can view their schedule at a glance and interact with task details through a modal bottom sheet for editing task properties like categories, team members, and deadlines.

**Core Objective**: Provide an intuitive daily task management experience with visual timeline representation and quick task editing capabilities.

---

## 2. Technical Approach

### 2.1 State Management (BLoC Pattern)

This feature requires BLoC for managing:

- Selected date state
- Task list filtering by date
- Task creation/editing state
- Modal visibility state

```
lib/features/schedule/
├── bloc/
│   ├── schedule_bloc.dart
│   ├── schedule_event.dart
│   └── schedule_state.dart
├── models/
│   ├── task.dart
│   ├── category.dart
│   └── member.dart
├── screens/
│   └── schedule_screen.dart
├── widgets/
│   ├── date_selector.dart
│   ├── timeline_task_list.dart
│   ├── task_card.dart
│   ├── task_detail_sheet.dart
│   ├── category_chip.dart
│   └── member_avatar.dart
└── schedule.dart (barrel export)
```

### 2.2 Widget Tree Structure

```
ScheduleScreen
├── AppBar (custom with menu + profile icons)
├── Header
│   ├── Greeting Text ("Welcome back, Martin!")
│   ├── Title ("Schedule")
│   └── Month Dropdown ("June ▼")
├── DateSelector (horizontal scrollable)
│   ├── DateItem (selected: Wed 10)
│   ├── DateItem (Thu 11)
│   ├── DateItem (Fri 12)
│   ├── DateItem (Sat 13)
│   └── NavigationArrow (>>>)
├── SectionTitle ("Daily tasks")
├── TimelineTaskList
│   ├── TimelineRow (8:00)
│   │   └── TaskCard
│   ├── TimelineRow (9:00)
│   │   └── TaskCard
│   └── ... more rows
└── FloatingActionButton (+)

TaskDetailSheet (Modal Bottom Sheet)
├── Header
│   ├── TaskNameField
│   └── DoneButton
├── CategoriesSection
│   ├── CategoryChip (Design - selected)
│   ├── CategoryChip (Frontend)
│   └── AddCategoryButton (+)
├── MembersSection
│   ├── MemberAvatar (multiple)
│   └── AddMemberButton (+)
└── DeadlineSection
    ├── DateTimePicker
    └── NoDeadlineOption
```

### 2.3 Rendering Strategy

| Component      | Widget Choice                     | Rationale                                            |
| -------------- | --------------------------------- | ---------------------------------------------------- |
| Date Selector  | `ListView.builder` (horizontal)   | Smooth horizontal scrolling, lazy loading            |
| Timeline List  | `CustomScrollView` + `SliverList` | Performance with many tasks, sticky headers possible |
| Task Cards     | `Card` with `InkWell`             | Material ripple, elevation support                   |
| Task Modal     | `showModalBottomSheet`            | Native feel, gesture dismissible                     |
| Member Avatars | `CircleAvatar` + `Wrap`           | Flexible grid layout                                 |
| Category Chips | `Chip` / `ChoiceChip`             | Built-in selection states                            |

### 2.4 Performance Optimizations

1. **Const constructors** for all stateless components
2. **RepaintBoundary** around TaskCards to isolate repaints
3. **Lazy loading** for timeline items outside viewport
4. **Cached network images** for member avatars (use placeholder for MVP)
5. **Keys** on list items for efficient diffing

### 2.5 UI/UX Analysis

#### Design Patterns Identified

- **Timeline Layout**: Vertical time slots with task cards aligned
- **Horizontal Date Picker**: Week-at-a-glance navigation
- **Modal Bottom Sheet**: Non-destructive editing context
- **Color-coded Categories**: Visual task categorization
- **Avatar Groups**: Team collaboration visibility

#### Potential User Pain Points

| Pain Point                      | Mitigation                                 |
| ------------------------------- | ------------------------------------------ |
| Scrolling fatigue on long days  | Add "jump to current time" FAB action      |
| Overlapping tasks not visible   | Show task count badge, expandable slots    |
| Small tap targets on date items | Minimum 48dp touch target                  |
| Modal covers important context  | Use 60% height sheet, allow drag to expand |
| No empty state feedback         | Add illustration for days with no tasks    |

---

## 3. MVP Features

### 3.1 Essential Widgets & Screens

#### Screen 1: Schedule Screen

- [x] Custom app bar with menu and profile icons
- [x] Greeting header with user name
- [x] Month dropdown (visual only for MVP)
- [x] Horizontal date selector with selection state
- [x] "Daily tasks" section header
- [x] Timeline view with hour markers (8:00 - 12:00+)
- [x] Task cards with:
  - Category label (e.g., "Design meeting", "Development")
  - Task title
  - Visual indicator (colored left border)
  - Options menu button (•••)
- [x] Special task types (e.g., "Lunch break" - different style)
- [x] Floating Action Button for adding tasks

#### Screen 2: Task Detail Bottom Sheet

- [x] Task name input field
- [x] "Done" action button
- [x] Categories section with selectable chips
- [x] Add category button (+)
- [x] Members section with avatar grid
- [x] Add member button (+)
- [x] Deadline picker with date/time
- [x] "No deadline" toggle option

### 3.2 Data Models

```dart
// Task categories
enum TaskType { design, development, meeting, mentoring, personal }

// Task model
class Task {
  final String id;
  final String title;
  final String? subtitle;
  final TaskType type;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> categoryIds;
  final List<String> memberIds;
  final DateTime? deadline;
  final bool isCompleted;
}

// Category model
class Category {
  final String id;
  final String name;
  final Color color;
  final bool isSelected;
}

// Member model
class Member {
  final String id;
  final String name;
  final String avatarUrl;
}
```

### 3.3 Dummy Data

```dart
// Sample tasks for MVP
final dummyTasks = [
  Task(
    id: '1',
    title: 'UI Strategy',
    subtitle: 'Design meeting',
    type: TaskType.design,
    startTime: DateTime(2026, 6, 10, 8, 0),
  ),
  Task(
    id: '2',
    title: 'Deploy PWA',
    subtitle: 'Development',
    type: TaskType.development,
    startTime: DateTime(2026, 6, 10, 9, 0),
  ),
  Task(
    id: '3',
    title: 'Lunch break',
    type: TaskType.personal,
    startTime: DateTime(2026, 6, 10, 10, 0),
  ),
  Task(
    id: '4',
    title: 'Financial plan',
    subtitle: 'Company meeting',
    type: TaskType.meeting,
    startTime: DateTime(2026, 6, 10, 11, 0),
  ),
  Task(
    id: '5',
    title: 'Onboarding a...',
    subtitle: 'Mentoring',
    type: TaskType.mentoring,
    startTime: DateTime(2026, 6, 10, 12, 0),
  ),
];

// Sample categories
final dummyCategories = [
  Category(id: '1', name: 'Design', color: Color(0xFF4B5EFC), isSelected: true),
  Category(id: '2', name: 'Frontend', color: Color(0xFF6B7280), isSelected: false),
];

// Sample members (use placeholder avatars)
final dummyMembers = List.generate(6, (i) => Member(
  id: '$i',
  name: 'Member $i',
  avatarUrl: 'https://i.pravatar.cc/150?img=$i',
));
```

### 3.4 Color Palette

```dart
abstract class ScheduleColors {
  // Primary
  static const primary = Color(0xFF4B5EFC);       // Blue (selected date, buttons)
  static const primaryLight = Color(0xFFE8EBFF);  // Light blue background

  // Task type colors
  static const design = Color(0xFF4B5EFC);        // Blue
  static const development = Color(0xFF8B5CF6);   // Purple
  static const meeting = Color(0xFF6366F1);       // Indigo
  static const mentoring = Color(0xFF3B82F6);     // Blue
  static const personal = Color(0xFFF3F4F6);      // Gray (lunch break)

  // Neutrals
  static const background = Color(0xFFF8F9FE);    // Off-white background
  static const cardBackground = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
}
```

### 3.5 Possible Concerns

| Concern                         | Notes                                                       |
| ------------------------------- | ----------------------------------------------------------- |
| **Time zone handling**          | Use local time for MVP; consider UTC for production         |
| **Task duration/overlap**       | MVP shows single-slot tasks; future: duration-based heights |
| **Scroll position restoration** | Save scroll position in BLoC state                          |
| **Keyboard overlap on modal**   | Use `resizeToAvoidBottomInset` + scroll                     |
| **Date picker localization**    | Use `intl` package for proper date formatting               |
| **Avatar loading states**       | Add shimmer placeholder while loading                       |

---

## 4. Implementation Order

1. **Phase 1 - Static UI**

   - [ ] Create folder structure and barrel exports
   - [ ] Build ScheduleScreen with hardcoded data
   - [ ] Implement DateSelector widget
   - [ ] Implement TimelineTaskList and TaskCard widgets
   - [ ] Style according to design specs

2. **Phase 2 - Task Detail Sheet**

   - [ ] Create TaskDetailSheet modal
   - [ ] Build CategoryChip and MemberAvatar widgets
   - [ ] Implement deadline picker section
   - [ ] Wire up FAB to show modal

3. **Phase 3 - State Management**

   - [ ] Create ScheduleBloc with events/states
   - [ ] Connect date selection to task filtering
   - [ ] Handle task editing in modal
   - [ ] Add loading/error states

4. **Phase 4 - Polish**
   - [ ] Add animations (page transitions, modal entry)
   - [ ] Implement empty states
   - [ ] Add haptic feedback on interactions
   - [ ] Test on multiple screen sizes

---

## 5. Route Registration

Add to `home_screen.dart`:

```dart
(name: 'Schedule', route: '/schedule'),
```

Add to `router.dart`:

```dart
ScheduleScreen.id: (_) => const ScheduleScreen(),
```
