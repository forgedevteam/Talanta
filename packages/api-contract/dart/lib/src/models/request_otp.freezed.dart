// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_otp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestOtp {

/// As typed: national format together with `country`, or full international format.
 String get phone;/// ISO 3166-1 alpha-2 country chosen in the picker.
 String? get country;
/// Create a copy of RequestOtp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestOtpCopyWith<RequestOtp> get copyWith => _$RequestOtpCopyWithImpl<RequestOtp>(this as RequestOtp, _$identity);

  /// Serializes this RequestOtp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestOtp&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,country);

@override
String toString() {
  return 'RequestOtp(phone: $phone, country: $country)';
}


}

/// @nodoc
abstract mixin class $RequestOtpCopyWith<$Res>  {
  factory $RequestOtpCopyWith(RequestOtp value, $Res Function(RequestOtp) _then) = _$RequestOtpCopyWithImpl;
@useResult
$Res call({
 String phone, String? country
});




}
/// @nodoc
class _$RequestOtpCopyWithImpl<$Res>
    implements $RequestOtpCopyWith<$Res> {
  _$RequestOtpCopyWithImpl(this._self, this._then);

  final RequestOtp _self;
  final $Res Function(RequestOtp) _then;

/// Create a copy of RequestOtp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? country = freezed,}) {
  return _then(_self.copyWith(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestOtp].
extension RequestOtpPatterns on RequestOtp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestOtp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestOtp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestOtp value)  $default,){
final _that = this;
switch (_that) {
case _RequestOtp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestOtp value)?  $default,){
final _that = this;
switch (_that) {
case _RequestOtp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String? country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestOtp() when $default != null:
return $default(_that.phone,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String? country)  $default,) {final _that = this;
switch (_that) {
case _RequestOtp():
return $default(_that.phone,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String? country)?  $default,) {final _that = this;
switch (_that) {
case _RequestOtp() when $default != null:
return $default(_that.phone,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestOtp implements RequestOtp {
  const _RequestOtp({required this.phone, this.country});
  factory _RequestOtp.fromJson(Map<String, dynamic> json) => _$RequestOtpFromJson(json);

/// As typed: national format together with `country`, or full international format.
@override final  String phone;
/// ISO 3166-1 alpha-2 country chosen in the picker.
@override final  String? country;

/// Create a copy of RequestOtp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestOtpCopyWith<_RequestOtp> get copyWith => __$RequestOtpCopyWithImpl<_RequestOtp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestOtpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestOtp&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,country);

@override
String toString() {
  return 'RequestOtp(phone: $phone, country: $country)';
}


}

/// @nodoc
abstract mixin class _$RequestOtpCopyWith<$Res> implements $RequestOtpCopyWith<$Res> {
  factory _$RequestOtpCopyWith(_RequestOtp value, $Res Function(_RequestOtp) _then) = __$RequestOtpCopyWithImpl;
@override @useResult
$Res call({
 String phone, String? country
});




}
/// @nodoc
class __$RequestOtpCopyWithImpl<$Res>
    implements _$RequestOtpCopyWith<$Res> {
  __$RequestOtpCopyWithImpl(this._self, this._then);

  final _RequestOtp _self;
  final $Res Function(_RequestOtp) _then;

/// Create a copy of RequestOtp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? country = freezed,}) {
  return _then(_RequestOtp(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
