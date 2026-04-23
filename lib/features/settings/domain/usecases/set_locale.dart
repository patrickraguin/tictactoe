import '../../../../core/domain/use_case.dart';
import '../../../../core/result/result.dart';
import '../entities/app_locale.dart';
import '../repositories/locale_repository.dart';

/// Persiste la préférence de langue via le [LocaleRepository].
class SetLocale implements AsyncUseCase<AppLocale, void> {
  const SetLocale(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Result<void>> call(AppLocale params) => _repository.save(params);
}
