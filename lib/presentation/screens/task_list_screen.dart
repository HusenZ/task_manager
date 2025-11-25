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
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded && state.tasks.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Text(
                      '${state.tasks.length} ${state.tasks.length == 1 ? 'task' : 'tasks'}',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle theme',
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
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
