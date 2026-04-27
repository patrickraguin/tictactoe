import 'package:tictactoe/core/domain/use_case.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/settings/domain/entities/app_locale.dart';
import 'package:tictactoe/features/settings/domain/repositories/locale_repository.dart';

/// Persiste la préférence de langue via le [LocaleRepository].
class SetLocale implements AsyncUseCase<AppLocale, void> {
  const SetLocale(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Result<void>> call(AppLocale params) => _repository.save(params);
}
