// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioItem {

 String get id; String get title; String? get description; String get url; PortfolioPlatform get platform; String? get categorySlug; DateTime get createdAt;
/// Create a copy of PortfolioItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioItemCopyWith<PortfolioItem> get copyWith => _$PortfolioItemCopyWithImpl<PortfolioItem>(this as PortfolioItem, _$identity);

  /// Serializes this PortfolioItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,url,platform,categorySlug,createdAt);

@override
String toString() {
  return 'PortfolioItem(id: $id, title: $title, description: $description, url: $url, platform: $platform, categorySlug: $categorySlug, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PortfolioItemCopyWith<$Res>  {
  factory $PortfolioItemCopyWith(PortfolioItem value, $Res Function(PortfolioItem) _then) = _$PortfolioItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String url, PortfolioPlatform platform, String? categorySlug, DateTime createdAt
});




}
/// @nodoc
class _$PortfolioItemCopyWithImpl<$Res>
    implements $PortfolioItemCopyWith<$Res> {
  _$PortfolioItemCopyWithImpl(this._self, this._then);

  final PortfolioItem _self;
  final $Res Function(PortfolioItem) _then;

/// Create a copy of PortfolioItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? url = null,Object? platform = null,Object? categorySlug = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PortfolioPlatform,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioItem].
extension PortfolioItemPatterns on PortfolioItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioItem value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioItem value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String url,  PortfolioPlatform platform,  String? categorySlug,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.url,_that.platform,_that.categorySlug,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String url,  PortfolioPlatform platform,  String? categorySlug,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PortfolioItem():
return $default(_that.id,_that.title,_that.description,_that.url,_that.platform,_that.categorySlug,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String url,  PortfolioPlatform platform,  String? categorySlug,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.url,_that.platform,_that.categorySlug,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioItem implements PortfolioItem {
  const _PortfolioItem({required this.id, required this.title, required this.description, required this.url, required this.platform, required this.categorySlug, required this.createdAt});
  factory _PortfolioItem.fromJson(Map<String, dynamic> json) => _$PortfolioItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  String url;
@override final  PortfolioPlatform platform;
@override final  String? categorySlug;
@override final  DateTime createdAt;

/// Create a copy of PortfolioItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioItemCopyWith<_PortfolioItem> get copyWith => __$PortfolioItemCopyWithImpl<_PortfolioItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,url,platform,categorySlug,createdAt);

@override
String toString() {
  return 'PortfolioItem(id: $id, title: $title, description: $description, url: $url, platform: $platform, categorySlug: $categorySlug, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PortfolioItemCopyWith<$Res> implements $PortfolioItemCopyWith<$Res> {
  factory _$PortfolioItemCopyWith(_PortfolioItem value, $Res Function(_PortfolioItem) _then) = __$PortfolioItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String url, PortfolioPlatform platform, String? categorySlug, DateTime createdAt
});




}
/// @nodoc
class __$PortfolioItemCopyWithImpl<$Res>
    implements _$PortfolioItemCopyWith<$Res> {
  __$PortfolioItemCopyWithImpl(this._self, this._then);

  final _PortfolioItem _self;
  final $Res Function(_PortfolioItem) _then;

/// Create a copy of PortfolioItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? url = null,Object? platform = null,Object? categorySlug = freezed,Object? createdAt = null,}) {
  return _then(_PortfolioItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PortfolioPlatform,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
