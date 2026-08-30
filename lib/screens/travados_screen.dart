import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'configuracoes_screen.dart';

class TravadosScreen extends StatelessWidget {
  const TravadosScreen({super.key});

  static const _blocked = [
    ('Integração com a API interna', 'Contrato de dados', 'BS'),
    ('Relatório semanal por pessoa', 'Design do card de tarefa', 'CM'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Travados',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ConfiguracoesScreen()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text('${_blocked.length} card(s) parado(s) esperando alguma coisa.',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),
        ..._blocked.map((b) {
          final (title, waiting, initials) = b;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.textPrimary)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.statusParada.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('PARADA',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.statusParada)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Esperando: $waiting',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(initials,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
