import 'package:flutter/material.dart';
import '../data/app_user.dart';
import '../data/sample_tasks.dart';
import '../data/task_completion.dart';
import '../theme/app_colors.dart';
import '../widgets/brand_mark.dart';
import 'card_detail_screen.dart';
import 'configuracoes_screen.dart';

class ConstanciaScreen extends StatefulWidget {
  const ConstanciaScreen({super.key});

  @override
  State<ConstanciaScreen> createState() => _ConstanciaScreenState();
}

class _ConstanciaScreenState extends State<ConstanciaScreen> {

  static final _highlightTasks =
      sampleTasks.where((t) => t.title != 'Preparar apresentação do TCC').take(2).toList();

  static const _last7Days = [1, 2, 1, 1, 2, 1, 1];
  static const _dayLabels = ['ter', 'qua', 'qui', 'sex', 'sab', 'dom', 'seg'];

  static const _friendsRanking = [
    ('DR', 'Diego Rocha', 12, 153),
    ('CM', 'Carla Mendes', 2, 74),
    ('LV', 'Lucas Vieira', 1, 70),
  ];

  List<(String, String, int, int)> get _ranking => [
        (AppUser.initials, '${AppUser.name} (você)', 14, 189),
        ..._friendsRanking,
      ];

  @override
  Widget build(BuildContext context) {
    final maxVal = _last7Days.reduce((a, b) => a > b ? a : b).toDouble();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BrandMark(logoSize: 48),
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
        Text('Olá, ${AppUser.firstName}, pronto para mais um dia?',
            style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sequência de ${AppUser.firstName}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 6),
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                      text: '14',
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentOrange)),
                  TextSpan(
                      text: ' dias seguidos',
                      style: TextStyle(
                          fontSize: 15, color: AppColors.textPrimary)),
                ]),
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  _StatChip(value: '1.5x', label: 'Multiplicador'),
                  SizedBox(width: 20),
                  _StatChip(value: '1', label: 'Escudos'),
                  SizedBox(width: 20),
                  _StatChip(value: '189', label: 'Pontos'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Minhas tarefas hoje',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        ..._highlightTasks.map((task) {
          final done = TaskCompletion.isDone(task.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CardDetailScreen(task: task)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            TaskCompletion.toggle(task.title);
                          });
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: done ? AppColors.primary : AppColors.textSecondary,
                                width: 1.5),
                            color: done ? AppColors.primary : Colors.transparent,
                          ),
                          child: done
                              ? const Icon(Icons.check, size: 12, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: done ? AppColors.textSecondary : AppColors.textPrimary,
                            decoration: done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        const Text('Últimos 7 dias',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_last7Days.length, (i) {
              final h = 20 + (_last7Days[i] / maxVal) * 50;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${_last7Days[i]}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Container(
                        height: h,
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_dayLabels[i],
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Ranking dos amigos',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        ..._ranking.asMap().entries.map((entry) {
          final i = entry.key + 1;
          final (initials, name, streak, points) = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                    width: 20,
                    child: Text('$i',
                        style:
                            const TextStyle(color: AppColors.textSecondary))),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(initials,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary))),
                Text('🔥$streak',
                    style: const TextStyle(
                        color: AppColors.accentOrange, fontSize: 13)),
                const SizedBox(width: 12),
                Text('$points',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;

  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.textPrimary)),
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
