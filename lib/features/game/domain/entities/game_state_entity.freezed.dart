// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameStateEntity {

 BoardEntity get board; CellMarkEnum get humanMark;
/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateEntityCopyWith<GameStateEntity> get copyWith => _$GameStateEntityCopyWithImpl<GameStateEntity>(this as GameStateEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStateEntity&&(identical(other.board, board) || other.board == board)&&(identical(other.humanMark, humanMark) || other.humanMark == humanMark));
}


@override
int get hashCode => Object.hash(runtimeType,board,humanMark);

@override
String toString() {
  return 'GameStateEntity(board: $board, humanMark: $humanMark)';
}


}

/// @nodoc
abstract mixin class $GameStateEntityCopyWith<$Res>  {
  factory $GameStateEntityCopyWith(GameStateEntity value, $Res Function(GameStateEntity) _then) = _$GameStateEntityCopyWithImpl;
@useResult
$Res call({
 BoardEntity board, CellMarkEnum humanMark
});




}
/// @nodoc
class _$GameStateEntityCopyWithImpl<$Res>
    implements $GameStateEntityCopyWith<$Res> {
  _$GameStateEntityCopyWithImpl(this._self, this._then);

  final GameStateEntity _self;
  final $Res Function(GameStateEntity) _then;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? humanMark = null,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardEntity,humanMark: null == humanMark ? _self.humanMark : humanMark // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,
  ));
}

}


/// Adds pattern-matching-related methods to [GameStateEntity].
extension GameStateEntityPatterns on GameStateEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InProgressEntity value)?  inProgress,TResult Function( WonEntity value)?  won,TResult Function( DrawEntity value)?  draw,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InProgressEntity() when inProgress != null:
return inProgress(_that);case WonEntity() when won != null:
return won(_that);case DrawEntity() when draw != null:
return draw(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InProgressEntity value)  inProgress,required TResult Function( WonEntity value)  won,required TResult Function( DrawEntity value)  draw,}){
final _that = this;
switch (_that) {
case InProgressEntity():
return inProgress(_that);case WonEntity():
return won(_that);case DrawEntity():
return draw(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InProgressEntity value)?  inProgress,TResult? Function( WonEntity value)?  won,TResult? Function( DrawEntity value)?  draw,}){
final _that = this;
switch (_that) {
case InProgressEntity() when inProgress != null:
return inProgress(_that);case WonEntity() when won != null:
return won(_that);case DrawEntity() when draw != null:
return draw(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BoardEntity board,  CellMarkEnum turn,  CellMarkEnum humanMark,  bool cpuThinking)?  inProgress,TResult Function( BoardEntity board,  CellMarkEnum winner,  List<int> line,  CellMarkEnum humanMark)?  won,TResult Function( BoardEntity board,  CellMarkEnum humanMark)?  draw,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InProgressEntity() when inProgress != null:
return inProgress(_that.board,_that.turn,_that.humanMark,_that.cpuThinking);case WonEntity() when won != null:
return won(_that.board,_that.winner,_that.line,_that.humanMark);case DrawEntity() when draw != null:
return draw(_that.board,_that.humanMark);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BoardEntity board,  CellMarkEnum turn,  CellMarkEnum humanMark,  bool cpuThinking)  inProgress,required TResult Function( BoardEntity board,  CellMarkEnum winner,  List<int> line,  CellMarkEnum humanMark)  won,required TResult Function( BoardEntity board,  CellMarkEnum humanMark)  draw,}) {final _that = this;
switch (_that) {
case InProgressEntity():
return inProgress(_that.board,_that.turn,_that.humanMark,_that.cpuThinking);case WonEntity():
return won(_that.board,_that.winner,_that.line,_that.humanMark);case DrawEntity():
return draw(_that.board,_that.humanMark);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BoardEntity board,  CellMarkEnum turn,  CellMarkEnum humanMark,  bool cpuThinking)?  inProgress,TResult? Function( BoardEntity board,  CellMarkEnum winner,  List<int> line,  CellMarkEnum humanMark)?  won,TResult? Function( BoardEntity board,  CellMarkEnum humanMark)?  draw,}) {final _that = this;
switch (_that) {
case InProgressEntity() when inProgress != null:
return inProgress(_that.board,_that.turn,_that.humanMark,_that.cpuThinking);case WonEntity() when won != null:
return won(_that.board,_that.winner,_that.line,_that.humanMark);case DrawEntity() when draw != null:
return draw(_that.board,_that.humanMark);case _:
  return null;

}
}

}

/// @nodoc


class InProgressEntity extends GameStateEntity {
  const InProgressEntity({required this.board, required this.turn, required this.humanMark, this.cpuThinking = false}): super._();
  

@override final  BoardEntity board;
 final  CellMarkEnum turn;
@override final  CellMarkEnum humanMark;
@JsonKey() final  bool cpuThinking;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InProgressEntityCopyWith<InProgressEntity> get copyWith => _$InProgressEntityCopyWithImpl<InProgressEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InProgressEntity&&(identical(other.board, board) || other.board == board)&&(identical(other.turn, turn) || other.turn == turn)&&(identical(other.humanMark, humanMark) || other.humanMark == humanMark)&&(identical(other.cpuThinking, cpuThinking) || other.cpuThinking == cpuThinking));
}


@override
int get hashCode => Object.hash(runtimeType,board,turn,humanMark,cpuThinking);

@override
String toString() {
  return 'GameStateEntity.inProgress(board: $board, turn: $turn, humanMark: $humanMark, cpuThinking: $cpuThinking)';
}


}

/// @nodoc
abstract mixin class $InProgressEntityCopyWith<$Res> implements $GameStateEntityCopyWith<$Res> {
  factory $InProgressEntityCopyWith(InProgressEntity value, $Res Function(InProgressEntity) _then) = _$InProgressEntityCopyWithImpl;
@override @useResult
$Res call({
 BoardEntity board, CellMarkEnum turn, CellMarkEnum humanMark, bool cpuThinking
});




}
/// @nodoc
class _$InProgressEntityCopyWithImpl<$Res>
    implements $InProgressEntityCopyWith<$Res> {
  _$InProgressEntityCopyWithImpl(this._self, this._then);

  final InProgressEntity _self;
  final $Res Function(InProgressEntity) _then;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? turn = null,Object? humanMark = null,Object? cpuThinking = null,}) {
  return _then(InProgressEntity(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardEntity,turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,humanMark: null == humanMark ? _self.humanMark : humanMark // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,cpuThinking: null == cpuThinking ? _self.cpuThinking : cpuThinking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class WonEntity extends GameStateEntity {
  const WonEntity({required this.board, required this.winner, required final  List<int> line, required this.humanMark}): _line = line,super._();
  

@override final  BoardEntity board;
 final  CellMarkEnum winner;
 final  List<int> _line;
 List<int> get line {
  if (_line is EqualUnmodifiableListView) return _line;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_line);
}

@override final  CellMarkEnum humanMark;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WonEntityCopyWith<WonEntity> get copyWith => _$WonEntityCopyWithImpl<WonEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WonEntity&&(identical(other.board, board) || other.board == board)&&(identical(other.winner, winner) || other.winner == winner)&&const DeepCollectionEquality().equals(other._line, _line)&&(identical(other.humanMark, humanMark) || other.humanMark == humanMark));
}


@override
int get hashCode => Object.hash(runtimeType,board,winner,const DeepCollectionEquality().hash(_line),humanMark);

@override
String toString() {
  return 'GameStateEntity.won(board: $board, winner: $winner, line: $line, humanMark: $humanMark)';
}


}

/// @nodoc
abstract mixin class $WonEntityCopyWith<$Res> implements $GameStateEntityCopyWith<$Res> {
  factory $WonEntityCopyWith(WonEntity value, $Res Function(WonEntity) _then) = _$WonEntityCopyWithImpl;
@override @useResult
$Res call({
 BoardEntity board, CellMarkEnum winner, List<int> line, CellMarkEnum humanMark
});




}
/// @nodoc
class _$WonEntityCopyWithImpl<$Res>
    implements $WonEntityCopyWith<$Res> {
  _$WonEntityCopyWithImpl(this._self, this._then);

  final WonEntity _self;
  final $Res Function(WonEntity) _then;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? winner = null,Object? line = null,Object? humanMark = null,}) {
  return _then(WonEntity(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardEntity,winner: null == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,line: null == line ? _self._line : line // ignore: cast_nullable_to_non_nullable
as List<int>,humanMark: null == humanMark ? _self.humanMark : humanMark // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,
  ));
}


}

/// @nodoc


class DrawEntity extends GameStateEntity {
  const DrawEntity({required this.board, required this.humanMark}): super._();
  

@override final  BoardEntity board;
@override final  CellMarkEnum humanMark;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawEntityCopyWith<DrawEntity> get copyWith => _$DrawEntityCopyWithImpl<DrawEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawEntity&&(identical(other.board, board) || other.board == board)&&(identical(other.humanMark, humanMark) || other.humanMark == humanMark));
}


@override
int get hashCode => Object.hash(runtimeType,board,humanMark);

@override
String toString() {
  return 'GameStateEntity.draw(board: $board, humanMark: $humanMark)';
}


}

/// @nodoc
abstract mixin class $DrawEntityCopyWith<$Res> implements $GameStateEntityCopyWith<$Res> {
  factory $DrawEntityCopyWith(DrawEntity value, $Res Function(DrawEntity) _then) = _$DrawEntityCopyWithImpl;
@override @useResult
$Res call({
 BoardEntity board, CellMarkEnum humanMark
});




}
/// @nodoc
class _$DrawEntityCopyWithImpl<$Res>
    implements $DrawEntityCopyWith<$Res> {
  _$DrawEntityCopyWithImpl(this._self, this._then);

  final DrawEntity _self;
  final $Res Function(DrawEntity) _then;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? humanMark = null,}) {
  return _then(DrawEntity(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardEntity,humanMark: null == humanMark ? _self.humanMark : humanMark // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,
  ));
}


}

// dart format on
