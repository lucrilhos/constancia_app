import 'package:flutter/material.dart';
import '../data/app_cycle.dart';
import '../models/focus_cycle.dart';
import '../theme/app_colors.dart';
import '../widgets/brand_mark.dart';
import '../widgets/cycle_option_card.dart';
import 'home_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedIndex = 2; // 60/20 pré-selecionado, como no design

  @override
  Widget build(BuildContext context) {
    final selected = FocusCycle.presets[_selectedIndex];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandMark(logoSize: 44),
              const SizedBox(height: 8),
              const Text(
                'Aparecer todo dia vale mais\ndo que virar a noite.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Qual ciclo de foco\ncombina com você?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Um ciclo concluído já faz o dia contar.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(FocusCycle.presets.length, (index) {
                final cycle = FocusCycle.presets[index];
                return CycleOptionCard(
                  cycle: cycle,
                  selected: _selectedIndex == index,
                  onTap: () => setState(() => _selectedIndex = index),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AppCycle.selected = selected;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeShell()),
                    );
                  },
                  child: Text('Comecar com ${selected.label}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
