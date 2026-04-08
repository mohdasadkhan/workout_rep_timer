import 'dart:developer';

import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_event.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/workout_session.dart';

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
    // _tabController.addListener(() {
    //   if (_tabController.index == 0) {
    context.read<WorkoutHistoryBloc>().add(const LoadWorkoutHistory());
    // } else {
    context.read<PersonalRecordsBloc>().add(const LoadPersonalRecords());
    // }
    // });
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
      body: BlocBuilder<WorkoutHistoryBloc, WorkoutHistoryState>(
        // React to all relevant states
        buildWhen: (previous, current) =>
            current is WorkoutHistoryLoading || current is WorkoutHistoryLoaded,
        builder: (context, state) {
          if (state is WorkoutHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkoutHistoryError) {
            return Center(child: Text(state.message));
          }

          return TabBarView(
            controller: _tabController,
            children: const [_HistoryTab(), _PersonalRecordsTab()],
          );
        },
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkoutHistoryBloc,
      WorkoutHistoryState,
      List<WorkoutSession>
    >(
      selector: (state) {
        if (state is WorkoutHistoryLoaded) {
          return state.sessions;
        }
        return const []; // fallback only when not in Loaded state
      },
      builder: (context, sessions) {
        log('session inside bloc selector >> ${sessions.length} items');

        if (sessions.isEmpty) {
          return const _EmptyState(
            icon: Icons.history,
            message: 'No workouts yet.\nFinish a session to see it here.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _SessionCard(session: sessions[i]),
        );
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  final WorkoutSession session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE, d MMM yyyy').format(session.date);
    final timeStr = DateFormat('HH:mm').format(session.date);

    return Card(
      child: ExpansionTile(
        title: Text(
          dateStr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '$timeStr · ${session.exercises.length} exercises · '
          '${session.totalSets} sets · '
          '${session.totalVolume.toStringAsFixed(0)} kg',
        ),
        children: session.exercises.map((ex) {
          return ListTile(
            dense: true,
            title: Text(ex.name),
            subtitle: Text(
              ex.sets
                  .asMap()
                  .entries
                  .map(
                    (e) =>
                        'Set ${e.key + 1}: ${e.value.weightKg}kg × ${e.value.reps}',
                  )
                  .join('  ·  '),
              style: const TextStyle(fontSize: 12),
            ),
            trailing: ex.bestSet != null
                ? Chip(
                    label: Text(
                      'Best: ${ex.bestSet!.weightKg}kg',
                      style: const TextStyle(fontSize: 11),
                    ),
                    padding: EdgeInsets.zero,
                  )
                : null,
          );
        }).toList(),
      ),
    );
  }
}

class _PersonalRecordsTab extends StatelessWidget {
  const _PersonalRecordsTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      PersonalRecordsBloc,
      PersonalRecordsState,
      List<dynamic>
    >(
      selector: (state) => state is PersonalRecordsLoaded ? state.records : [],
      builder: (context, records) {
        if (records.isEmpty) {
          return const _EmptyState(
            icon: Icons.emoji_events,
            message: 'No PRs yet.\nLog some heavy sets to set records!',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final pr = records[i];
            return ListTile(
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: Text(
                pr.exerciseName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Achieved ${DateFormat('d MMM yyyy').format(pr.achievedAt)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${pr.bestWeightKg} kg',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '× ${pr.repsAtBestWeight} reps',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
