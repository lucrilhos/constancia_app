import 'package:flutter/material.dart';
import '../data/app_cycle.dart';
import '../models/focus_cycle.dart';
import '../theme/app_colors.dart';
import '../widgets/cycle_option_card.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  late int _selectedIndex = () {
    final idx = FocusCycle.presets.indexWhere((c) => c.label == AppCycle.selected.label);
    return idx == -1 ? 2 : idx;
  }();

  static const _rules = [
    'Um ciclo concluído valida o dia: 10 pontos.',
    'Cada ciclo extra soma 1, até o teto de 15.',
    '1 a 3 dias: 1.0x . 4 a 7: 1.2x . 8+: 1.5x.',
    '1 escudo por semana congela a sequência.',
    'Falhar sem escudo cai um degrau, nunca zera.',
  ];

  @override
  Widget build(BuildContext context) {
    final current = FocusCycle.presets[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text('Ciclo de foco',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Atual: ${current.description}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ...List.generate(FocusCycle.presets.length, (index) {
            final cycle = FocusCycle.presets[index];
            return CycleOptionCard(
              cycle: cycle,
              selected: _selectedIndex == index,
              onTap: () => setState(() => _selectedIndex = index),
            );
          }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AppCycle.selected = current;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ciclo salvo!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Salvar ciclo'),
            ),
          ),
          const SizedBox(height: 28),
          const Text('Como a pontuação funciona',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _rules
                  .map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('•  $r',
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4)),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
