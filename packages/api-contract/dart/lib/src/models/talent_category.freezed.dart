// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'talent_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TalentCategory {

 String get id;/// Stable key. Safe to switch on.
 String get slug; String get name;/// Key into the client icon set.
 String get icon;
/// Create a copy of TalentCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TalentCategoryCopyWith<TalentCategory> get copyWith => _$TalentCategoryCopyWithImpl<TalentCategory>(this as TalentCategory, _$identity);

  /// Serializes this TalentCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TalentCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,icon);

@override
String toString() {
  return 'TalentCategory(id: $id, slug: $slug, name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $TalentCategoryCopyWith<$Res>  {
  factory $TalentCategoryCopyWith(TalentCategory value, $Res Function(TalentCategory) _then) = _$TalentCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String icon
});




}
/// @nodoc
class _$TalentCategoryCopyWithImpl<$Res>
    implements $TalentCategoryCopyWith<$Res> {
  _$TalentCategoryCopyWithImpl(this._self, this._then);

  final TalentCategory _self;
  final $Res Function(TalentCategory) _then;

/// Create a copy of TalentCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? icon = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TalentCategory].
extension TalentCategoryPatterns on TalentCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TalentCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TalentCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TalentCategory value)  $default,){
final _that = this;
switch (_that) {
case _TalentCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TalentCategory value)?  $default,){
final _that = this;
switch (_that) {
case _TalentCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TalentCategory() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String icon)  $default,) {final _that = this;
switch (_that) {
case _TalentCategory():
return $default(_that.id,_that.slug,_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _TalentCategory() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TalentCategory implements TalentCategory {
  const _TalentCategory({required this.id, required this.slug, required this.name, required this.icon});
  factory _TalentCategory.fromJson(Map<String, dynamic> json) => _$TalentCategoryFromJson(json);

@override final  String id;
/// Stable key. Safe to switch on.
@override final  String slug;
@override final  String name;
/// Key into the client icon set.
@override final  String icon;

/// Create a copy of TalentCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TalentCategoryCopyWith<_TalentCategory> get copyWith => __$TalentCategoryCopyWithImpl<_TalentCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TalentCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TalentCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,icon);

@override
String toString() {
  return 'TalentCategory(id: $id, slug: $slug, name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$TalentCategoryCopyWith<$Res> implements $TalentCategoryCopyWith<$Res> {
  factory _$TalentCategoryCopyWith(_TalentCategory value, $Res Function(_TalentCategory) _then) = __$TalentCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String icon
});




}
/// @nodoc
class __$TalentCategoryCopyWithImpl<$Res>
    implements _$TalentCategoryCopyWith<$Res> {
  __$TalentCategoryCopyWithImpl(this._self, this._then);

  final _TalentCategory _self;
  final $Res Function(_TalentCategory) _then;

/// Create a copy of TalentCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? icon = null,}) {
  return _then(_TalentCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
