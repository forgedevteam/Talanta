// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonSummary {

 String get id; String get username; String get displayName; String? get city;/// Absolute, or relative to the API origin.
 String? get avatarUrl; bool get isVerified; TalentCategory? get primaryTalent;
/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<PersonSummary> get copyWith => _$PersonSummaryCopyWithImpl<PersonSummary>(this as PersonSummary, _$identity);

  /// Serializes this PersonSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.primaryTalent, primaryTalent) || other.primaryTalent == primaryTalent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,city,avatarUrl,isVerified,primaryTalent);

@override
String toString() {
  return 'PersonSummary(id: $id, username: $username, displayName: $displayName, city: $city, avatarUrl: $avatarUrl, isVerified: $isVerified, primaryTalent: $primaryTalent)';
}


}

/// @nodoc
abstract mixin class $PersonSummaryCopyWith<$Res>  {
  factory $PersonSummaryCopyWith(PersonSummary value, $Res Function(PersonSummary) _then) = _$PersonSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, String? city, String? avatarUrl, bool isVerified, TalentCategory? primaryTalent
});


$TalentCategoryCopyWith<$Res>? get primaryTalent;

}
/// @nodoc
class _$PersonSummaryCopyWithImpl<$Res>
    implements $PersonSummaryCopyWith<$Res> {
  _$PersonSummaryCopyWithImpl(this._self, this._then);

  final PersonSummary _self;
  final $Res Function(PersonSummary) _then;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? city = freezed,Object? avatarUrl = freezed,Object? isVerified = null,Object? primaryTalent = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,primaryTalent: freezed == primaryTalent ? _self.primaryTalent : primaryTalent // ignore: cast_nullable_to_non_nullable
as TalentCategory?,
  ));
}
/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TalentCategoryCopyWith<$Res>? get primaryTalent {
    if (_self.primaryTalent == null) {
    return null;
  }

  return $TalentCategoryCopyWith<$Res>(_self.primaryTalent!, (value) {
    return _then(_self.copyWith(primaryTalent: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonSummary].
extension PersonSummaryPatterns on PersonSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonSummary value)  $default,){
final _that = this;
switch (_that) {
case _PersonSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent)  $default,) {final _that = this;
switch (_that) {
case _PersonSummary():
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent)?  $default,) {final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonSummary implements PersonSummary {
  const _PersonSummary({required this.id, required this.username, required this.displayName, required this.city, required this.avatarUrl, required this.isVerified, required this.primaryTalent});
  factory _PersonSummary.fromJson(Map<String, dynamic> json) => _$PersonSummaryFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  String? city;
/// Absolute, or relative to the API origin.
@override final  String? avatarUrl;
@override final  bool isVerified;
@override final  TalentCategory? primaryTalent;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonSummaryCopyWith<_PersonSummary> get copyWith => __$PersonSummaryCopyWithImpl<_PersonSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.primaryTalent, primaryTalent) || other.primaryTalent == primaryTalent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,city,avatarUrl,isVerified,primaryTalent);

@override
String toString() {
  return 'PersonSummary(id: $id, username: $username, displayName: $displayName, city: $city, avatarUrl: $avatarUrl, isVerified: $isVerified, primaryTalent: $primaryTalent)';
}


}

/// @nodoc
abstract mixin class _$PersonSummaryCopyWith<$Res> implements $PersonSummaryCopyWith<$Res> {
  factory _$PersonSummaryCopyWith(_PersonSummary value, $Res Function(_PersonSummary) _then) = __$PersonSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, String? city, String? avatarUrl, bool isVerified, TalentCategory? primaryTalent
});


@override $TalentCategoryCopyWith<$Res>? get primaryTalent;

}
/// @nodoc
class __$PersonSummaryCopyWithImpl<$Res>
    implements _$PersonSummaryCopyWith<$Res> {
  __$PersonSummaryCopyWithImpl(this._self, this._then);

  final _PersonSummary _self;
  final $Res Function(_PersonSummary) _then;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? city = freezed,Object? avatarUrl = freezed,Object? isVerified = null,Object? primaryTalent = freezed,}) {
  return _then(_PersonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,primaryTalent: freezed == primaryTalent ? _self.primaryTalent : primaryTalent // ignore: cast_nullable_to_non_nullable
as TalentCategory?,
  ));
}

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TalentCategoryCopyWith<$Res>? get primaryTalent {
    if (_self.primaryTalent == null) {
    return null;
  }

  return $TalentCategoryCopyWith<$Res>(_self.primaryTalent!, (value) {
    return _then(_self.copyWith(primaryTalent: value));
  });
}
}

// dart format on
