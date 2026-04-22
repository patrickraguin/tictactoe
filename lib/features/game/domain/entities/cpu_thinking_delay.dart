import 'difficulty_enum.dart';

/// Délai de "réflexion" du CPU associé à chaque niveau de difficulté.
///
/// Règle métier UX : le délai simulé doit croître avec la difficulté pour
/// renforcer la perception de "réflexion" de l'IA.
extension DifficultyThinkingDelay on DifficultyEnum {
  Duration get cpuThinkingDelay => switch (this) {
        DifficultyEnum.easy => const Duration(milliseconds: 200),
        DifficultyEnum.medium => const Duration(milliseconds: 450),
        DifficultyEnum.hard => const Duration(milliseconds: 700),
      };
}
