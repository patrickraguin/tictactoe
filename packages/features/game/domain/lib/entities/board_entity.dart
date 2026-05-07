import 'package:game_domain/entities/cell_mark_enum.dart';
import 'package:meta/meta.dart';

/// Plateau de jeu immutable représentant la grille 3×3.
///
/// Chaque cellule contient un [CellMarkEnum]. Toutes les opérations
/// retournent un nouveau [BoardEntity] sans modifier l'état courant.
///
/// **Pourquoi @immutable plutôt que Freezed ?**
/// [BoardEntity] impose un invariant fort : exactement [cellCount] (9) cellules
/// non-nullables. Freezed génère une `List<T>` ordinaire sans contrainte de
/// taille, nécessiterait un `@Assert` manuel, et ne fournirait pas de gain
/// en lisibilité. L'égalité et le `hashCode` sont implémentés manuellement
/// en O(n) sur les cellules, ce qui est suffisant et explicite.
@immutable
class BoardEntity {
  BoardEntity(List<CellMarkEnum> cells)
      : assert(cells.length == size * size, 'BoardEntity must have ${size * size} cells'),
        _cells = List.unmodifiable(cells);

  BoardEntity.empty()
      : _cells = List.unmodifiable(
          List<CellMarkEnum>.filled(size * size, CellMarkEnum.empty),
        );

  static const int size = 3;
  static const int cellCount = size * size;

  static const List<List<int>> winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  final List<CellMarkEnum> _cells;

  List<CellMarkEnum> get cells => _cells;

  CellMarkEnum cellAt(int index) => _cells[index];

  bool get isFull => _cells.every((c) => c.isPlayed);

  List<int> get availableMoves => [
        for (var i = 0; i < _cells.length; i++)
          if (_cells[i].isEmpty) i,
      ];

  BoardEntity place(int index, CellMarkEnum mark) {
    assert(_cells[index].isEmpty, 'Cell $index is already occupied');
    assert(mark.isPlayed, 'Cannot place an empty mark');
    final next = List<CellMarkEnum>.of(_cells);
    next[index] = mark;
    return BoardEntity(next);
  }

  /// Returns the winning line (list of indices) for [mark], or null.
  List<int>? winningLineFor(CellMarkEnum mark) {
    if (mark.isEmpty) return null;
    for (final line in winningLines) {
      if (line.every((i) => _cells[i] == mark)) return line;
    }
    return null;
  }

  CellMarkEnum? get winner {
    for (final mark in [CellMarkEnum.x, CellMarkEnum.o]) {
      if (winningLineFor(mark) != null) return mark;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BoardEntity &&
          _cells.length == other._cells.length &&
          Iterable<int>.generate(_cells.length)
              .every((i) => _cells[i] == other._cells[i]));

  @override
  int get hashCode => Object.hashAll(_cells);

  @override
  String toString() {
    String sym(CellMarkEnum c) => switch (c) {
          CellMarkEnum.x => 'X',
          CellMarkEnum.o => 'O',
          CellMarkEnum.empty => '.',
        };
    final rows = <String>[];
    for (var r = 0; r < size; r++) {
      rows.add(_cells.sublist(r * size, (r + 1) * size).map(sym).join(' '));
    }
    return rows.join('\n');
  }
}
