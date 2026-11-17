// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_talent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserTalent {

 String get categoryId; String get slug; String get name; String get icon; TalentLevel get level; bool get isPrimary;
/// Create a copy of UserTalent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserTalentCopyWith<UserTalent> get copyWith => _$UserTalentCopyWithImpl<UserTalent>(this as UserTalent, _$identity);

  /// Serializes this UserTalent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserTalent&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.level, level) || other.level == level)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,slug,name,icon,level,isPrimary);

@override
String toString() {
  return 'UserTalent(categoryId: $categoryId, slug: $slug, name: $name, icon: $icon, level: $level, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class $UserTalentCopyWith<$Res>  {
  factory $UserTalentCopyWith(UserTalent value, $Res Function(UserTalent) _then) = _$UserTalentCopyWithImpl;
@useResult
$Res call({
 String categoryId, String slug, String name, String icon, TalentLevel level, bool isPrimary
});




}
/// @nodoc
class _$UserTalentCopyWithImpl<$Res>
    implements $UserTalentCopyWith<$Res> {
  _$UserTalentCopyWithImpl(this._self, this._then);

  final UserTalent _self;
  final $Res Function(UserTalent) _then;

/// Create a copy of UserTalent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? slug = null,Object? name = null,Object? icon = null,Object? level = null,Object? isPrimary = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TalentLevel,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserTalent].
extension UserTalentPatterns on UserTalent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserTalent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserTalent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserTalent value)  $default,){
final _that = this;
switch (_that) {
case _UserTalent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserTalent value)?  $default,){
final _that = this;
switch (_that) {
case _UserTalent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String slug,  String name,  String icon,  TalentLevel level,  bool isPrimary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserTalent() when $default != null:
return $default(_that.categoryId,_that.slug,_that.name,_that.icon,_that.level,_that.isPrimary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String slug,  String name,  String icon,  TalentLevel level,  bool isPrimary)  $default,) {final _that = this;
switch (_that) {
case _UserTalent():
return $default(_that.categoryId,_that.slug,_that.name,_that.icon,_that.level,_that.isPrimary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String slug,  String name,  String icon,  TalentLevel level,  bool isPrimary)?  $default,) {final _that = this;
switch (_that) {
case _UserTalent() when $default != null:
return $default(_that.categoryId,_that.slug,_that.name,_that.icon,_that.level,_that.isPrimary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserTalent implements UserTalent {
  const _UserTalent({required this.categoryId, required this.slug, required this.name, required this.icon, required this.level, required this.isPrimary});
  factory _UserTalent.fromJson(Map<String, dynamic> json) => _$UserTalentFromJson(json);

@override final  String categoryId;
@override final  String slug;
@override final  String name;
@override final  String icon;
@override final  TalentLevel level;
@override final  bool isPrimary;

/// Create a copy of UserTalent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserTalentCopyWith<_UserTalent> get copyWith => __$UserTalentCopyWithImpl<_UserTalent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserTalentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserTalent&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.level, level) || other.level == level)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,slug,name,icon,level,isPrimary);

@override
String toString() {
  return 'UserTalent(categoryId: $categoryId, slug: $slug, name: $name, icon: $icon, level: $level, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class _$UserTalentCopyWith<$Res> implements $UserTalentCopyWith<$Res> {
  factory _$UserTalentCopyWith(_UserTalent value, $Res Function(_UserTalent) _then) = __$UserTalentCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String slug, String name, String icon, TalentLevel level, bool isPrimary
});




}
/// @nodoc
class __$UserTalentCopyWithImpl<$Res>
    implements _$UserTalentCopyWith<$Res> {
  __$UserTalentCopyWithImpl(this._self, this._then);

  final _UserTalent _self;
  final $Res Function(_UserTalent) _then;

/// Create a copy of UserTalent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? slug = null,Object? name = null,Object? icon = null,Object? level = null,Object? isPrimary = null,}) {
  return _then(_UserTalent(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TalentLevel,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
