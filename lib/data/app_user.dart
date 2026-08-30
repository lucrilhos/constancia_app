/// Guarda o nome de quem se cadastrou, pra ser usado nas outras telas
/// (saudação, streak, ranking). Num app real isso viria de um backend
/// com autenticação de verdade — aqui é só uma variável global simples,
/// suficiente pro MVP.
class AppUser {
  AppUser._();

  static String name = 'Você';

  /// Iniciais pra usar em avatares (ex: "Gustavo Silva" -> "GS").
  static String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '--';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  /// Primeiro nome, pra saudações ("Olá, Gustavo").
  static String get firstName {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'você';
    return trimmed.split(RegExp(r'\s+')).first;
  }
}
