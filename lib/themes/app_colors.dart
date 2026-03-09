import 'package:flutter/material.dart';

/// Paleta oficial RUA Viva
///
/// Roxo principal: #6A1B9A
/// Lilás claro:   #F7ECFF
/// Azul-claro:    #B3E5FC
/// Branco:        #FFFFFF
class AppColors {
  /// Roxo principal – empatia, espiritualidade e transformação
  static const Color purple = Color(0xFF6A1B9A);

  /// Lilás claro – acolhimento e leveza
  static const Color lilacLight = Color(0xFFF7ECFF);

  /// Alias para manter compatibilidade com trechos que usam `lightPurple`
  static const Color lightPurple = lilacLight;

  /// Azul-claro – confiança e tranquilidade
  static const Color blueLight = Color(0xFFB3E5FC);

  /// Branco – respiro visual
  static const Color white = Color(0xFFFFFFFF);
}
