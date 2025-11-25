import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const TaskListScreen({
    super.key,
    required this.onToggleTheme,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.task_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              AppConstants.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(
                  red: (theme.colorScheme.primary.r * 0.8).clamp(0, 1),
                  green: (theme.colorScheme.primary.g * 0.8).clamp(0, 1),
                  blue: (theme.colorScheme.primary.b * 1.2).clamp(0, 1),
                ),
              ],
            ),
          ),
        ),
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded && state.tasks.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${state.tasks.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: Colors.white,
              ),
              onPressed: widget.onToggleTheme,
              tooltip: 'Toggle theme',
            ),
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                action: SnackBarAction(
                  label: AppConstants.retryButton,
                  textColor: theme.colorScheme.onError,
                  onPressed: () {
                    context.read<TaskBloc>().add(const LoadTasks());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const LoadingIndicator();
          }

          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const EmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(const RefreshTasks());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () async {
                      final taskBloc = context.read<TaskBloc>();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: taskBloc,
                            child: EditTaskScreen(task: task),
                          ),
                        ),
                      );
                    },
                    onDelete: () {
                      context.read<TaskBloc>().add(DeleteTask(task.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(AppConstants.taskDeletedMessage),
                          backgroundColor: theme.colorScheme.primary,
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const EmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final taskBloc = context.read<TaskBloc>();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: taskBloc,
                child: const AddTaskScreen(),
              ),
            ),
          );
        },
        tooltip: 'Add Task',
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'New Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        elevation: 6,
      ),
    );
  }
}
