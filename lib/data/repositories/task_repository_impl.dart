import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final tasks = await localDataSource.loadTasks();
      return tasks.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      final tasks = await localDataSource.loadTasks();
      final taskModel = TaskModel.fromEntity(task);
      tasks.add(taskModel);
      await localDataSource.saveTasks(tasks);
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final tasks = await localDataSource.loadTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        tasks[index] = TaskModel.fromEntity(task);
        await localDataSource.saveTasks(tasks);
      } else {
        throw Exception('Task not found');
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final tasks = await localDataSource.loadTasks();
      tasks.removeWhere((task) => task.id == id);
      await localDataSource.saveTasks(tasks);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<void> clearAllTasks() async {
    try {
      await localDataSource.clearTasks();
    } catch (e) {
      throw Exception('Failed to clear all tasks: $e');
    }
  }
}
