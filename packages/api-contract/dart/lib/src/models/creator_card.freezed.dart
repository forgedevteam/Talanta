// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'creator_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatorCard {

 String get id; String get username; String get displayName; String? get city;/// Absolute, or relative to the API origin.
 String? get avatarUrl; bool get isVerified; TalentCategory? get primaryTalent; num get followerCount; num get portfolioCount;
/// Create a copy of CreatorCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatorCardCopyWith<CreatorCard> get copyWith => _$CreatorCardCopyWithImpl<CreatorCard>(this as CreatorCard, _$identity);

  /// Serializes this CreatorCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatorCard&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.primaryTalent, primaryTalent) || other.primaryTalent == primaryTalent)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.portfolioCount, portfolioCount) || other.portfolioCount == portfolioCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,city,avatarUrl,isVerified,primaryTalent,followerCount,portfolioCount);

@override
String toString() {
  return 'CreatorCard(id: $id, username: $username, displayName: $displayName, city: $city, avatarUrl: $avatarUrl, isVerified: $isVerified, primaryTalent: $primaryTalent, followerCount: $followerCount, portfolioCount: $portfolioCount)';
}


}

/// @nodoc
abstract mixin class $CreatorCardCopyWith<$Res>  {
  factory $CreatorCardCopyWith(CreatorCard value, $Res Function(CreatorCard) _then) = _$CreatorCardCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, String? city, String? avatarUrl, bool isVerified, TalentCategory? primaryTalent, num followerCount, num portfolioCount
});


$TalentCategoryCopyWith<$Res>? get primaryTalent;

}
/// @nodoc
class _$CreatorCardCopyWithImpl<$Res>
    implements $CreatorCardCopyWith<$Res> {
  _$CreatorCardCopyWithImpl(this._self, this._then);

  final CreatorCard _self;
  final $Res Function(CreatorCard) _then;

/// Create a copy of CreatorCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? city = freezed,Object? avatarUrl = freezed,Object? isVerified = null,Object? primaryTalent = freezed,Object? followerCount = null,Object? portfolioCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,primaryTalent: freezed == primaryTalent ? _self.primaryTalent : primaryTalent // ignore: cast_nullable_to_non_nullable
as TalentCategory?,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as num,portfolioCount: null == portfolioCount ? _self.portfolioCount : portfolioCount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}
/// Create a copy of CreatorCard
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


/// Adds pattern-matching-related methods to [CreatorCard].
extension CreatorCardPatterns on CreatorCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatorCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatorCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatorCard value)  $default,){
final _that = this;
switch (_that) {
case _CreatorCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatorCard value)?  $default,){
final _that = this;
switch (_that) {
case _CreatorCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent,  num followerCount,  num portfolioCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatorCard() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent,_that.followerCount,_that.portfolioCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent,  num followerCount,  num portfolioCount)  $default,) {final _that = this;
switch (_that) {
case _CreatorCard():
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent,_that.followerCount,_that.portfolioCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent,  num followerCount,  num portfolioCount)?  $default,) {final _that = this;
switch (_that) {
case _CreatorCard() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent,_that.followerCount,_that.portfolioCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatorCard implements CreatorCard {
  const _CreatorCard({required this.id, required this.username, required this.displayName, required this.city, required this.avatarUrl, required this.isVerified, required this.primaryTalent, required this.followerCount, required this.portfolioCount});
  factory _CreatorCard.fromJson(Map<String, dynamic> json) => _$CreatorCardFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  String? city;
/// Absolute, or relative to the API origin.
@override final  String? avatarUrl;
@override final  bool isVerified;
@override final  TalentCategory? primaryTalent;
@override final  num followerCount;
@override final  num portfolioCount;

/// Create a copy of CreatorCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatorCardCopyWith<_CreatorCard> get copyWith => __$CreatorCardCopyWithImpl<_CreatorCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatorCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatorCard&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.primaryTalent, primaryTalent) || other.primaryTalent == primaryTalent)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.portfolioCount, portfolioCount) || other.portfolioCount == portfolioCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,city,avatarUrl,isVerified,primaryTalent,followerCount,portfolioCount);

@override
String toString() {
  return 'CreatorCard(id: $id, username: $username, displayName: $displayName, city: $city, avatarUrl: $avatarUrl, isVerified: $isVerified, primaryTalent: $primaryTalent, followerCount: $followerCount, portfolioCount: $portfolioCount)';
}


}

/// @nodoc
abstract mixin class _$CreatorCardCopyWith<$Res> implements $CreatorCardCopyWith<$Res> {
  factory _$CreatorCardCopyWith(_CreatorCard value, $Res Function(_CreatorCard) _then) = __$CreatorCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, String? city, String? avatarUrl, bool isVerified, TalentCategory? primaryTalent, num followerCount, num portfolioCount
});


@override $TalentCategoryCopyWith<$Res>? get primaryTalent;

}
/// @nodoc
class __$CreatorCardCopyWithImpl<$Res>
    implements _$CreatorCardCopyWith<$Res> {
  __$CreatorCardCopyWithImpl(this._self, this._then);

  final _CreatorCard _self;
  final $Res Function(_CreatorCard) _then;

/// Create a copy of CreatorCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? city = freezed,Object? avatarUrl = freezed,Object? isVerified = null,Object? primaryTalent = freezed,Object? followerCount = null,Object? portfolioCount = null,}) {
  return _then(_CreatorCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,primaryTalent: freezed == primaryTalent ? _self.primaryTalent : primaryTalent // ignore: cast_nullable_to_non_nullable
as TalentCategory?,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as num,portfolioCount: null == portfolioCount ? _self.portfolioCount : portfolioCount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

/// Create a copy of CreatorCard
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
