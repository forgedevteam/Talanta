// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'username_availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsernameAvailability {

 String get username; UsernameStatus get status;
/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsernameAvailabilityCopyWith<UsernameAvailability> get copyWith => _$UsernameAvailabilityCopyWithImpl<UsernameAvailability>(this as UsernameAvailability, _$identity);

  /// Serializes this UsernameAvailability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsernameAvailability&&(identical(other.username, username) || other.username == username)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,status);

@override
String toString() {
  return 'UsernameAvailability(username: $username, status: $status)';
}


}

/// @nodoc
abstract mixin class $UsernameAvailabilityCopyWith<$Res>  {
  factory $UsernameAvailabilityCopyWith(UsernameAvailability value, $Res Function(UsernameAvailability) _then) = _$UsernameAvailabilityCopyWithImpl;
@useResult
$Res call({
 String username, UsernameStatus status
});




}
/// @nodoc
class _$UsernameAvailabilityCopyWithImpl<$Res>
    implements $UsernameAvailabilityCopyWith<$Res> {
  _$UsernameAvailabilityCopyWithImpl(this._self, this._then);

  final UsernameAvailability _self;
  final $Res Function(UsernameAvailability) _then;

/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? status = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UsernameStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UsernameAvailability].
extension UsernameAvailabilityPatterns on UsernameAvailability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsernameAvailability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsernameAvailability value)  $default,){
final _that = this;
switch (_that) {
case _UsernameAvailability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsernameAvailability value)?  $default,){
final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  UsernameStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
return $default(_that.username,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  UsernameStatus status)  $default,) {final _that = this;
switch (_that) {
case _UsernameAvailability():
return $default(_that.username,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  UsernameStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
return $default(_that.username,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsernameAvailability implements UsernameAvailability {
  const _UsernameAvailability({required this.username, required this.status});
  factory _UsernameAvailability.fromJson(Map<String, dynamic> json) => _$UsernameAvailabilityFromJson(json);

@override final  String username;
@override final  UsernameStatus status;

/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsernameAvailabilityCopyWith<_UsernameAvailability> get copyWith => __$UsernameAvailabilityCopyWithImpl<_UsernameAvailability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsernameAvailabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsernameAvailability&&(identical(other.username, username) || other.username == username)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,status);

@override
String toString() {
  return 'UsernameAvailability(username: $username, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UsernameAvailabilityCopyWith<$Res> implements $UsernameAvailabilityCopyWith<$Res> {
  factory _$UsernameAvailabilityCopyWith(_UsernameAvailability value, $Res Function(_UsernameAvailability) _then) = __$UsernameAvailabilityCopyWithImpl;
@override @useResult
$Res call({
 String username, UsernameStatus status
});




}
/// @nodoc
class __$UsernameAvailabilityCopyWithImpl<$Res>
    implements _$UsernameAvailabilityCopyWith<$Res> {
  __$UsernameAvailabilityCopyWithImpl(this._self, this._then);

  final _UsernameAvailability _self;
  final $Res Function(_UsernameAvailability) _then;

/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? status = null,}) {
  return _then(_UsernameAvailability(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UsernameStatus,
  ));
}


}

// dart format on
