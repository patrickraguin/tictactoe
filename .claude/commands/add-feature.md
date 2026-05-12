# Ajouter une feature — Guide pas-à-pas

## Step 0 : Décider le périmètre

- Nouvelle préoccupation (ex: achievements, historique) → nouveaux packages domain/data/presentation
- Extension d'une feature existante → ajouter dans les packages existants

---

## Step 1 : Package `domain/`

**Location** : `packages/features/<nom>/domain/`

```
lib/
  entities/<nom>_entity.dart       # Freezed @freezed ou @immutable selon besoin
  repositories/<nom>_repository.dart  # abstract interface class
  usecases/<verbe>_<nom>.dart      # implements UseCase ou AsyncUseCase
```

**Choix d'entity** :
- `@freezed` : value object avec `copyWith`, égalité structurelle (cas par défaut)
- `@immutable` (manuel) : invariants forts à valider dans le constructeur (ex: taille de tableau)
- `@freezed sealed class` : union type (ex: état machine à états)

**pubspec.yaml du domain** : ne dépend que de `core`. Zéro Flutter.

---

## Step 2 : Package `data/`

**Location** : `packages/features/<nom>/data/`

```
lib/
  datasources/<nom>_local_datasource.dart  # wrapper SharedPreferences
  repositories/<nom>_repository_impl.dart  # implements interface domain
```

Convention de clé SharedPreferences : `'<entité>.v<version_schema>'`  
Si le schéma JSON change, incrémenter la version et migrer dans le datasource.

---

## Step 3 : Package `presentation/`

**Location** : `packages/features/<nom>/presentation/`

```
lib/
  logic/
    providers/<nom>_providers.dart   # repository provider avec UnimplementedError
    controllers/<nom>_controller.dart  # Notifier ou AsyncNotifier
    <nom>_ui_state.dart              # Freezed si état UI composite
  pages/<nom>_page.dart              # @RoutePage() StatelessWidget ou ConsumerWidget
  widgets/                           # widgets de la feature
  router.dart                        # RouteContributor
  router.gr.dart                     # généré par codegen
```

**Arbre de décision pour le controller** :

```
Opération async (repository, I/O) ?
  Oui → AsyncNotifier
    Persisté au niveau app (score, locale) ?
      Oui → @Riverpod(keepAlive: true)
      Non → @riverpod (autoDispose par défaut)
  Non → Notifier (sync-only)
    Codegen peut résoudre le type d'état Freezed ?
      Oui → @riverpod
      Non → déclaration manuelle NotifierProvider.autoDispose

Besoin d'observer un autre controller sans en être responsable ?
  → Notifier void séparé avec ref.listen (comme GameOutcomeRecorder)
```

**Provider repository** :

```dart
// lib/logic/providers/<nom>_providers.dart
@Riverpod(keepAlive: true)
NomRepository nomRepository(Ref ref) => throw UnimplementedError(
  'nomRepositoryProvider must be overridden in ProviderScope',
);
```

---

## Step 4 : Wiring du monorepo

### 4a. `root/pubspec.yaml` — workspace

```yaml
workspace:
  - packages/features/<nom>/domain
  - packages/features/<nom>/data
  - packages/features/<nom>/presentation
```

### 4b. `lib/di/` ou dépendances inter-packages

Ajouter les `path` dependencies dans les `pubspec.yaml` de chaque couche.

### 4c. `lib/main.dart` — ProviderScope override

```dart
overrides: [
  nomRepositoryProvider.overrideWith(
    (ref) => NomRepositoryImpl(ref.watch(sharedPreferencesInstanceProvider)),
  ),
],
```

### 4d. `lib/app/app.dart` — AppRouter

```dart
AppRouter([
  GamePresentationRouter(),
  SettingsPresentationRouter(),
  NomPresentationRouter(),  // ← ajouter ici
])
```

### 4e. `lib/main.dart` — controllers app-wide (si keepAlive)

Initialiser le controller keepAlive dans `ProviderScope` (via `ProviderContainer` ou `ref.read` dans un widget root).

---

## Step 5 : Code generation

```bash
melos run codegen
```

Après toute modification de `@freezed`, `@RoutePage()`, `@riverpod`, ou `@Riverpod`.

---

## Step 6 : Internationalisation

1. Ajouter les clés dans `packages/core/lib/l10n/intl_fr.arb` et `intl_en.arb`
2. Générer : `flutter gen-l10n` (ou `melos run codegen` qui l'inclut)
3. Accéder via `context.l10n.<clé>` dans les widgets

---

## Checklist avant merge

- [ ] domain : entity + repository interface + use case(s) + tests
- [ ] data : datasource + repository impl + tests
- [ ] presentation : provider + controller + page(s) + router
- [ ] root `pubspec.yaml` workspace mis à jour
- [ ] `lib/main.dart` : ProviderScope override du repository
- [ ] `lib/app/app.dart` : RouteContributor enregistré
- [ ] Controller keepAlive initialisé si nécessaire
- [ ] Strings l10n dans les deux fichiers ARB
- [ ] `melos run codegen` — aucun fichier `.g.dart` / `.freezed.dart` obsolète
- [ ] `melos run test:all` — vert
- [ ] `melos run analyze` — vert
