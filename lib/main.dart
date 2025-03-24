import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_and_task_management/utils/colors.dart';
import 'package:time_and_task_management/view_models/events_viewmodel.dart';
import 'package:time_and_task_management/view_models/tasks_viewmodel.dart';
import 'package:time_and_task_management/views/screens/pomodoro_tab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time and Task Management',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          primary: SColors.accent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      home: const PomodoroTab(),
    );
  }
}
