import 'package:flutter/material.dart';
import 'package:time_and_task_management/utils/colors.dart';

class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBreakMode;

  const SAppBar({super.key, required this.title, required this.isBreakMode});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 10,
            offset: Offset(0, 1),
            spreadRadius: 1,
          )
        ],
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: isBreakMode ? Colors.lightGreen : SColors.primaryFirst,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            color: SColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
