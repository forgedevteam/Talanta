// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_portfolio_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePortfolioItem {

 String get title; String get url; String? get description;/// The talent this work shows.
 String? get categoryId;
/// Create a copy of CreatePortfolioItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePortfolioItemCopyWith<CreatePortfolioItem> get copyWith => _$CreatePortfolioItemCopyWithImpl<CreatePortfolioItem>(this as CreatePortfolioItem, _$identity);

  /// Serializes this CreatePortfolioItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePortfolioItem&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,description,categoryId);

@override
String toString() {
  return 'CreatePortfolioItem(title: $title, url: $url, description: $description, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $CreatePortfolioItemCopyWith<$Res>  {
  factory $CreatePortfolioItemCopyWith(CreatePortfolioItem value, $Res Function(CreatePortfolioItem) _then) = _$CreatePortfolioItemCopyWithImpl;
@useResult
$Res call({
 String title, String url, String? description, String? categoryId
});




}
/// @nodoc
class _$CreatePortfolioItemCopyWithImpl<$Res>
    implements $CreatePortfolioItemCopyWith<$Res> {
  _$CreatePortfolioItemCopyWithImpl(this._self, this._then);

  final CreatePortfolioItem _self;
  final $Res Function(CreatePortfolioItem) _then;

/// Create a copy of CreatePortfolioItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? url = null,Object? description = freezed,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePortfolioItem].
extension CreatePortfolioItemPatterns on CreatePortfolioItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePortfolioItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePortfolioItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePortfolioItem value)  $default,){
final _that = this;
switch (_that) {
case _CreatePortfolioItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePortfolioItem value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePortfolioItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String url,  String? description,  String? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePortfolioItem() when $default != null:
return $default(_that.title,_that.url,_that.description,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String url,  String? description,  String? categoryId)  $default,) {final _that = this;
switch (_that) {
case _CreatePortfolioItem():
return $default(_that.title,_that.url,_that.description,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String url,  String? description,  String? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _CreatePortfolioItem() when $default != null:
return $default(_that.title,_that.url,_that.description,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePortfolioItem implements CreatePortfolioItem {
  const _CreatePortfolioItem({required this.title, required this.url, this.description, this.categoryId});
  factory _CreatePortfolioItem.fromJson(Map<String, dynamic> json) => _$CreatePortfolioItemFromJson(json);

@override final  String title;
@override final  String url;
@override final  String? description;
/// The talent this work shows.
@override final  String? categoryId;

/// Create a copy of CreatePortfolioItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePortfolioItemCopyWith<_CreatePortfolioItem> get copyWith => __$CreatePortfolioItemCopyWithImpl<_CreatePortfolioItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePortfolioItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePortfolioItem&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,description,categoryId);

@override
String toString() {
  return 'CreatePortfolioItem(title: $title, url: $url, description: $description, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CreatePortfolioItemCopyWith<$Res> implements $CreatePortfolioItemCopyWith<$Res> {
  factory _$CreatePortfolioItemCopyWith(_CreatePortfolioItem value, $Res Function(_CreatePortfolioItem) _then) = __$CreatePortfolioItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String url, String? description, String? categoryId
});




}
/// @nodoc
class __$CreatePortfolioItemCopyWithImpl<$Res>
    implements _$CreatePortfolioItemCopyWith<$Res> {
  __$CreatePortfolioItemCopyWithImpl(this._self, this._then);

  final _CreatePortfolioItem _self;
  final $Res Function(_CreatePortfolioItem) _then;

/// Create a copy of CreatePortfolioItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? url = null,Object? description = freezed,Object? categoryId = freezed,}) {
  return _then(_CreatePortfolioItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
