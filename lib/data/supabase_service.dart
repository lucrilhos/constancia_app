import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_card_model.dart';

/// Uma linha da tabela `profiles` — usada no ranking de amigos.
class ProfileRow {
  final String id;
  final String name;
  final String initials;
  final int currentStreak;
  final double multiplier;
  final int shields;
  final int points;

  const ProfileRow({
    required this.id,
    required this.name,
    required this.initials,
    required this.currentStreak,
    required this.multiplier,
    required this.shields,
    required this.points,
  });

  factory ProfileRow.fromMap(Map<String, dynamic> map) {
    return ProfileRow(
      id: map['id'] as String,
      name: map['name'] as String,
      initials: map['initials'] as String,
      currentStreak: map['current_streak'] as int,
      multiplier: (map['multiplier'] as num).toDouble(),
      shields: map['shields'] as int,
      points: map['points'] as int,
    );
  }
}

TaskStatus _statusFromDb(String value) {
  switch (value) {
    case 'em_desenvolvimento':
      return TaskStatus.emDesenvolvimento;
    case 'parada':
      return TaskStatus.parada;
    default:
      return TaskStatus.naoIniciada;
  }
}

String _statusToDb(TaskStatus status) {
  switch (status) {
    case TaskStatus.emDesenvolvimento:
      return 'em_desenvolvimento';
    case TaskStatus.parada:
      return 'parada';
    case TaskStatus.naoIniciada:
      return 'nao_iniciada';
  }
}

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Ranking completo, já ordenado por pontos (maior primeiro).
  static Future<List<ProfileRow>> fetchProfiles() async {
    final rows = await _client
        .from('profiles')
        .select()
        .order('points', ascending: false);
    return rows.map((r) => ProfileRow.fromMap(r)).toList();
  }

  /// Todas as tarefas (nesta demo, todas pertencem ao Gustavo).
  static Future<List<TaskCardModel>> fetchTasks() async {
    final rows = await _client.from('tasks').select().order('created_at');
    return rows.map((map) {
      return TaskCardModel(
        id: map['id'] as String,
        title: map['title'] as String,
        assigneeInitials: 'GB',
        status: _statusFromDb(map['status'] as String),
        blockedReason: map['blocked_reason'] as String?,
      );
    }).toList();
  }

  /// Comentários de amigos numa tarefa específica, com o nome de quem
  /// comentou (via join com profiles).
  static Future<List<TaskComment>> fetchComments(String taskId) async {
    final rows = await _client
        .from('task_comments')
        .select('text, profiles(name)')
        .eq('task_id', taskId)
        .order('created_at');
    return rows.map((map) {
      final profile = map['profiles'] as Map<String, dynamic>?;
      final author = profile?['name'] as String? ?? 'Amigo';
      return TaskComment(author, map['text'] as String);
    }).toList();
  }

  /// Adiciona um comentário novo numa tarefa.
  static Future<void> addComment({
    required String taskId,
    required String authorId,
    required String text,
  }) async {
    await _client.from('task_comments').insert({
      'task_id': taskId,
      'author_id': authorId,
      'text': text,
    });
  }

  /// Atualiza o status de uma tarefa (ex: ao concluir um ciclo de foco).
  static Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    await _client
        .from('tasks')
        .update({'status': _statusToDb(status)})
        .eq('id', taskId);
  }

  /// Id do perfil "Gustavo Braga" — o usuário "você" nesta demo.
  static Future<String?> fetchCurrentProfileId() async {
    final row = await _client
        .from('profiles')
        .select('id')
        .eq('name', 'Gustavo Braga')
        .maybeSingle();
    return row?['id'] as String?;
  }
}
