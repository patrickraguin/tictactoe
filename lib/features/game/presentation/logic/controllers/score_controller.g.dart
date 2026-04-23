// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gestionnaire d'état du score (Riverpod AsyncNotifier, keepAlive).
///
/// Charge le score depuis [ScoreRepository] à l'initialisation, expose
/// des méthodes de mutation ([recordWin], [recordLoss], [recordDraw], [reset])
/// qui mettent à jour l'état en mémoire puis persistent immédiatement sur disque.
///
/// Les transitions d'état sont loguées automatiquement par [AppProviderObserver].

@ProviderFor(ScoreController)
final scoreControllerProvider = ScoreControllerProvider._();

/// Gestionnaire d'état du score (Riverpod AsyncNotifier, keepAlive).
///
/// Charge le score depuis [ScoreRepository] à l'initialisation, expose
/// des méthodes de mutation ([recordWin], [recordLoss], [recordDraw], [reset])
/// qui mettent à jour l'état en mémoire puis persistent immédiatement sur disque.
///
/// Les transitions d'état sont loguées automatiquement par [AppProviderObserver].
final class ScoreControllerProvider
    extends $AsyncNotifierProvider<ScoreController, ScoreEntity> {
  /// Gestionnaire d'état du score (Riverpod AsyncNotifier, keepAlive).
  ///
  /// Charge le score depuis [ScoreRepository] à l'initialisation, expose
  /// des méthodes de mutation ([recordWin], [recordLoss], [recordDraw], [reset])
  /// qui mettent à jour l'état en mémoire puis persistent immédiatement sur disque.
  ///
  /// Les transitions d'état sont loguées automatiquement par [AppProviderObserver].
  ScoreControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scoreControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scoreControllerHash();

  @$internal
  @override
  ScoreController create() => ScoreController();
}

String _$scoreControllerHash() => r'2a3962b451c9e67ce4003c3635cf19175e5b60fb';

/// Gestionnaire d'état du score (Riverpod AsyncNotifier, keepAlive).
///
/// Charge le score depuis [ScoreRepository] à l'initialisation, expose
/// des méthodes de mutation ([recordWin], [recordLoss], [recordDraw], [reset])
/// qui mettent à jour l'état en mémoire puis persistent immédiatement sur disque.
///
/// Les transitions d'état sont loguées automatiquement par [AppProviderObserver].

abstract class _$ScoreController extends $AsyncNotifier<ScoreEntity> {
  FutureOr<ScoreEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ScoreEntity>, ScoreEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ScoreEntity>, ScoreEntity>,
              AsyncValue<ScoreEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
