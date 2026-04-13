import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocListener<WorkoutHistoryBloc, WorkoutHistoryState>(
        listener: (context, state) {
          if (state is WorkoutHistoryLoaded) {
            context.read<PersonalRecordsBloc>().add(
              const LoadPersonalRecords(),
            );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: const [_HistoryTab(), _PersonalRecordsTab()],
        ),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutHistoryBloc, WorkoutHistoryState>(
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

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => SessionCard(session: sessions[i]),
        );
      },
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

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => PersonalRecordCard(pr: records[i]),
          );
        }

        return const SizedBox();
      },
    );
  }
}
