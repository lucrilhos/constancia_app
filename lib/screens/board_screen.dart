import 'package:flutter/material.dart';
import '../data/sample_tasks.dart';
import '../models/task_card_model.dart';
import '../theme/app_colors.dart';
import '../widgets/task_card.dart';
import 'card_detail_screen.dart';
import 'configuracoes_screen.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final naoIniciada =
        sampleTasks.where((t) => t.status == TaskStatus.naoIniciada).toList();
    final emDesenvolvimento = sampleTasks
        .where((t) => t.status == TaskStatus.emDesenvolvimento)
        .toList();
    final parada =
        sampleTasks.where((t) => t.status == TaskStatus.parada).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Board',
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
        const SizedBox(height: 4),
        _StatusSection(
            title: 'Não iniciada',
            color: AppColors.statusNaoIniciada,
            tasks: naoIniciada),
        _StatusSection(
            title: 'Em desenvolvimento',
            color: AppColors.statusDesenvolvimento,
            tasks: emDesenvolvimento),
        _StatusSection(
            title: 'Parada', color: AppColors.statusParada, tasks: parada),
      ],
    );
  }
}

class _StatusSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<TaskCardModel> tasks;

  const _StatusSection(
      {required this.title, required this.color, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.textPrimary)),
              const SizedBox(width: 6),
              Text('${tasks.length}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ...tasks.map((t) => TaskCard(
                task: t,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CardDetailScreen(task: t)),
                  );
                },
              )),
        ],
      ),
    );
  }
}
