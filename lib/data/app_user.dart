class AppUser {
  AppUser._();

  static String name = 'Você';

  static String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '--';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  static String get firstName {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'você';
    return trimmed.split(RegExp(r'\s+')).first;
  }
}
