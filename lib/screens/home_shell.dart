import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'board_screen.dart';
import 'constancia_screen.dart';
import 'travados_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    ConstanciaScreen(),
    BoardScreen(),
    TravadosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined), label: 'Constancia'),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_kanban_outlined), label: 'Board'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lock_clock_outlined), label: 'Travados'),
        ],
      ),
    );
  }
}
