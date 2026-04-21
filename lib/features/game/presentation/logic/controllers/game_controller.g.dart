// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameStateEntity] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est instanciée une
/// seule fois à la construction et réutilisée pour toute la durée de vie.

@ProviderFor(GameController)
const gameControllerProvider = GameControllerFamily._();

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameStateEntity] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est instanciée une
/// seule fois à la construction et réutilisée pour toute la durée de vie.
final class GameControllerProvider
    extends $NotifierProvider<GameController, GameStateEntity> {
  /// Contrôleur principal de la partie (Riverpod Notifier).
  ///
  /// Gère la machine à états de [GameStateEntity] : validation des coups humains,
  /// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
  /// et réinitialisation via [restart]. La stratégie IA est instanciée une
  /// seule fois à la construction et réutilisée pour toute la durée de vie.
  const GameControllerProvider._({
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
  Override overrideWithValue(GameStateEntity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameStateEntity>(value),
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

String _$gameControllerHash() => r'21f45b6ef93994ff1393aadeafa818d864cd73b9';

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameStateEntity] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est instanciée une
/// seule fois à la construction et réutilisée pour toute la durée de vie.

final class GameControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          GameController,
          GameStateEntity,
          GameStateEntity,
          GameStateEntity,
          GameConfigEntity
        > {
  const GameControllerFamily._()
    : super(
        retry: null,
        name: r'gameControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Contrôleur principal de la partie (Riverpod Notifier).
  ///
  /// Gère la machine à états de [GameStateEntity] : validation des coups humains,
  /// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
  /// et réinitialisation via [restart]. La stratégie IA est instanciée une
  /// seule fois à la construction et réutilisée pour toute la durée de vie.

  GameControllerProvider call(GameConfigEntity config) =>
      GameControllerProvider._(argument: config, from: this);

  @override
  String toString() => r'gameControllerProvider';
}

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameStateEntity] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est instanciée une
/// seule fois à la construction et réutilisée pour toute la durée de vie.

abstract class _$GameController extends $Notifier<GameStateEntity> {
  late final _$args = ref.$arg as GameConfigEntity;
  GameConfigEntity get config => _$args;

  GameStateEntity build(GameConfigEntity config);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<GameStateEntity, GameStateEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameStateEntity, GameStateEntity>,
              GameStateEntity,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
