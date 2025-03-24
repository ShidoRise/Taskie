import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class TasksViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  static const String _tasksKey = 'tasks';
  Priority _selectedPriority = Priority.medium;

  List<Task> get tasks => _tasks;
  Priority get selectedPriority => _selectedPriority;

  TasksViewModel() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    _tasks.clear();
    _tasks.addAll(
      tasksJson.map((task) => Task.fromJson(jsonDecode(task))).toList(),
    );
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  void addTask(String title, Priority priority) {
    if (title.isEmpty) return;

    final task = Task(
      id: const Uuid().v4(),
      title: title,
      priority: priority,
      createdAt: DateTime.now(),
    );

    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isCompleted = !task.isCompleted;
    _saveTasks();
    notifyListeners();
  }

  void updatePriority(Priority priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  List<Task> get sortedTasks {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return sorted;
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  void editTask(String id, String newTitle, Priority newPriority) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        title: newTitle,
        priority: newPriority,
      );
      _saveTasks();
      notifyListeners();
    }
  }
}
