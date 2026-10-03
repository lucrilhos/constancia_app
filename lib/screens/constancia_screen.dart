import 'package:flutter/material.dart';
import '../data/app_user.dart';
import '../data/sample_tasks.dart';
import '../data/supabase_service.dart';
import '../models/task_card_model.dart';
import '../theme/app_colors.dart';
import 'card_detail_screen.dart';
import 'configuracoes_screen.dart';

class ConstanciaScreen extends StatefulWidget {
  const ConstanciaScreen({super.key});

  @override
  State<ConstanciaScreen> createState() => _ConstanciaScreenState();
}

class _ConstanciaScreenState extends State<ConstanciaScreen> {
  // Tarefas em destaque na tela principal (as "principais" do dia).
  // Marcar como feita aqui é só visual neste MVP — não altera o status
  // da tarefa no banco.
  final Set<String> _doneToday = {};

  // Começa com os dados locais (pra tela nunca ficar em branco) e troca
  // pelos dados reais assim que o Supabase responder.
  List<TaskCardModel> _tasks = sampleTasks;
  List<ProfileRow>? _profiles;
  bool _offline = false;

  static const _fallbackFriends = [
    ('LM', 'Lucas Mendes', 12, 153),
    ('KC', 'Kaio Correa', 9, 120),
    ('GC', 'Guilherme Califoni', 7, 98),
  ];

  static const _last7Days = [1, 2, 1, 1, 2, 1, 1];
  static const _dayLabels = ['ter', 'qua', 'qui', 'sex', 'sab', 'dom', 'seg'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        SupabaseService.fetchTasks(),
        SupabaseService.fetchProfiles(),
      ]);
      if (!mounted) return;
      final tasks = results[0] as List<TaskCardModel>;
      final profiles = results[1] as List<ProfileRow>;
      setState(() {
        if (tasks.isNotEmpty) _tasks = tasks;
        _profiles = profiles;
        _offline = false;
      });
    } catch (_) {
      // Sem internet, Supabase fora do ar, etc. — fica com os dados
      // locais já carregados, sem travar a tela.
      if (!mounted) return;
      setState(() => _offline = true);
    }
  }

  List<TaskCardModel> get _highlightTasks => _tasks
      .where((t) => t.title != 'Preparar apresentação do TCC')
      .take(2)
      .toList();

  List<(String, String, int, int)> get _ranking {
    final profiles = _profiles;
    if (profiles != null && profiles.isNotEmpty) {
      return profiles.asMap().entries.map((entry) {
        final p = entry.value;
        final name = entry.key == 0 ? '${AppUser.name} (você)' : p.name;
        final initials = entry.key == 0 ? AppUser.initials : p.initials;
        return (initials, name, p.currentStreak, p.points);
      }).toList();
    }
    return [
      (AppUser.initials, '${AppUser.name} (você)', 14, 189),
      ..._fallbackFriends,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = _last7Days.reduce((a, b) => a > b ? a : b).toDouble();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Constancia',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            IconButton(
              icon: const Icon(Icons.settings_outlined,
                  color: AppColors.textPrimary),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const ConfiguracoesScreen()),
                );
              },
            ),
          ],
        ),
        Text('Olá, ${AppUser.firstName}, pronto para mais um dia?',
            style: const TextStyle(
                fontSize: 13.5, color: AppColors.textSecondary)),
        if (_offline) ...[
          const SizedBox(height: 6),
          const Text('Sem conexão com o banco — mostrando dados locais.',
              style: TextStyle(fontSize: 11.5, color: AppColors.statusParada)),
        ],
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
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
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
          final done = _doneToday.contains(task.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => CardDetailScreen(task: task)),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (done) {
                              _doneToday.remove(task.title);
                            } else {
                              _doneToday.add(task.title);
                            }
                          });
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: done
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                width: 1.5),
                            color:
                                done ? AppColors.primary : Colors.transparent,
                          ),
                          child: done
                              ? const Icon(Icons.check,
                                  size: 12, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: done
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            decoration:
                                done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          size: 18, color: AppColors.textSecondary),
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
