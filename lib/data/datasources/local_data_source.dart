import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/task_model.dart';

class LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSource({required this.sharedPreferences});

  Future<List<TaskModel>> loadTasks() async {
    try {
      final String? tasksJson = sharedPreferences.getString(AppConstants.tasksStorageKey);

      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }

      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final List<Map<String, dynamic>> tasksJsonList =
          tasks.map((task) => task.toJson()).toList();
      final String tasksJson = json.encode(tasksJsonList);
      await sharedPreferences.setString(AppConstants.tasksStorageKey, tasksJson);
    } catch (e) {
      throw Exception('Failed to save tasks: $e');
    }
  }

  Future<void> clearTasks() async {
    try {
      await sharedPreferences.remove(AppConstants.tasksStorageKey);
    } catch (e) {
      throw Exception('Failed to clear tasks: $e');
    }
  }

  Future<ThemeMode> getThemeMode() async {
    try {
      final String? themeString = sharedPreferences.getString(AppConstants.themeStorageKey);
      if (themeString == null) {
        return ThemeMode.system;
      }
      return ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
    } catch (e) {
      return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    try {
      await sharedPreferences.setString(
        AppConstants.themeStorageKey,
        themeMode.toString(),
      );
    } catch (e) {
      throw Exception('Failed to save theme mode: $e');
    }
  }
}
