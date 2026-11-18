// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_avatar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetAvatar {

/// A photo I uploaded with purpose=avatar.
 String get mediaId;
/// Create a copy of SetAvatar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetAvatarCopyWith<SetAvatar> get copyWith => _$SetAvatarCopyWithImpl<SetAvatar>(this as SetAvatar, _$identity);

  /// Serializes this SetAvatar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetAvatar&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaId);

@override
String toString() {
  return 'SetAvatar(mediaId: $mediaId)';
}


}

/// @nodoc
abstract mixin class $SetAvatarCopyWith<$Res>  {
  factory $SetAvatarCopyWith(SetAvatar value, $Res Function(SetAvatar) _then) = _$SetAvatarCopyWithImpl;
@useResult
$Res call({
 String mediaId
});




}
/// @nodoc
class _$SetAvatarCopyWithImpl<$Res>
    implements $SetAvatarCopyWith<$Res> {
  _$SetAvatarCopyWithImpl(this._self, this._then);

  final SetAvatar _self;
  final $Res Function(SetAvatar) _then;

/// Create a copy of SetAvatar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaId = null,}) {
  return _then(_self.copyWith(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SetAvatar].
extension SetAvatarPatterns on SetAvatar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetAvatar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetAvatar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetAvatar value)  $default,){
final _that = this;
switch (_that) {
case _SetAvatar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetAvatar value)?  $default,){
final _that = this;
switch (_that) {
case _SetAvatar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mediaId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetAvatar() when $default != null:
return $default(_that.mediaId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mediaId)  $default,) {final _that = this;
switch (_that) {
case _SetAvatar():
return $default(_that.mediaId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mediaId)?  $default,) {final _that = this;
switch (_that) {
case _SetAvatar() when $default != null:
return $default(_that.mediaId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetAvatar implements SetAvatar {
  const _SetAvatar({required this.mediaId});
  factory _SetAvatar.fromJson(Map<String, dynamic> json) => _$SetAvatarFromJson(json);

/// A photo I uploaded with purpose=avatar.
@override final  String mediaId;

/// Create a copy of SetAvatar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetAvatarCopyWith<_SetAvatar> get copyWith => __$SetAvatarCopyWithImpl<_SetAvatar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetAvatarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetAvatar&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaId);

@override
String toString() {
  return 'SetAvatar(mediaId: $mediaId)';
}


}

/// @nodoc
abstract mixin class _$SetAvatarCopyWith<$Res> implements $SetAvatarCopyWith<$Res> {
  factory _$SetAvatarCopyWith(_SetAvatar value, $Res Function(_SetAvatar) _then) = __$SetAvatarCopyWithImpl;
@override @useResult
$Res call({
 String mediaId
});




}
/// @nodoc
class __$SetAvatarCopyWithImpl<$Res>
    implements _$SetAvatarCopyWith<$Res> {
  __$SetAvatarCopyWithImpl(this._self, this._then);

  final _SetAvatar _self;
  final $Res Function(_SetAvatar) _then;

/// Create a copy of SetAvatar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaId = null,}) {
  return _then(_SetAvatar(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
