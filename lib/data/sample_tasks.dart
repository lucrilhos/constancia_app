import '../models/task_card_model.dart';

/// Dados mockados usados como FALLBACK caso o Supabase não responda
/// (ex: sem internet na hora da apresentação). O app tenta sempre
/// buscar do banco primeiro — ver SupabaseService.
const List<TaskCardModel> sampleTasks = [
  TaskCardModel(
    id: 'local-1',
    title: 'Estudar Python',
    assigneeInitials: 'GB',
    status: TaskStatus.emDesenvolvimento,
    comments: [
      TaskComment('Enzo Ribeiro', 'Bora nessa, te chamo pra revisar depois'),
    ],
  ),
  TaskCardModel(
    id: 'local-2',
    title: 'Integração com API — Estudo',
    assigneeInitials: 'GB',
    status: TaskStatus.parada,
    blockedReason: 'Esperando a aula 2 sobre APIs ficar disponível',
    comments: [
      TaskComment('Lucas Mendes', 'Vi um vídeo bom sobre isso, te mando o link'),
      TaskComment('Kaio Correa', 'Travei nessa parte também, bora estudar junto amanhã?'),
    ],
  ),
  TaskCardModel(
    id: 'local-3',
    title: 'Ler 20 páginas do livro',
    assigneeInitials: 'GB',
    status: TaskStatus.naoIniciada,
  ),
  TaskCardModel(
    id: 'local-4',
    title: '30 min de exercício',
    assigneeInitials: 'GB',
    status: TaskStatus.naoIniciada,
  ),
  TaskCardModel(
    id: 'local-5',
    title: 'Preparar apresentação do TCC',
    assigneeInitials: 'GB',
    status: TaskStatus.emDesenvolvimento,
    comments: [
      TaskComment('Guilherme Califoni', 'Manda um print de como tá ficando'),
    ],
  ),
];
