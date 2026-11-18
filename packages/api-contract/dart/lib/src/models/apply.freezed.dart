// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Apply {

 String get message;/// A piece from your portfolio to show.
 String? get portfolioItemId;
/// Create a copy of Apply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyCopyWith<Apply> get copyWith => _$ApplyCopyWithImpl<Apply>(this as Apply, _$identity);

  /// Serializes this Apply to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Apply&&(identical(other.message, message) || other.message == message)&&(identical(other.portfolioItemId, portfolioItemId) || other.portfolioItemId == portfolioItemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,portfolioItemId);

@override
String toString() {
  return 'Apply(message: $message, portfolioItemId: $portfolioItemId)';
}


}

/// @nodoc
abstract mixin class $ApplyCopyWith<$Res>  {
  factory $ApplyCopyWith(Apply value, $Res Function(Apply) _then) = _$ApplyCopyWithImpl;
@useResult
$Res call({
 String message, String? portfolioItemId
});




}
/// @nodoc
class _$ApplyCopyWithImpl<$Res>
    implements $ApplyCopyWith<$Res> {
  _$ApplyCopyWithImpl(this._self, this._then);

  final Apply _self;
  final $Res Function(Apply) _then;

/// Create a copy of Apply
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? portfolioItemId = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,portfolioItemId: freezed == portfolioItemId ? _self.portfolioItemId : portfolioItemId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Apply].
extension ApplyPatterns on Apply {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Apply value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Apply() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Apply value)  $default,){
final _that = this;
switch (_that) {
case _Apply():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Apply value)?  $default,){
final _that = this;
switch (_that) {
case _Apply() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  String? portfolioItemId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Apply() when $default != null:
return $default(_that.message,_that.portfolioItemId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  String? portfolioItemId)  $default,) {final _that = this;
switch (_that) {
case _Apply():
return $default(_that.message,_that.portfolioItemId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  String? portfolioItemId)?  $default,) {final _that = this;
switch (_that) {
case _Apply() when $default != null:
return $default(_that.message,_that.portfolioItemId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Apply implements Apply {
  const _Apply({required this.message, this.portfolioItemId});
  factory _Apply.fromJson(Map<String, dynamic> json) => _$ApplyFromJson(json);

@override final  String message;
/// A piece from your portfolio to show.
@override final  String? portfolioItemId;

/// Create a copy of Apply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyCopyWith<_Apply> get copyWith => __$ApplyCopyWithImpl<_Apply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Apply&&(identical(other.message, message) || other.message == message)&&(identical(other.portfolioItemId, portfolioItemId) || other.portfolioItemId == portfolioItemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,portfolioItemId);

@override
String toString() {
  return 'Apply(message: $message, portfolioItemId: $portfolioItemId)';
}


}

/// @nodoc
abstract mixin class _$ApplyCopyWith<$Res> implements $ApplyCopyWith<$Res> {
  factory _$ApplyCopyWith(_Apply value, $Res Function(_Apply) _then) = __$ApplyCopyWithImpl;
@override @useResult
$Res call({
 String message, String? portfolioItemId
});




}
/// @nodoc
class __$ApplyCopyWithImpl<$Res>
    implements _$ApplyCopyWith<$Res> {
  __$ApplyCopyWithImpl(this._self, this._then);

  final _Apply _self;
  final $Res Function(_Apply) _then;

/// Create a copy of Apply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? portfolioItemId = freezed,}) {
  return _then(_Apply(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,portfolioItemId: freezed == portfolioItemId ? _self.portfolioItemId : portfolioItemId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
