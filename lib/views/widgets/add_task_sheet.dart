import 'package:flutter/material.dart';
import 'package:time_and_task_management/models/task.dart';
import 'package:time_and_task_management/utils/colors.dart';

class AddTaskSheet extends StatefulWidget {
  final Function(String, Priority) onTaskAdd;
  final Priority initialPriority;
  final String? initialTitle;
  final bool isEditing;

  const AddTaskSheet({
    super.key,
    required this.onTaskAdd,
    required this.initialPriority,
    this.initialTitle,
    this.isEditing = false,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  late TextEditingController _textController;
  late Priority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialTitle);
    _selectedPriority = widget.initialPriority;
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Enter task',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 20),
          const Text(
            'Priority:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: Priority.values.map((priority) {
              return ChoiceChip(
                label: Text(priority.name),
                selected: _selectedPriority == priority,
                selectedColor: _getPriorityColor(priority).withOpacity(0.7),
                backgroundColor: _getPriorityColor(priority).withOpacity(0.2),
                onSelected: (selected) {
                  setState(() {
                    _selectedPriority = priority;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  widget.onTaskAdd(_textController.text, _selectedPriority);
                  Navigator.pop(context);
                }
              },
              child: Text(
                widget.isEditing ? 'Update Task' : 'Add Task',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
