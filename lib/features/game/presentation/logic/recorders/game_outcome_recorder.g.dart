// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_outcome_recorder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Observateur des fins de partie chargé de persister le score.
///
/// Écoute [GameController] via [ref.listen] et délègue l'enregistrement
/// à [ScoreController] dès qu'une transition vers [WonEntity] ou [DrawEntity] est détectée.
/// Séparé de [GameController] pour respecter le principe de responsabilité unique.

@ProviderFor(GameOutcomeRecorder)
const gameOutcomeRecorderProvider = GameOutcomeRecorderFamily._();

/// Observateur des fins de partie chargé de persister le score.
///
/// Écoute [GameController] via [ref.listen] et délègue l'enregistrement
/// à [ScoreController] dès qu'une transition vers [WonEntity] ou [DrawEntity] est détectée.
/// Séparé de [GameController] pour respecter le principe de responsabilité unique.
final class GameOutcomeRecorderProvider
    extends $NotifierProvider<GameOutcomeRecorder, void> {
  /// Observateur des fins de partie chargé de persister le score.
  ///
  /// Écoute [GameController] via [ref.listen] et délègue l'enregistrement
  /// à [ScoreController] dès qu'une transition vers [WonEntity] ou [DrawEntity] est détectée.
  /// Séparé de [GameController] pour respecter le principe de responsabilité unique.
  const GameOutcomeRecorderProvider._({
    required GameOutcomeRecorderFamily super.from,
    required GameConfigEntity super.argument,
  }) : super(
         retry: null,
         name: r'gameOutcomeRecorderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameOutcomeRecorderHash();

  @override
  String toString() {
    return r'gameOutcomeRecorderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GameOutcomeRecorder create() => GameOutcomeRecorder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameOutcomeRecorderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameOutcomeRecorderHash() =>
    r'103067af1dc9d02e13981bee46549cbd6679873a';

/// Observateur des fins de partie chargé de persister le score.
///
/// Écoute [GameController] via [ref.listen] et délègue l'enregistrement
/// à [ScoreController] dès qu'une transition vers [WonEntity] ou [DrawEntity] est détectée.
/// Séparé de [GameController] pour respecter le principe de responsabilité unique.

final class GameOutcomeRecorderFamily extends $Family
    with
        $ClassFamilyOverride<
          GameOutcomeRecorder,
          void,
          void,
          void,
          GameConfigEntity
        > {
  const GameOutcomeRecorderFamily._()
    : super(
        retry: null,
        name: r'gameOutcomeRecorderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Observateur des fins de partie chargé de persister le score.
  ///
  /// Écoute [GameController] via [ref.listen] et délègue l'enregistrement
  /// à [ScoreController] dès qu'une transition vers [WonEntity] ou [DrawEntity] est détectée.
  /// Séparé de [GameController] pour respecter le principe de responsabilité unique.

  GameOutcomeRecorderProvider call(GameConfigEntity config) =>
      GameOutcomeRecorderProvider._(argument: config, from: this);

  @override
  String toString() => r'gameOutcomeRecorderProvider';
}

/// Observateur des fins de partie chargé de persister le score.
///
/// Écoute [GameController] via [ref.listen] et délègue l'enregistrement
/// à [ScoreController] dès qu'une transition vers [WonEntity] ou [DrawEntity] est détectée.
/// Séparé de [GameController] pour respecter le principe de responsabilité unique.

abstract class _$GameOutcomeRecorder extends $Notifier<void> {
  late final _$args = ref.$arg as GameConfigEntity;
  GameConfigEntity get config => _$args;

  void build(GameConfigEntity config);
  @$mustCallSuper
  @override
  void runBuild() {
    build(_$args);
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
