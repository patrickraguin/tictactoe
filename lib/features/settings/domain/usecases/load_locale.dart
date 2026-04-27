import 'package:tictactoe/core/domain/use_case.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/settings/domain/entities/app_locale.dart';
import 'package:tictactoe/features/settings/domain/repositories/locale_repository.dart';

/// Charge la préférence de langue depuis le [LocaleRepository].
///
/// Retourne [AppLocale.system] si aucune préférence n'est enregistrée.
class LoadLocale implements AsyncUseCaseNoParams<AppLocale> {
  const LoadLocale(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Result<AppLocale>> call() => _repository.load();
}
