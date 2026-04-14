import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../bloc/personal_records_bloc/personal_records_bloc.dart';
import '../bloc/workout_history_bloc/workout_history_bloc.dart';
import '../bloc/workout_history_bloc/workout_history_event.dart';
import '../bloc/workout_history_bloc/workout_history_state.dart';
import '../widgets/history_and_prs_widgets/empty_state.dart';
import '../widgets/history_and_prs_widgets/personal_record_card.dart';
import '../widgets/history_and_prs_widgets/session_card.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({super.key});

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<WorkoutHistoryBloc>().add(const LoadWorkoutHistory());
    context.read<PersonalRecordsBloc>().add(const LoadPersonalRecords());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History & PRs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: AppTextStyles.labelSmall.copyWith(
                fontSize: 12,
                letterSpacing: 0.4,
                color: AppColors.primary,
              ),
              unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
                fontSize: 12,
                letterSpacing: 0.4,
                color: AppColors.textTertiary,
              ),
              tabs: const [
                Tab(text: 'History'),
                Tab(text: 'Personal Records'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_HistoryTab(), _PersonalRecordsTab()],
      ),
    );
  }
}

class _HistoryTab extends StatefulWidget {
  const _HistoryTab();

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutHistoryBloc, WorkoutHistoryState>(
      listenWhen: (prev, curr) => curr is WorkoutHistoryLoaded,
      listener: (context, state) {
        if (state is WorkoutHistoryLoaded) {
          context.read<PersonalRecordsBloc>().add(const LoadPersonalRecords());
        }
      },
      builder: (context, state) {
        if (state is WorkoutHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is WorkoutHistoryError) {
          return Center(
            child: Text(state.message, style: AppTextStyles.bodyMedium),
          );
        }

        final sessions = state is WorkoutHistoryLoaded
            ? state.sessions
            : <WorkoutSession>[];

        if (sessions.isEmpty) {
          return const EmptyState(
            icon: Icons.history_rounded,
            message: 'No workouts yet.\nFinish a session to see it here.',
          );
        }

        return AnimationLimiter(
          child: AnimatedList(
            key: _listKey,
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            initialItemCount: sessions.length,
            itemBuilder: (context, index, animation) {
              final session = sessions[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 450),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: SlideTransition(
                        position: animation.drive(
                          Tween(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutCubic)),
                        ),
                        child: ScaleTransition(
                          scale: animation.drive(
                            Tween(
                              begin: 0.92,
                              end: 1.0,
                            ).chain(CurveTween(curve: Curves.easeOutBack)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SessionCard(
                              session: session,
                              onDelete: () => _removeItem(index, session),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _removeItem(int index, WorkoutSession session) {
    final listState = _listKey.currentState!;
    listState.removeItem(
      index,
      (context, animation) => AnimationConfiguration.staggeredList(
        position: index,
        child: SlideAnimation(
          verticalOffset: 50,
          child: FadeInAnimation(
            child: SizeTransition(
              sizeFactor: animation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SessionCard(session: session),
              ),
            ),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 280),
    );

    context.read<WorkoutHistoryBloc>().add(
      DeleteWorkoutSessionEvent(session: session, sessionId: session.id),
    );

    _showUndoSnackBar(context, session);
  }

  void _showUndoSnackBar(BuildContext context, WorkoutSession session) {
    final bloc = context.read<WorkoutHistoryBloc>();
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1E1E1E),
        content: Row(
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
              size: 22,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Session deleted',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.primary,
          onPressed: () {
            bloc.add(RestoreWorkoutSessionEvent(session));

            _listKey.currentState?.insertItem(0);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
              );
            });
          },
        ),
      ),
    );
  }
}

class _PersonalRecordsTab extends StatelessWidget {
  const _PersonalRecordsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalRecordsBloc, PersonalRecordsState>(
      builder: (context, state) {
        if (state is PersonalRecordLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PersonalRecordsLoaded) {
          final records = state.records;

          if (records.isEmpty) {
            return const EmptyState(
              icon: Icons.emoji_events_rounded,
              message: 'No PRs yet.\nLog some heavy sets to set records!',
            );
          }

          return AnimationLimiter(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 450),
                  child: SlideAnimation(
                    verticalOffset: 40.0,
                    child: FadeInAnimation(
                      child: PersonalRecordCard(pr: records[index]),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
