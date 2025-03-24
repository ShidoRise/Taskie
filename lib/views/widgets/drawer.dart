import 'package:flutter/material.dart';
import 'package:time_and_task_management/utils/colors.dart';
import 'package:time_and_task_management/views/screens/pomodoro_tab.dart';
import 'package:time_and_task_management/views/screens/tasks_tab.dart';
import 'package:time_and_task_management/views/screens/time_tab.dart';

class SDrawer extends StatelessWidget {
  const SDrawer({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              child: Container(
                decoration: const BoxDecoration(
                  color: SColors.primaryFirst,
                ),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                child: Text(
                  _getGreeting(),
                  style: const TextStyle(
                    color: SColors.textPrimary,
                    fontSize: 20,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Pomodoro'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  _createRoute(const PomodoroTab()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tasks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  _createRoute(const TasksTab()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  _createRoute(const TimeTab()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
