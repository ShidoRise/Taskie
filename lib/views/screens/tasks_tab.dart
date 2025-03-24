import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_and_task_management/models/task.dart';
import 'package:time_and_task_management/utils/colors.dart';
import 'package:time_and_task_management/view_models/tasks_viewmodel.dart';
import 'package:time_and_task_management/views/widgets/add_task_sheet.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  void _showAddTaskSheet(BuildContext context, TasksViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskSheet(
        onTaskAdd: viewModel.addTask,
        initialPriority: Priority.medium,
        isEditing: false,
      ),
    );
  }

  void _showEditTaskSheet(
      BuildContext context, TasksViewModel viewModel, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskSheet(
        onTaskAdd: (title, priority) =>
            viewModel.editTask(task.id, title, priority),
        initialPriority: task.priority,
        initialTitle: task.title,
        isEditing: true,
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return Colors.red;
      case Priority.high:
        return Colors.orange;
      case Priority.medium:
        return Colors.blue;
      case Priority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: const SAppBar(title: 'Tasks', isBreakMode: false),
        body: viewModel.sortedTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add a new task',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: viewModel.sortedTasks.length,
                itemBuilder: (context, index) {
                  final task = viewModel.sortedTasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => viewModel.deleteTask(task.id),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(task.priority),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (_) =>
                                      viewModel.toggleTask(task.id),
                                ),
                              ],
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _showEditTaskSheet(context, viewModel, task),
                            ),
                          ),
                          const Divider(
                            height: 0,
                            thickness: 0.5,
                            indent: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FloatingActionButton(
            onPressed: () => _showAddTaskSheet(context, viewModel),
            backgroundColor: SColors.primaryFirst,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ),
        drawer: const SDrawer(),
      ),
    );
  }
}
