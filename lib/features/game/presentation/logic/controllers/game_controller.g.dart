// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameUiState] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est injectée via
/// [aiStrategyProvider] pour permettre l'override en test.
///
/// [cpuThinking] est un état de présentation (spinner UI) maintenu dans
/// [GameUiState] et non dans [GameStateEntity] (domaine pur).

@ProviderFor(GameController)
final gameControllerProvider = GameControllerFamily._();

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameUiState] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est injectée via
/// [aiStrategyProvider] pour permettre l'override en test.
///
/// [cpuThinking] est un état de présentation (spinner UI) maintenu dans
/// [GameUiState] et non dans [GameStateEntity] (domaine pur).
final class GameControllerProvider
    extends $NotifierProvider<GameController, GameUiState> {
  /// Contrôleur principal de la partie (Riverpod Notifier).
  ///
  /// Gère la machine à états de [GameUiState] : validation des coups humains,
  /// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
  /// et réinitialisation via [restart]. La stratégie IA est injectée via
  /// [aiStrategyProvider] pour permettre l'override en test.
  ///
  /// [cpuThinking] est un état de présentation (spinner UI) maintenu dans
  /// [GameUiState] et non dans [GameStateEntity] (domaine pur).
  GameControllerProvider._({
    required GameControllerFamily super.from,
    required GameConfigEntity super.argument,
  }) : super(
         retry: null,
         name: r'gameControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameControllerHash();

  @override
  String toString() {
    return r'gameControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GameController create() => GameController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameUiState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameControllerHash() => r'c0233f4d33f466bbeaa1287c883294f6806fb4bf';

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameUiState] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est injectée via
/// [aiStrategyProvider] pour permettre l'override en test.
///
/// [cpuThinking] est un état de présentation (spinner UI) maintenu dans
/// [GameUiState] et non dans [GameStateEntity] (domaine pur).

final class GameControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          GameController,
          GameUiState,
          GameUiState,
          GameUiState,
          GameConfigEntity
        > {
  GameControllerFamily._()
    : super(
        retry: null,
        name: r'gameControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Contrôleur principal de la partie (Riverpod Notifier).
  ///
  /// Gère la machine à états de [GameUiState] : validation des coups humains,
  /// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
  /// et réinitialisation via [restart]. La stratégie IA est injectée via
  /// [aiStrategyProvider] pour permettre l'override en test.
  ///
  /// [cpuThinking] est un état de présentation (spinner UI) maintenu dans
  /// [GameUiState] et non dans [GameStateEntity] (domaine pur).

  GameControllerProvider call(GameConfigEntity config) =>
      GameControllerProvider._(argument: config, from: this);

  @override
  String toString() => r'gameControllerProvider';
}

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameUiState] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est injectée via
/// [aiStrategyProvider] pour permettre l'override en test.
///
/// [cpuThinking] est un état de présentation (spinner UI) maintenu dans
/// [GameUiState] et non dans [GameStateEntity] (domaine pur).

abstract class _$GameController extends $Notifier<GameUiState> {
  late final _$args = ref.$arg as GameConfigEntity;
  GameConfigEntity get config => _$args;

  GameUiState build(GameConfigEntity config);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameUiState, GameUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameUiState, GameUiState>,
              GameUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
