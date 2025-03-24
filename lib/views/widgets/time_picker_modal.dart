import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:time_and_task_management/utils/colors.dart';

class TimePickerModal extends StatefulWidget {
  final int initialDuration;
  final Function(int) onDurationChanged;
  final bool isBreakMode;

  const TimePickerModal({
    super.key,
    required this.initialDuration,
    required this.onDurationChanged,
    required this.isBreakMode,
  });

  @override
  State<TimePickerModal> createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal> {
  late int _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    final Color modeColor = widget.isBreakMode ? Colors.green : SColors.accent;

    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            widget.isBreakMode
                ? 'Select Break Duration'
                : 'Select Focus Duration',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: modeColor,
            ),
          ),
          const SizedBox(height: 30),
          NumberPicker(
            value: _selectedDuration,
            minValue: 1,
            maxValue: 60,
            step: 1,
            itemHeight: 60,
            axis: Axis.horizontal,
            onChanged: (value) => setState(() => _selectedDuration = value),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            textStyle: const TextStyle(
              color: Colors.grey,
            ),
            selectedTextStyle: TextStyle(
              color: modeColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              widget.onDurationChanged(_selectedDuration);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: modeColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Set Timer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
