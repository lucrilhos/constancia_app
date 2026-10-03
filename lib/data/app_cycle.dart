import '../models/focus_cycle.dart';

class AppCycle {
  AppCycle._();

  static FocusCycle selected = FocusCycle.presets[2];

  static int get focusMinutes {
    if (selected.label == '60/20') return 1;
    if (selected.isCustom) return 25;
    return selected.focusMinutes;
  }

  static int get restMinutes {
    if (selected.label == '60/20') return 1;
    if (selected.isCustom) return 5;
    return selected.restMinutes;
  }
}
