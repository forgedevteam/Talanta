// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'creator_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatorProfile {

 String get id; String get username; String get displayName; String? get city;/// Absolute, or relative to the API origin.
 String? get avatarUrl; bool get isVerified; TalentCategory? get primaryTalent; String? get bio; List<UserTalent> get talents; List<PortfolioItem> get portfolio; num get followerCount; num get followingCount; num get postCount; bool get isFollowing;/// This is the signed-in person.
 bool get isMe;
/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatorProfileCopyWith<CreatorProfile> get copyWith => _$CreatorProfileCopyWithImpl<CreatorProfile>(this as CreatorProfile, _$identity);

  /// Serializes this CreatorProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.primaryTalent, primaryTalent) || other.primaryTalent == primaryTalent)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.talents, talents)&&const DeepCollectionEquality().equals(other.portfolio, portfolio)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,city,avatarUrl,isVerified,primaryTalent,bio,const DeepCollectionEquality().hash(talents),const DeepCollectionEquality().hash(portfolio),followerCount,followingCount,postCount,isFollowing,isMe);

@override
String toString() {
  return 'CreatorProfile(id: $id, username: $username, displayName: $displayName, city: $city, avatarUrl: $avatarUrl, isVerified: $isVerified, primaryTalent: $primaryTalent, bio: $bio, talents: $talents, portfolio: $portfolio, followerCount: $followerCount, followingCount: $followingCount, postCount: $postCount, isFollowing: $isFollowing, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class $CreatorProfileCopyWith<$Res>  {
  factory $CreatorProfileCopyWith(CreatorProfile value, $Res Function(CreatorProfile) _then) = _$CreatorProfileCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, String? city, String? avatarUrl, bool isVerified, TalentCategory? primaryTalent, String? bio, List<UserTalent> talents, List<PortfolioItem> portfolio, num followerCount, num followingCount, num postCount, bool isFollowing, bool isMe
});


$TalentCategoryCopyWith<$Res>? get primaryTalent;

}
/// @nodoc
class _$CreatorProfileCopyWithImpl<$Res>
    implements $CreatorProfileCopyWith<$Res> {
  _$CreatorProfileCopyWithImpl(this._self, this._then);

  final CreatorProfile _self;
  final $Res Function(CreatorProfile) _then;

/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? city = freezed,Object? avatarUrl = freezed,Object? isVerified = null,Object? primaryTalent = freezed,Object? bio = freezed,Object? talents = null,Object? portfolio = null,Object? followerCount = null,Object? followingCount = null,Object? postCount = null,Object? isFollowing = null,Object? isMe = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,primaryTalent: freezed == primaryTalent ? _self.primaryTalent : primaryTalent // ignore: cast_nullable_to_non_nullable
as TalentCategory?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,talents: null == talents ? _self.talents : talents // ignore: cast_nullable_to_non_nullable
as List<UserTalent>,portfolio: null == portfolio ? _self.portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as List<PortfolioItem>,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as num,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as num,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as num,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CreatorProfile
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


/// Adds pattern-matching-related methods to [CreatorProfile].
extension CreatorProfilePatterns on CreatorProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatorProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatorProfile value)  $default,){
final _that = this;
switch (_that) {
case _CreatorProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatorProfile value)?  $default,){
final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent,  String? bio,  List<UserTalent> talents,  List<PortfolioItem> portfolio,  num followerCount,  num followingCount,  num postCount,  bool isFollowing,  bool isMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent,_that.bio,_that.talents,_that.portfolio,_that.followerCount,_that.followingCount,_that.postCount,_that.isFollowing,_that.isMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent,  String? bio,  List<UserTalent> talents,  List<PortfolioItem> portfolio,  num followerCount,  num followingCount,  num postCount,  bool isFollowing,  bool isMe)  $default,) {final _that = this;
switch (_that) {
case _CreatorProfile():
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent,_that.bio,_that.talents,_that.portfolio,_that.followerCount,_that.followingCount,_that.postCount,_that.isFollowing,_that.isMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  String? city,  String? avatarUrl,  bool isVerified,  TalentCategory? primaryTalent,  String? bio,  List<UserTalent> talents,  List<PortfolioItem> portfolio,  num followerCount,  num followingCount,  num postCount,  bool isFollowing,  bool isMe)?  $default,) {final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.city,_that.avatarUrl,_that.isVerified,_that.primaryTalent,_that.bio,_that.talents,_that.portfolio,_that.followerCount,_that.followingCount,_that.postCount,_that.isFollowing,_that.isMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatorProfile implements CreatorProfile {
  const _CreatorProfile({required this.id, required this.username, required this.displayName, required this.city, required this.avatarUrl, required this.isVerified, required this.primaryTalent, required this.bio, required final  List<UserTalent> talents, required final  List<PortfolioItem> portfolio, required this.followerCount, required this.followingCount, required this.postCount, required this.isFollowing, required this.isMe}): _talents = talents,_portfolio = portfolio;
  factory _CreatorProfile.fromJson(Map<String, dynamic> json) => _$CreatorProfileFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  String? city;
/// Absolute, or relative to the API origin.
@override final  String? avatarUrl;
@override final  bool isVerified;
@override final  TalentCategory? primaryTalent;
@override final  String? bio;
 final  List<UserTalent> _talents;
@override List<UserTalent> get talents {
  if (_talents is EqualUnmodifiableListView) return _talents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_talents);
}

 final  List<PortfolioItem> _portfolio;
@override List<PortfolioItem> get portfolio {
  if (_portfolio is EqualUnmodifiableListView) return _portfolio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_portfolio);
}

@override final  num followerCount;
@override final  num followingCount;
@override final  num postCount;
@override final  bool isFollowing;
/// This is the signed-in person.
@override final  bool isMe;

/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatorProfileCopyWith<_CreatorProfile> get copyWith => __$CreatorProfileCopyWithImpl<_CreatorProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatorProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.primaryTalent, primaryTalent) || other.primaryTalent == primaryTalent)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._talents, _talents)&&const DeepCollectionEquality().equals(other._portfolio, _portfolio)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,city,avatarUrl,isVerified,primaryTalent,bio,const DeepCollectionEquality().hash(_talents),const DeepCollectionEquality().hash(_portfolio),followerCount,followingCount,postCount,isFollowing,isMe);

@override
String toString() {
  return 'CreatorProfile(id: $id, username: $username, displayName: $displayName, city: $city, avatarUrl: $avatarUrl, isVerified: $isVerified, primaryTalent: $primaryTalent, bio: $bio, talents: $talents, portfolio: $portfolio, followerCount: $followerCount, followingCount: $followingCount, postCount: $postCount, isFollowing: $isFollowing, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class _$CreatorProfileCopyWith<$Res> implements $CreatorProfileCopyWith<$Res> {
  factory _$CreatorProfileCopyWith(_CreatorProfile value, $Res Function(_CreatorProfile) _then) = __$CreatorProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, String? city, String? avatarUrl, bool isVerified, TalentCategory? primaryTalent, String? bio, List<UserTalent> talents, List<PortfolioItem> portfolio, num followerCount, num followingCount, num postCount, bool isFollowing, bool isMe
});


@override $TalentCategoryCopyWith<$Res>? get primaryTalent;

}
/// @nodoc
class __$CreatorProfileCopyWithImpl<$Res>
    implements _$CreatorProfileCopyWith<$Res> {
  __$CreatorProfileCopyWithImpl(this._self, this._then);

  final _CreatorProfile _self;
  final $Res Function(_CreatorProfile) _then;

/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? city = freezed,Object? avatarUrl = freezed,Object? isVerified = null,Object? primaryTalent = freezed,Object? bio = freezed,Object? talents = null,Object? portfolio = null,Object? followerCount = null,Object? followingCount = null,Object? postCount = null,Object? isFollowing = null,Object? isMe = null,}) {
  return _then(_CreatorProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,primaryTalent: freezed == primaryTalent ? _self.primaryTalent : primaryTalent // ignore: cast_nullable_to_non_nullable
as TalentCategory?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,talents: null == talents ? _self._talents : talents // ignore: cast_nullable_to_non_nullable
as List<UserTalent>,portfolio: null == portfolio ? _self._portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as List<PortfolioItem>,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as num,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as num,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as num,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CreatorProfile
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
