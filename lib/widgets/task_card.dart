import 'package:flutter/material.dart';
import '../models/task_card_model.dart';
import '../theme/app_colors.dart';

class TaskCard extends StatelessWidget {
  final TaskCardModel task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  Color get _statusColor {
    switch (task.status) {
      case TaskStatus.naoIniciada:
        return AppColors.statusNaoIniciada;
      case TaskStatus.emDesenvolvimento:
        return AppColors.statusDesenvolvimento;
      case TaskStatus.parada:
        return AppColors.statusParada;
    }
  }

  String get _statusLabel {
    switch (task.status) {
      case TaskStatus.naoIniciada:
        return 'NÃO INICIADA';
      case TaskStatus.emDesenvolvimento:
        return 'DESENVOLVIMENTO';
      case TaskStatus.parada:
        return 'PARADA';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  task.assigneeInitials,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
              const Spacer(),
              if (task.commentCount > 0)
                Text(
                  '${task.commentCount}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }
}
