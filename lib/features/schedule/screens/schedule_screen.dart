import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/schedule/bloc/bloc.dart';
import 'package:flutter_ui_prototyping/features/schedule/schedule_colors.dart';
import 'package:flutter_ui_prototyping/features/schedule/widgets/widgets.dart';

class ScheduleScreen extends StatelessWidget {
  static const id = '/schedule';

  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleBloc()..add(const ScheduleStarted()),
      child: const _ScheduleView(),
    );
  }
}

class _ScheduleView extends StatefulWidget {
  const _ScheduleView();

  @override
  State<_ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<_ScheduleView>
    with TickerProviderStateMixin {
  late final AnimationController _titleController;
  late final AnimationController _tasksController;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<double> _tasksFadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<Offset> _tasksSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Title animation
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _titleFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
    );
    _titleSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
        );

    // Tasks animation (starts after title)
    _tasksController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _tasksFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _tasksController, curve: Curves.easeOut),
    );
    _tasksSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _tasksController, curve: Curves.easeOut),
        );

    // Start animations
    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _tasksController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tasksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScheduleColors.background,
      body: SafeArea(
        child: BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state.selectedTask != null) {
              _showTaskDetailSheet(context, state);
            }
          },
          builder: (context, state) {
            if (state.status == ScheduleStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                // App bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                          color: ScheduleColors.textPrimary,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.person_outline),
                          color: ScheduleColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),

                // Animated Header
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _titleFadeAnimation,
                    child: SlideTransition(
                      position: _titleSlideAnimation,
                      child: const _HeaderSection(),
                    ),
                  ),
                ),

                // Date selector
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _titleFadeAnimation,
                    child: DateSelector(
                      selectedDate: state.selectedDate ?? DateTime.now(),
                      onDateSelected: (date) {
                        context.read<ScheduleBloc>().add(
                          ScheduleDateSelected(date),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Animated Daily tasks section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _tasksFadeAnimation,
                    child: SlideTransition(
                      position: _tasksSlideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Daily tasks',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ScheduleColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TimelineTaskList(
                            tasks: state.filteredTasks,
                            onTaskTap: (task) {
                              context.read<ScheduleBloc>().add(
                                ScheduleTaskSelected(task),
                              );
                            },
                            onTaskOptionsTap: (task) {
                              context.read<ScheduleBloc>().add(
                                ScheduleTaskSelected(task),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new task
        },
        backgroundColor: ScheduleColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showTaskDetailSheet(BuildContext context, ScheduleState state) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<ScheduleBloc>(),
          child: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state.selectedTask == null) {
                return const SizedBox.shrink();
              }

              return TaskDetailSheet(
                task: state.selectedTask!,
                categories: state.categories,
                members: state.members,
                onDone: () => Navigator.pop(context),
                onCategoryToggle: (categoryId) {
                  context.read<ScheduleBloc>().add(
                    ScheduleCategoryToggled(categoryId),
                  );
                },
                onAddCategory: () {
                  // TODO: Add category
                },
                onAddMember: () {
                  // TODO: Add member
                },
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      if (context.mounted) {
        context.read<ScheduleBloc>().add(const ScheduleTaskSheetDismissed());
      }
    });
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final currentMonth = months[DateTime.now().month - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Welcome back, Martin!',
                style: TextStyle(
                  fontSize: 14,
                  color: ScheduleColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ScheduleColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentMonth,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ScheduleColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: ScheduleColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Schedule',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ScheduleColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
