import 'package:flutter/material.dart';

/// Paleta baseada no design "constancia." (Figma), aquecida para um tom
/// mais energético/animado (laranja e amarelo como cores de marca).
class AppColors {
  AppColors._();

  static const primary = Color(0xFFE2632E); // laranja queimado (botões/marca)
  static const primaryDark = Color(0xFFB84A1F);
  static const accentYellow = Color(0xFFF5B942); // amarelo de destaque
  static const background = Color(0xFFFFF8EF); // off-white quente de fundo
  static const surface = Color(0xFFFFFFFF);
  static const accentOrange = Color(0xFFF08A3C); // ciclo de foco / streak
  static const statusParada = Color(0xFFD9534F); // card parado
  static const statusDesenvolvimento = Color(0xFF4C6FA0); // card em andamento
  static const statusNaoIniciada = Color(0xFF9B9B93); // card não iniciado
  static const textPrimary = Color(0xFF2B211C);
  static const textSecondary = Color(0xFF7A6F63);
  static const divider = Color(0xFFE9DFD1);
}
