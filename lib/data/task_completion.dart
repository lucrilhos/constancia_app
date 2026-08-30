/// Guarda quais tarefas já foram "concluídas hoje", pra o check aparecer
/// riscado na tela principal — seja porque a pessoa marcou manualmente,
/// seja porque terminou um ciclo de foco daquela tarefa.
class TaskCompletion {
  TaskCompletion._();

  static final Set<String> doneTitles = {};

  static bool isDone(String title) => doneTitles.contains(title);

  static void toggle(String title) {
    if (doneTitles.contains(title)) {
      doneTitles.remove(title);
    } else {
      doneTitles.add(title);
    }
  }

  static void markDone(String title) => doneTitles.add(title);
}
