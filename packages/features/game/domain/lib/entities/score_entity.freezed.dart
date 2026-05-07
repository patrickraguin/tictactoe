// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScoreEntity {

 int get wins; int get losses; int get draws;
/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreEntityCopyWith<ScoreEntity> get copyWith => _$ScoreEntityCopyWithImpl<ScoreEntity>(this as ScoreEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreEntity&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.losses, losses) || other.losses == losses)&&(identical(other.draws, draws) || other.draws == draws));
}


@override
int get hashCode => Object.hash(runtimeType,wins,losses,draws);

@override
String toString() {
  return 'ScoreEntity(wins: $wins, losses: $losses, draws: $draws)';
}


}

/// @nodoc
abstract mixin class $ScoreEntityCopyWith<$Res>  {
  factory $ScoreEntityCopyWith(ScoreEntity value, $Res Function(ScoreEntity) _then) = _$ScoreEntityCopyWithImpl;
@useResult
$Res call({
 int wins, int losses, int draws
});




}
/// @nodoc
class _$ScoreEntityCopyWithImpl<$Res>
    implements $ScoreEntityCopyWith<$Res> {
  _$ScoreEntityCopyWithImpl(this._self, this._then);

  final ScoreEntity _self;
  final $Res Function(ScoreEntity) _then;

/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wins = null,Object? losses = null,Object? draws = null,}) {
  return _then(_self.copyWith(
wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreEntity].
extension ScoreEntityPatterns on ScoreEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreEntity value)  $default,){
final _that = this;
switch (_that) {
case _ScoreEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int wins,  int losses,  int draws)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
return $default(_that.wins,_that.losses,_that.draws);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int wins,  int losses,  int draws)  $default,) {final _that = this;
switch (_that) {
case _ScoreEntity():
return $default(_that.wins,_that.losses,_that.draws);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int wins,  int losses,  int draws)?  $default,) {final _that = this;
switch (_that) {
case _ScoreEntity() when $default != null:
return $default(_that.wins,_that.losses,_that.draws);case _:
  return null;

}
}

}

/// @nodoc


class _ScoreEntity implements ScoreEntity {
  const _ScoreEntity({this.wins = 0, this.losses = 0, this.draws = 0});
  

@override@JsonKey() final  int wins;
@override@JsonKey() final  int losses;
@override@JsonKey() final  int draws;

/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreEntityCopyWith<_ScoreEntity> get copyWith => __$ScoreEntityCopyWithImpl<_ScoreEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreEntity&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.losses, losses) || other.losses == losses)&&(identical(other.draws, draws) || other.draws == draws));
}


@override
int get hashCode => Object.hash(runtimeType,wins,losses,draws);

@override
String toString() {
  return 'ScoreEntity(wins: $wins, losses: $losses, draws: $draws)';
}


}

/// @nodoc
abstract mixin class _$ScoreEntityCopyWith<$Res> implements $ScoreEntityCopyWith<$Res> {
  factory _$ScoreEntityCopyWith(_ScoreEntity value, $Res Function(_ScoreEntity) _then) = __$ScoreEntityCopyWithImpl;
@override @useResult
$Res call({
 int wins, int losses, int draws
});




}
/// @nodoc
class __$ScoreEntityCopyWithImpl<$Res>
    implements _$ScoreEntityCopyWith<$Res> {
  __$ScoreEntityCopyWithImpl(this._self, this._then);

  final _ScoreEntity _self;
  final $Res Function(_ScoreEntity) _then;

/// Create a copy of ScoreEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wins = null,Object? losses = null,Object? draws = null,}) {
  return _then(_ScoreEntity(
wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
