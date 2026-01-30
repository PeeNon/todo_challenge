import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'todos';

  // Get todos stream for real-time sync
  Stream<List<Todo>> getTodosStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList();
        });
  }

  // Add a new todo
  Future<String> addTodo(Todo todo) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(todo.toFirestore());
    return docRef.id;
  }

  // Update a todo
  Future<void> updateTodo(Todo todo) async {
    await _firestore
        .collection(_collection)
        .doc(todo.id)
        .update(todo.toFirestore());
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Toggle todo completion
  Future<void> toggleComplete(String id, bool isDone) async {
    await _firestore.collection(_collection).doc(id).update({'isDone': isDone});
  }
}
