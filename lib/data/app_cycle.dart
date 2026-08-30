import '../models/focus_cycle.dart';

/// Guarda qual ciclo de foco a pessoa escolheu (no onboarding ou nas
/// configurações), pra ser usado quando o timer real começar a contar.
class AppCycle {
  AppCycle._();

  static FocusCycle selected = FocusCycle.presets[2]; // 60/20 por padrão

  /// Minutos de foco a usar no timer. Se "Personalizado" foi escolhido
  /// mas ainda não tem uma tela de input pra ele, cai num valor razoável.
  static int get focusMinutes =>
      selected.isCustom ? 25 : selected.focusMinutes;
}
