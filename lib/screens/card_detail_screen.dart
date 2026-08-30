import 'package:flutter/material.dart';
import '../data/app_cycle.dart';
import '../models/task_card_model.dart';
import '../theme/app_colors.dart';
import 'focus_cycle_screen.dart';

class CardDetailScreen extends StatefulWidget {
  final TaskCardModel task;

  const CardDetailScreen({super.key, required this.task});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  final _commentController = TextEditingController();
  late final List<TaskComment> _comments = List.of(widget.task.comments);

  Color get _statusColor {
    switch (widget.task.status) {
      case TaskStatus.naoIniciada:
        return AppColors.statusNaoIniciada;
      case TaskStatus.emDesenvolvimento:
        return AppColors.statusDesenvolvimento;
      case TaskStatus.parada:
        return AppColors.statusParada;
    }
  }

  String get _statusLabel {
    switch (widget.task.status) {
      case TaskStatus.naoIniciada:
        return 'NÃO INICIADA';
      case TaskStatus.emDesenvolvimento:
        return 'EM DESENVOLVIMENTO';
      case TaskStatus.parada:
        return 'PARADA';
    }
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(TaskComment('Você', text));
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Card'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            widget.task.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  widget.task.assigneeInitials,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (widget.task.status == TaskStatus.parada && widget.task.blockedReason != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.statusParada.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.statusParada.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bloqueado por',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.statusParada)),
                  const SizedBox(height: 4),
                  Text(widget.task.blockedReason!,
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FocusCycleScreen(
                      taskTitle: widget.task.title,
                      focusMinutes: AppCycle.focusMinutes,
                    ),
                  ),
                );
              },
              child: const Text('›  Iniciar ciclo de foco'),
            ),
          ),
          const SizedBox(height: 28),
          const Text('Comentários dos amigos',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          if (_comments.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Nenhum comentário ainda.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ),
          ..._comments.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: Text(
                        c.author.substring(0, c.author.length >= 2 ? 2 : 1).toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.author,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.textPrimary)),
                          Text(c.text,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Escrever um comentário...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                  ),
                  onSubmitted: (_) => _addComment(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addComment,
                style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
