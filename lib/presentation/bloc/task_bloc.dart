import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RefreshTasks>(_onRefreshTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    try {
      final tasks = await taskRepository.getAllTasks();
      // Sort tasks by updatedAt in descending order (most recent first)
      tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.addTask(event.task);
      final tasks = await taskRepository.getAllTasks();
      tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(event.task);
      final tasks = await taskRepository.getAllTasks();
      tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.taskId);
      final tasks = await taskRepository.getAllTasks();
      tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onRefreshTasks(RefreshTasks event, Emitter<TaskState> emit) async {
    try {
      final tasks = await taskRepository.getAllTasks();
      tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
