import 'package:app_lifecycle/core/widgets/feature_dropdown/extension_on_appfeature.dart';
import 'package:app_lifecycle/core/widgets/feature_dropdown/feature_dropdown.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/exercise_set.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import 'workout_history_page.dart';

class WorkoutSessionPage extends StatelessWidget {
  const WorkoutSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutBloc, WorkoutState>(
      listener: (context, state) {
        if (state is WorkoutSessionSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workout saved! Great session 💪')),
          );
          context.read<WorkoutBloc>().add(const StartWorkoutSession());
        }
        if (state is WorkoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: FeatureDropdownTitle(current: AppFeature.repTracker),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: 'History',
                onPressed: () => context.push('/rep-tracker/history'),
              ),
              if (state is WorkoutSessionActive && state.exercises.isNotEmpty)
                TextButton(
                  onPressed: () => _confirmFinish(context),
                  child: const Text('Finish'),
                ),
            ],
          ),

          body: switch (state) {
            WorkoutInitial() => _BuildStartPrompt(
              onStart: () =>
                  context.read<WorkoutBloc>().add(const StartWorkoutSession()),
            ),
            WorkoutLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            WorkoutSessionActive() => _BuildActiveSession(state: state),
            _ => _BuildStartPrompt(
              onStart: () =>
                  context.read<WorkoutBloc>().add(const StartWorkoutSession()),
            ),
          },
          floatingActionButton: state is WorkoutSessionActive
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddExerciseSheet(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exercise'),
                )
              : null,
        );
      },
    );
  }

  void _confirmFinish(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Finish Workout?'),
        content: const Text('This will save your session to history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<WorkoutBloc>().add(const FinishWorkoutSession());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddExerciseSheet(BuildContext context) {
    final controller = TextEditingController();
    const presets = [
      'Bench Press',
      'Squat',
      'Deadlift',
      'Overhead Press',
      'Pull-up',
      'Barbell Row',
      'Lat Pulldown',
      'Bicep Curl',
      'Tricep Pushdown',
      'Leg Press',
      'Cable Fly',
      'Leg Curl',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Exercise',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Exercise name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.trim().isEmpty) return;
                context.read<WorkoutBloc>().add(
                  AddExercise(exerciseName: value.trim()),
                );
                Navigator.pop(sheetContext);
              },
            ),
            const SizedBox(height: 12),
            Text('Quick pick', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: presets.map((name) {
                return ActionChip(
                  label: Text(name),
                  onPressed: () {
                    context.read<WorkoutBloc>().add(
                      AddExercise(exerciseName: name),
                    );
                    Navigator.pop(sheetContext);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildStartPrompt extends StatelessWidget {
  final VoidCallback onStart;
  const _BuildStartPrompt({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Ready to train?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Start a new session to log your sets.'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Session'),
          ),
        ],
      ),
    );
  }
}

class _BuildActiveSession extends StatelessWidget {
  final WorkoutSessionActive state;
  const _BuildActiveSession({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.exercises.isEmpty) {
      return const Center(
        child: Text('Tap "+ Add Exercise" to begin logging sets.'),
      );
    }

    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(label: 'Exercises', value: '${state.exercises.length}'),
              _StatChip(label: 'Total Sets', value: '${state.totalSets}'),
              _StatChip(
                label: 'Volume',
                value: '${state.totalVolume.toStringAsFixed(0)} kg',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: state.exercises.length,
            itemBuilder: (_, i) => _ExerciseCard(exercise: state.exercises[i]),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final totalReps = exercise.sets.fold(0, (sum, s) => sum + s.reps);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  'Rep Count: $totalReps',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),

            const Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    'Set',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Weight (kg)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Reps',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 32),
              ],
            ),
            const Divider(height: 8),

            ...exercise.sets.asMap().entries.map((entry) {
              final i = entry.key;
              final set = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${set.weightKg} kg',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${set.reps} reps',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        padding: EdgeInsets.zero,
                        onPressed: () => context.read<WorkoutBloc>().add(
                          RemoveSet(exerciseId: exercise.id, setId: set.id),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showLogSetDialog(context, exercise.id),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Log Set'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogSetDialog(BuildContext context, String exerciseId) {
    final weightController = TextEditingController();
    final repsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Log Set — ${exercise.name}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              context.read<WorkoutBloc>().add(
                LogSet(
                  exerciseId: exerciseId,
                  set: ExerciseSet(
                    id: const Uuid().v4(),
                    weightKg: double.parse(weightController.text),
                    reps: int.parse(repsController.text),
                    performedAt: DateTime.now(),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
