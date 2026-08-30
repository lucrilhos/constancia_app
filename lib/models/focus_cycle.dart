class FocusCycle {
  final String label;
  final String description;
  final int focusMinutes;
  final int restMinutes;
  final bool isCustom;

  const FocusCycle({
    required this.label,
    required this.description,
    required this.focusMinutes,
    required this.restMinutes,
    this.isCustom = false,
  });

  static const presets = [
    FocusCycle(
      label: '25/5',
      description: '25 min de foco, 5 min de descanso',
      focusMinutes: 25,
      restMinutes: 5,
    ),
    FocusCycle(
      label: '50/10',
      description: '50 min de foco, 10 min de descanso',
      focusMinutes: 50,
      restMinutes: 10,
    ),
    FocusCycle(
      label: '60/20',
      description: '60 min de foco, 20 min de descanso',
      focusMinutes: 60,
      restMinutes: 20,
    ),
    FocusCycle(
      label: 'Personalizado',
      description: 'Você define foco e descanso',
      focusMinutes: 0,
      restMinutes: 0,
      isCustom: true,
    ),
  ];
}
