import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/workout_session.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';

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

    context.read<WorkoutBloc>()
      ..add(const LoadWorkoutHistory())
      ..add(const LoadPersonalRecords());
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

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      buildWhen: (_, current) =>
          current is WorkoutLoading ||
          current is WorkoutHistoryLoaded ||
          current is WorkoutError,
      builder: (context, state) {
        if (state is WorkoutLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is WorkoutHistoryLoaded) {
          if (state.sessions.isEmpty) {
            return const _EmptyState(
              icon: Icons.history,
              message: 'No workouts yet.\nFinish a session to see it here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _SessionCard(session: state.sessions[i]),
          );
        }
        if (state is WorkoutError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
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
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      buildWhen: (_, current) =>
          current is WorkoutLoading ||
          current is PersonalRecordsLoaded ||
          current is WorkoutError,
      builder: (context, state) {
        if (state is WorkoutLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PersonalRecordsLoaded) {
          if (state.records.isEmpty) {
            return const _EmptyState(
              icon: Icons.emoji_events,
              message: 'No PRs yet.\nLog some heavy sets to set records!',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final pr = state.records[i];
              return ListTile(
                tileColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
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
        }
        if (state is WorkoutError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
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
