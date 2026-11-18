// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'following_work.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowingWork {

 String get id; String get title; String? get description; String get url; PortfolioPlatform get platform; String? get categorySlug; DateTime get createdAt; PersonSummary get creator;
/// Create a copy of FollowingWork
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowingWorkCopyWith<FollowingWork> get copyWith => _$FollowingWorkCopyWithImpl<FollowingWork>(this as FollowingWork, _$identity);

  /// Serializes this FollowingWork to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowingWork&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.creator, creator) || other.creator == creator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,url,platform,categorySlug,createdAt,creator);

@override
String toString() {
  return 'FollowingWork(id: $id, title: $title, description: $description, url: $url, platform: $platform, categorySlug: $categorySlug, createdAt: $createdAt, creator: $creator)';
}


}

/// @nodoc
abstract mixin class $FollowingWorkCopyWith<$Res>  {
  factory $FollowingWorkCopyWith(FollowingWork value, $Res Function(FollowingWork) _then) = _$FollowingWorkCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String url, PortfolioPlatform platform, String? categorySlug, DateTime createdAt, PersonSummary creator
});


$PersonSummaryCopyWith<$Res> get creator;

}
/// @nodoc
class _$FollowingWorkCopyWithImpl<$Res>
    implements $FollowingWorkCopyWith<$Res> {
  _$FollowingWorkCopyWithImpl(this._self, this._then);

  final FollowingWork _self;
  final $Res Function(FollowingWork) _then;

/// Create a copy of FollowingWork
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? url = null,Object? platform = null,Object? categorySlug = freezed,Object? createdAt = null,Object? creator = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PortfolioPlatform,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as PersonSummary,
  ));
}
/// Create a copy of FollowingWork
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res> get creator {
  
  return $PersonSummaryCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// Adds pattern-matching-related methods to [FollowingWork].
extension FollowingWorkPatterns on FollowingWork {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowingWork value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowingWork() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowingWork value)  $default,){
final _that = this;
switch (_that) {
case _FollowingWork():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowingWork value)?  $default,){
final _that = this;
switch (_that) {
case _FollowingWork() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String url,  PortfolioPlatform platform,  String? categorySlug,  DateTime createdAt,  PersonSummary creator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowingWork() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.url,_that.platform,_that.categorySlug,_that.createdAt,_that.creator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String url,  PortfolioPlatform platform,  String? categorySlug,  DateTime createdAt,  PersonSummary creator)  $default,) {final _that = this;
switch (_that) {
case _FollowingWork():
return $default(_that.id,_that.title,_that.description,_that.url,_that.platform,_that.categorySlug,_that.createdAt,_that.creator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String url,  PortfolioPlatform platform,  String? categorySlug,  DateTime createdAt,  PersonSummary creator)?  $default,) {final _that = this;
switch (_that) {
case _FollowingWork() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.url,_that.platform,_that.categorySlug,_that.createdAt,_that.creator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowingWork implements FollowingWork {
  const _FollowingWork({required this.id, required this.title, required this.description, required this.url, required this.platform, required this.categorySlug, required this.createdAt, required this.creator});
  factory _FollowingWork.fromJson(Map<String, dynamic> json) => _$FollowingWorkFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  String url;
@override final  PortfolioPlatform platform;
@override final  String? categorySlug;
@override final  DateTime createdAt;
@override final  PersonSummary creator;

/// Create a copy of FollowingWork
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowingWorkCopyWith<_FollowingWork> get copyWith => __$FollowingWorkCopyWithImpl<_FollowingWork>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowingWorkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowingWork&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.creator, creator) || other.creator == creator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,url,platform,categorySlug,createdAt,creator);

@override
String toString() {
  return 'FollowingWork(id: $id, title: $title, description: $description, url: $url, platform: $platform, categorySlug: $categorySlug, createdAt: $createdAt, creator: $creator)';
}


}

/// @nodoc
abstract mixin class _$FollowingWorkCopyWith<$Res> implements $FollowingWorkCopyWith<$Res> {
  factory _$FollowingWorkCopyWith(_FollowingWork value, $Res Function(_FollowingWork) _then) = __$FollowingWorkCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String url, PortfolioPlatform platform, String? categorySlug, DateTime createdAt, PersonSummary creator
});


@override $PersonSummaryCopyWith<$Res> get creator;

}
/// @nodoc
class __$FollowingWorkCopyWithImpl<$Res>
    implements _$FollowingWorkCopyWith<$Res> {
  __$FollowingWorkCopyWithImpl(this._self, this._then);

  final _FollowingWork _self;
  final $Res Function(_FollowingWork) _then;

/// Create a copy of FollowingWork
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? url = null,Object? platform = null,Object? categorySlug = freezed,Object? createdAt = null,Object? creator = null,}) {
  return _then(_FollowingWork(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PortfolioPlatform,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as PersonSummary,
  ));
}

/// Create a copy of FollowingWork
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res> get creator {
  
  return $PersonSummaryCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}

// dart format on
