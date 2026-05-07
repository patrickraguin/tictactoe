import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';

void main() {
  group('isEmpty / isPlayed', () {
    test('empty is empty and not played', () {
      expect(CellMarkEnum.empty.isEmpty, isTrue);
      expect(CellMarkEnum.empty.isPlayed, isFalse);
    });

    test('x is played and not empty', () {
      expect(CellMarkEnum.x.isEmpty, isFalse);
      expect(CellMarkEnum.x.isPlayed, isTrue);
    });

    test('o is played and not empty', () {
      expect(CellMarkEnum.o.isEmpty, isFalse);
      expect(CellMarkEnum.o.isPlayed, isTrue);
    });
  });

  group('opponent', () {
    test('x opponent is o', () => expect(CellMarkEnum.x.opponent, CellMarkEnum.o));
    test('o opponent is x', () => expect(CellMarkEnum.o.opponent, CellMarkEnum.x));
    test('empty opponent is empty', () => expect(CellMarkEnum.empty.opponent, CellMarkEnum.empty));

    test('opponent is symmetric for x', () {
      expect(CellMarkEnum.x.opponent.opponent, CellMarkEnum.x);
    });

    test('opponent is symmetric for o', () {
      expect(CellMarkEnum.o.opponent.opponent, CellMarkEnum.o);
    });
  });
}
