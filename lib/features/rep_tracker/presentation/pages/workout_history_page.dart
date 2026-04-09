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

    // Load data once
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Personal Records'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_HistoryTab(), _PersonalRecordsTab()],
      ),
    );
  }
}

// ── History Tab ─────────────────────────────────────────────────────
class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkoutHistoryBloc,
      WorkoutHistoryState,
      List<WorkoutSession>
    >(
      selector: (state) =>
          state is WorkoutHistoryLoaded ? state.sessions : const [],
      builder: (context, sessions) {
        if (sessions.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            message: 'No workouts yet.\nFinish a session to see it here.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => SessionCard(session: sessions[i]),
        );
      },
    );
  }
}

// ── Personal Records Tab ────────────────────────────────────────────
class _PersonalRecordsTab extends StatelessWidget {
  const _PersonalRecordsTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      PersonalRecordsBloc,
      PersonalRecordsState,
      List<PersonalRecord>
    >(
      selector: (state) =>
          state is PersonalRecordsLoaded ? state.records : const [],
      builder: (context, records) {
        if (records.isEmpty) {
          return const EmptyState(
            icon: Icons.emoji_events,
            message: 'No PRs yet.\nLog some heavy sets to set records!',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => PersonalRecordCard(pr: records[i]),
        );
      },
    );
  }
}
