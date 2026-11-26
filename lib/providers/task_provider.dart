import 'package:flutter/foundation.dart';
import '../models/task.dart';

enum TaskFilter { all, active, done }

/// State management menggunakan Provider (ChangeNotifier).
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  TaskFilter get filter => _filter;

  List<Task> get tasks {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((t) => !t.isDone).toList();
      case TaskFilter.done:
        return _tasks.where((t) => t.isDone).toList();
      case TaskFilter.all:
        return List.unmodifiable(_tasks);
    }
  }

  int get totalCount => _tasks.length;
  int get doneCount => _tasks.where((t) => t.isDone).length;
  int get activeCount => totalCount - doneCount;

  void addTask(String title) {
    final text = title.trim();
    if (text.isEmpty) return;
    _tasks.insert(
      0,
      Task(id: DateTime.now().microsecondsSinceEpoch.toString(), title: text),
    );
    notifyListeners();
  }

  void toggleTask(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _tasks[i] = _tasks[i].copyWith(isDone: !_tasks[i].isDone);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _tasks.removeWhere((t) => t.isDone);
    notifyListeners();
  }

  void reset() {
    _tasks.clear();
    _filter = TaskFilter.all;
    notifyListeners();
  }

  void setFilter(TaskFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }
}
