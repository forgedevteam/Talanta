// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowState {

 bool get isFollowing; num get followerCount;
/// Create a copy of FollowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowStateCopyWith<FollowState> get copyWith => _$FollowStateCopyWithImpl<FollowState>(this as FollowState, _$identity);

  /// Serializes this FollowState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowState&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFollowing,followerCount);

@override
String toString() {
  return 'FollowState(isFollowing: $isFollowing, followerCount: $followerCount)';
}


}

/// @nodoc
abstract mixin class $FollowStateCopyWith<$Res>  {
  factory $FollowStateCopyWith(FollowState value, $Res Function(FollowState) _then) = _$FollowStateCopyWithImpl;
@useResult
$Res call({
 bool isFollowing, num followerCount
});




}
/// @nodoc
class _$FollowStateCopyWithImpl<$Res>
    implements $FollowStateCopyWith<$Res> {
  _$FollowStateCopyWithImpl(this._self, this._then);

  final FollowState _self;
  final $Res Function(FollowState) _then;

/// Create a copy of FollowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isFollowing = null,Object? followerCount = null,}) {
  return _then(_self.copyWith(
isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowState].
extension FollowStatePatterns on FollowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowState value)  $default,){
final _that = this;
switch (_that) {
case _FollowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowState value)?  $default,){
final _that = this;
switch (_that) {
case _FollowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isFollowing,  num followerCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowState() when $default != null:
return $default(_that.isFollowing,_that.followerCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isFollowing,  num followerCount)  $default,) {final _that = this;
switch (_that) {
case _FollowState():
return $default(_that.isFollowing,_that.followerCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isFollowing,  num followerCount)?  $default,) {final _that = this;
switch (_that) {
case _FollowState() when $default != null:
return $default(_that.isFollowing,_that.followerCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowState implements FollowState {
  const _FollowState({required this.isFollowing, required this.followerCount});
  factory _FollowState.fromJson(Map<String, dynamic> json) => _$FollowStateFromJson(json);

@override final  bool isFollowing;
@override final  num followerCount;

/// Create a copy of FollowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowStateCopyWith<_FollowState> get copyWith => __$FollowStateCopyWithImpl<_FollowState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowState&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFollowing,followerCount);

@override
String toString() {
  return 'FollowState(isFollowing: $isFollowing, followerCount: $followerCount)';
}


}

/// @nodoc
abstract mixin class _$FollowStateCopyWith<$Res> implements $FollowStateCopyWith<$Res> {
  factory _$FollowStateCopyWith(_FollowState value, $Res Function(_FollowState) _then) = __$FollowStateCopyWithImpl;
@override @useResult
$Res call({
 bool isFollowing, num followerCount
});




}
/// @nodoc
class __$FollowStateCopyWithImpl<$Res>
    implements _$FollowStateCopyWith<$Res> {
  __$FollowStateCopyWithImpl(this._self, this._then);

  final _FollowState _self;
  final $Res Function(_FollowState) _then;

/// Create a copy of FollowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isFollowing = null,Object? followerCount = null,}) {
  return _then(_FollowState(
isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
