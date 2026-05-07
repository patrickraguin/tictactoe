import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_provider.g.dart';

/// Fournit les informations du package (version, build number) depuis la plateforme.
/// Mis en cache pour toute la durée de vie de l'application.
@Riverpod(keepAlive: true)
Future<PackageInfo> packageInfo(Ref ref) => PackageInfo.fromPlatform();
