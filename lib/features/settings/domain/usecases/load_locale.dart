import '../../../../core/domain/use_case.dart';
import '../../../../core/result/result.dart';
import '../entities/app_locale.dart';
import '../repositories/locale_repository.dart';

/// Charge la préférence de langue depuis le [LocaleRepository].
///
/// Retourne [AppLocale.system] si aucune préférence n'est enregistrée.
class LoadLocale implements AsyncUseCaseNoParams<AppLocale> {
  const LoadLocale(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Result<AppLocale>> call() => _repository.load();
}
