import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/todo_controller.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(TodoController controller) async {
    final text = _textController.text;

    if (controller.isEditing) {
      // Update existing todo
      if (await controller.updateTodo(text)) {
        _textController.clear();
      }
    } else {
      // Add new todo
      if (await controller.addTodo(text)) {
        _textController.clear();
      }
    }
  }

  void _handleTextChange(TodoController controller, String value) {
    // Clear any warning when user starts typing
    if (controller.warningMessage != null) {
      controller.clearWarning();
    }
    // Apply filter while typing (only when not editing)
    if (!controller.isEditing) {
      controller.setFilterQuery(value);
    }
  }

  void _startEditing(TodoController controller, String todoId) {
    controller.startEditing(todoId);
    final editingTodo = controller.editingTodo;
    if (editingTodo != null) {
      _textController.text = editingTodo.title;
      // Clear filter when editing
      controller.setFilterQuery('');
      _focusNode.requestFocus();
    }
  }

  void _cancelEditing(TodoController controller) {
    controller.cancelEditing();
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Sync indicator
          Consumer<TodoController>(
            builder: (context, controller, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.cloud_done,
                  color: controller.isLoading ? Colors.grey : Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              // Input section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input field
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText:
                            controller.isEditing
                                ? 'Edit todo item...'
                                : 'Add a new todo or filter...',
                        border: const OutlineInputBorder(),
                        suffixIcon:
                            controller.isEditing
                                ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _cancelEditing(controller),
                                  tooltip: 'Cancel',
                                )
                                : null,
                      ),
                      onChanged:
                          (value) => _handleTextChange(controller, value),
                      onSubmitted: (_) => _handleSubmit(controller),
                    ),
                    const SizedBox(height: 8),
                    // Warning message
                    if (controller.warningMessage != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          controller.warningMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Add/Update button
                    ElevatedButton(
                      onPressed: () => _handleSubmit(controller),
                      child: Text(controller.isEditing ? 'Update' : 'Add Todo'),
                    ),
                  ],
                ),
              ),
              // List section
              Expanded(child: _buildTodoList(controller)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTodoList(TodoController controller) {
    // Show loading indicator
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final todos = controller.filteredTodos;

    // Show "No result" message when filtering yields no results
    if (todos.isEmpty && controller.filterQuery.isNotEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No result. Create a new one instead',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Show empty state when no todos exist
    if (todos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No todos yet. Add one above!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Show todo list
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onEdit: () => _startEditing(controller, todo.id),
          onRemove: () => controller.removeTodo(todo.id),
          onToggleComplete: () => controller.toggleComplete(todo.id),
        );
      },
    );
  }
}
