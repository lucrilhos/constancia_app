import '../models/task_card_model.dart';

/// Tarefas de exemplo. Num app real isso viria de um backend/banco local,
/// mas pra este MVP fica tudo centralizado aqui, então Home, Board e Card
/// sempre mostram os mesmos dados.
const List<TaskCardModel> sampleTasks = [
  TaskCardModel(
    title: 'Estudar Python',
    assigneeInitials: 'VC',
    status: TaskStatus.emDesenvolvimento,
    comments: [
      TaskComment('Ana', 'Bora nessa, te chamo pra revisar depois'),
    ],
  ),
  TaskCardModel(
    title: 'Integração com API — Estudo',
    assigneeInitials: 'VC',
    status: TaskStatus.parada,
    blockedReason: 'Esperando a aula 2 sobre APIs ficar disponível',
    comments: [
      TaskComment('Bruno', 'Vi um vídeo bom sobre isso, te mando o link'),
      TaskComment('Diego', 'Travei nessa parte também, bora estudar junto amanhã?'),
    ],
  ),
  TaskCardModel(
    title: 'Ler 20 páginas do livro',
    assigneeInitials: 'VC',
    status: TaskStatus.naoIniciada,
  ),
  TaskCardModel(
    title: '30 min de exercício',
    assigneeInitials: 'VC',
    status: TaskStatus.naoIniciada,
  ),
  TaskCardModel(
    title: 'Preparar apresentação do TCC',
    assigneeInitials: 'VC',
    status: TaskStatus.emDesenvolvimento,
    comments: [
      TaskComment('Carla', 'Manda um print de como tá ficando'),
    ],
  ),
];
