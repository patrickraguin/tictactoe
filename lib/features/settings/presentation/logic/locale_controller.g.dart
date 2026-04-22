// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Contrôleur de la locale applicative (keepAlive).
///
/// Charge la préférence de langue depuis [LocaleRepository] à l'initialisation.
/// `null` signifie « utiliser la locale système ».

@ProviderFor(LocaleController)
const localeControllerProvider = LocaleControllerProvider._();

/// Contrôleur de la locale applicative (keepAlive).
///
/// Charge la préférence de langue depuis [LocaleRepository] à l'initialisation.
/// `null` signifie « utiliser la locale système ».
final class LocaleControllerProvider
    extends $AsyncNotifierProvider<LocaleController, Locale?> {
  /// Contrôleur de la locale applicative (keepAlive).
  ///
  /// Charge la préférence de langue depuis [LocaleRepository] à l'initialisation.
  /// `null` signifie « utiliser la locale système ».
  const LocaleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeControllerHash();

  @$internal
  @override
  LocaleController create() => LocaleController();
}

String _$localeControllerHash() => r'c86444329844ffab40413ac2889a6da78db6f0b1';

/// Contrôleur de la locale applicative (keepAlive).
///
/// Charge la préférence de langue depuis [LocaleRepository] à l'initialisation.
/// `null` signifie « utiliser la locale système ».

abstract class _$LocaleController extends $AsyncNotifier<Locale?> {
  FutureOr<Locale?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Locale?>, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Locale?>, Locale?>,
              AsyncValue<Locale?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
