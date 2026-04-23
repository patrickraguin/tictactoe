// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scoreRepository)
final scoreRepositoryProvider = ScoreRepositoryProvider._();

final class ScoreRepositoryProvider
    extends
        $FunctionalProvider<ScoreRepository, ScoreRepository, ScoreRepository>
    with $Provider<ScoreRepository> {
  ScoreRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scoreRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scoreRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScoreRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScoreRepository create(Ref ref) {
    return scoreRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoreRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoreRepository>(value),
    );
  }
}

String _$scoreRepositoryHash() => r'29dbdaa4b9da37570c334264592f04638c9d0ba9';
