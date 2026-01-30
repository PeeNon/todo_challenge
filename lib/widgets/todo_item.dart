import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final VoidCallback onToggleComplete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onRemove,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Todo title with strikethrough if completed
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  color: todo.isDone ? Colors.grey : null,
                ),
              ),
            ),
            // Mark as Complete/Incomplete button
            TextButton(
              onPressed: onToggleComplete,
              child: Text(
                todo.isDone ? 'Mark as Incomplete' : 'Mark as Complete',
                style: TextStyle(
                  color: todo.isDone ? Colors.orange : Colors.green,
                ),
              ),
            ),
            // Edit button
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            // Remove button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
              tooltip: 'Remove',
            ),
          ],
        ),
      ),
    );
  }
}
