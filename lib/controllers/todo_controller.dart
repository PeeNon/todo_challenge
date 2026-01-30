import 'package:flutter/foundation.dart';
import '../models/todo.dart';

class TodoController extends ChangeNotifier {
  final List<Todo> _todos = [];
  String _filterQuery = '';
  String? _editingId;
  String? _warningMessage;

  // Getters
  List<Todo> get todos => _todos;
  String get filterQuery => _filterQuery;
  String? get editingId => _editingId;
  String? get warningMessage => _warningMessage;

  // Get filtered todos based on search query
  List<Todo> get filteredTodos {
    if (_filterQuery.isEmpty) {
      return _todos;
    }
    return _todos
        .where(
          (todo) =>
              todo.title.toLowerCase().contains(_filterQuery.toLowerCase()),
        )
        .toList();
  }

  // Check if currently editing
  bool get isEditing => _editingId != null;

  // Get the todo being edited
  Todo? get editingTodo {
    if (_editingId == null) return null;
    try {
      return _todos.firstWhere((todo) => todo.id == _editingId);
    } catch (e) {
      return null;
    }
  }

  // Set filter query for real-time filtering
  void setFilterQuery(String query) {
    _filterQuery = query;
    notifyListeners();
  }

  // Clear warning message
  void clearWarning() {
    _warningMessage = null;
    notifyListeners();
  }

  // Add a new todo
  bool addTodo(String title) {
    final trimmedTitle = title.trim();

    // Validate empty
    if (trimmedTitle.isEmpty) {
      _warningMessage = 'Todo item cannot be empty';
      notifyListeners();
      return false;
    }

    // Validate duplicate
    final isDuplicate = _todos.any(
      (todo) => todo.title.toLowerCase() == trimmedTitle.toLowerCase(),
    );
    if (isDuplicate) {
      _warningMessage = 'This todo already exists';
      notifyListeners();
      return false;
    }

    // Add the todo
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: trimmedTitle,
    );
    _todos.add(newTodo);
    _warningMessage = null;
    notifyListeners();
    return true;
  }

  // Remove a todo
  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    if (_editingId == id) {
      _editingId = null;
    }
    notifyListeners();
  }

  // Start editing a todo
  void startEditing(String id) {
    _editingId = id;
    _warningMessage = null;
    notifyListeners();
  }

  // Cancel editing
  void cancelEditing() {
    _editingId = null;
    _warningMessage = null;
    notifyListeners();
  }

  // Update a todo
  bool updateTodo(String newTitle) {
    if (_editingId == null) return false;

    final trimmedTitle = newTitle.trim();

    // Validate empty
    if (trimmedTitle.isEmpty) {
      _warningMessage = 'Todo item cannot be empty';
      notifyListeners();
      return false;
    }

    // Validate duplicate (excluding current todo)
    final isDuplicate = _todos.any(
      (todo) =>
          todo.id != _editingId &&
          todo.title.toLowerCase() == trimmedTitle.toLowerCase(),
    );
    if (isDuplicate) {
      _warningMessage = 'This todo already exists';
      notifyListeners();
      return false;
    }

    // Update the todo
    final index = _todos.indexWhere((todo) => todo.id == _editingId);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(title: trimmedTitle);
    }
    _editingId = null;
    _warningMessage = null;
    notifyListeners();
    return true;
  }

  // Toggle todo completion status
  void toggleComplete(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isDone: !_todos[index].isDone);
      notifyListeners();
    }
  }
}
