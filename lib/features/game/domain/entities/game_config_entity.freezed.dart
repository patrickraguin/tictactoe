// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_config_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameConfigEntity {

 CellMarkEnum get humanMark; TypePlayerEnum get firstPlayer; DifficultyEnum get difficulty;
/// Create a copy of GameConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameConfigEntityCopyWith<GameConfigEntity> get copyWith => _$GameConfigEntityCopyWithImpl<GameConfigEntity>(this as GameConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameConfigEntity&&(identical(other.humanMark, humanMark) || other.humanMark == humanMark)&&(identical(other.firstPlayer, firstPlayer) || other.firstPlayer == firstPlayer)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}


@override
int get hashCode => Object.hash(runtimeType,humanMark,firstPlayer,difficulty);

@override
String toString() {
  return 'GameConfigEntity(humanMark: $humanMark, firstPlayer: $firstPlayer, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class $GameConfigEntityCopyWith<$Res>  {
  factory $GameConfigEntityCopyWith(GameConfigEntity value, $Res Function(GameConfigEntity) _then) = _$GameConfigEntityCopyWithImpl;
@useResult
$Res call({
 CellMarkEnum humanMark, TypePlayerEnum firstPlayer, DifficultyEnum difficulty
});




}
/// @nodoc
class _$GameConfigEntityCopyWithImpl<$Res>
    implements $GameConfigEntityCopyWith<$Res> {
  _$GameConfigEntityCopyWithImpl(this._self, this._then);

  final GameConfigEntity _self;
  final $Res Function(GameConfigEntity) _then;

/// Create a copy of GameConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? humanMark = null,Object? firstPlayer = null,Object? difficulty = null,}) {
  return _then(_self.copyWith(
humanMark: null == humanMark ? _self.humanMark : humanMark // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,firstPlayer: null == firstPlayer ? _self.firstPlayer : firstPlayer // ignore: cast_nullable_to_non_nullable
as TypePlayerEnum,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,
  ));
}

}


/// Adds pattern-matching-related methods to [GameConfigEntity].
extension GameConfigEntityPatterns on GameConfigEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameConfigEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameConfigEntity() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameConfigEntity value)  $default,){
final _that = this;
switch (_that) {
case _GameConfigEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameConfigEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GameConfigEntity() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CellMarkEnum humanMark,  TypePlayerEnum firstPlayer,  DifficultyEnum difficulty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameConfigEntity() when $default != null:
return $default(_that.humanMark,_that.firstPlayer,_that.difficulty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CellMarkEnum humanMark,  TypePlayerEnum firstPlayer,  DifficultyEnum difficulty)  $default,) {final _that = this;
switch (_that) {
case _GameConfigEntity():
return $default(_that.humanMark,_that.firstPlayer,_that.difficulty);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CellMarkEnum humanMark,  TypePlayerEnum firstPlayer,  DifficultyEnum difficulty)?  $default,) {final _that = this;
switch (_that) {
case _GameConfigEntity() when $default != null:
return $default(_that.humanMark,_that.firstPlayer,_that.difficulty);case _:
  return null;

}
}

}

/// @nodoc


class _GameConfigEntity implements GameConfigEntity {
  const _GameConfigEntity({required this.humanMark, required this.firstPlayer, required this.difficulty});
  

@override final  CellMarkEnum humanMark;
@override final  TypePlayerEnum firstPlayer;
@override final  DifficultyEnum difficulty;

/// Create a copy of GameConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameConfigEntityCopyWith<_GameConfigEntity> get copyWith => __$GameConfigEntityCopyWithImpl<_GameConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameConfigEntity&&(identical(other.humanMark, humanMark) || other.humanMark == humanMark)&&(identical(other.firstPlayer, firstPlayer) || other.firstPlayer == firstPlayer)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}


@override
int get hashCode => Object.hash(runtimeType,humanMark,firstPlayer,difficulty);

@override
String toString() {
  return 'GameConfigEntity(humanMark: $humanMark, firstPlayer: $firstPlayer, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class _$GameConfigEntityCopyWith<$Res> implements $GameConfigEntityCopyWith<$Res> {
  factory _$GameConfigEntityCopyWith(_GameConfigEntity value, $Res Function(_GameConfigEntity) _then) = __$GameConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 CellMarkEnum humanMark, TypePlayerEnum firstPlayer, DifficultyEnum difficulty
});




}
/// @nodoc
class __$GameConfigEntityCopyWithImpl<$Res>
    implements _$GameConfigEntityCopyWith<$Res> {
  __$GameConfigEntityCopyWithImpl(this._self, this._then);

  final _GameConfigEntity _self;
  final $Res Function(_GameConfigEntity) _then;

/// Create a copy of GameConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? humanMark = null,Object? firstPlayer = null,Object? difficulty = null,}) {
  return _then(_GameConfigEntity(
humanMark: null == humanMark ? _self.humanMark : humanMark // ignore: cast_nullable_to_non_nullable
as CellMarkEnum,firstPlayer: null == firstPlayer ? _self.firstPlayer : firstPlayer // ignore: cast_nullable_to_non_nullable
as TypePlayerEnum,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,
  ));
}


}

// dart format on
