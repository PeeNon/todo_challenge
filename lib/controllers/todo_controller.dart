import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/firebase_service.dart';

class TodoController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<Todo> _todos = [];
  String _filterQuery = '';
  String? _editingId;
  String? _warningMessage;
  bool _isLoading = true;
  StreamSubscription? _todosSubscription;

  TodoController() {
    _initFirebaseSync();
  }

  // Initialize Firebase real-time sync
  void _initFirebaseSync() {
    _todosSubscription = _firebaseService.getTodosStream().listen(
      (todos) {
        _todos = todos;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Firebase sync error: $error');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _todosSubscription?.cancel();
    super.dispose();
  }

  // Getters
  List<Todo> get todos => _todos;
  String get filterQuery => _filterQuery;
  String? get editingId => _editingId;
  String? get warningMessage => _warningMessage;
  bool get isLoading => _isLoading;

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
  Future<bool> addTodo(String title) async {
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

    // Add the todo to Firebase
    final newTodo = Todo(
      id: '', // Will be replaced by Firebase
      title: trimmedTitle,
    );

    try {
      await _firebaseService.addTodo(newTodo);
      _warningMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _warningMessage = 'Failed to add todo';
      notifyListeners();
      return false;
    }
  }

  // Remove a todo
  Future<void> removeTodo(String id) async {
    if (_editingId == id) {
      _editingId = null;
    }

    try {
      await _firebaseService.deleteTodo(id);
    } catch (e) {
      debugPrint('Failed to delete todo: $e');
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
  Future<bool> updateTodo(String newTitle) async {
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

    // Update the todo in Firebase
    final todoToUpdate = _todos.firstWhere((todo) => todo.id == _editingId);
    final updatedTodo = todoToUpdate.copyWith(title: trimmedTitle);

    try {
      await _firebaseService.updateTodo(updatedTodo);
      _editingId = null;
      _warningMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _warningMessage = 'Failed to update todo';
      notifyListeners();
      return false;
    }
  }

  // Toggle todo completion status
  Future<void> toggleComplete(String id) async {
    final todo = _todos.firstWhere((todo) => todo.id == id);

    try {
      await _firebaseService.toggleComplete(id, !todo.isDone);
    } catch (e) {
      debugPrint('Failed to toggle complete: $e');
    }
  }
}
