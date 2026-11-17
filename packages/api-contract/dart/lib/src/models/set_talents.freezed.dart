// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_talents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetTalents {

/// Replaces the full list.
 List<String> get categoryIds;/// The talent shown first on the profile. Defaults to the first id in the list.
 String? get primaryCategoryId;
/// Create a copy of SetTalents
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetTalentsCopyWith<SetTalents> get copyWith => _$SetTalentsCopyWithImpl<SetTalents>(this as SetTalents, _$identity);

  /// Serializes this SetTalents to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetTalents&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds)&&(identical(other.primaryCategoryId, primaryCategoryId) || other.primaryCategoryId == primaryCategoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categoryIds),primaryCategoryId);

@override
String toString() {
  return 'SetTalents(categoryIds: $categoryIds, primaryCategoryId: $primaryCategoryId)';
}


}

/// @nodoc
abstract mixin class $SetTalentsCopyWith<$Res>  {
  factory $SetTalentsCopyWith(SetTalents value, $Res Function(SetTalents) _then) = _$SetTalentsCopyWithImpl;
@useResult
$Res call({
 List<String> categoryIds, String? primaryCategoryId
});




}
/// @nodoc
class _$SetTalentsCopyWithImpl<$Res>
    implements $SetTalentsCopyWith<$Res> {
  _$SetTalentsCopyWithImpl(this._self, this._then);

  final SetTalents _self;
  final $Res Function(SetTalents) _then;

/// Create a copy of SetTalents
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryIds = null,Object? primaryCategoryId = freezed,}) {
  return _then(_self.copyWith(
categoryIds: null == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,primaryCategoryId: freezed == primaryCategoryId ? _self.primaryCategoryId : primaryCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetTalents].
extension SetTalentsPatterns on SetTalents {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetTalents value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetTalents() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetTalents value)  $default,){
final _that = this;
switch (_that) {
case _SetTalents():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetTalents value)?  $default,){
final _that = this;
switch (_that) {
case _SetTalents() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> categoryIds,  String? primaryCategoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetTalents() when $default != null:
return $default(_that.categoryIds,_that.primaryCategoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> categoryIds,  String? primaryCategoryId)  $default,) {final _that = this;
switch (_that) {
case _SetTalents():
return $default(_that.categoryIds,_that.primaryCategoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> categoryIds,  String? primaryCategoryId)?  $default,) {final _that = this;
switch (_that) {
case _SetTalents() when $default != null:
return $default(_that.categoryIds,_that.primaryCategoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetTalents implements SetTalents {
  const _SetTalents({required final  List<String> categoryIds, this.primaryCategoryId}): _categoryIds = categoryIds;
  factory _SetTalents.fromJson(Map<String, dynamic> json) => _$SetTalentsFromJson(json);

/// Replaces the full list.
 final  List<String> _categoryIds;
/// Replaces the full list.
@override List<String> get categoryIds {
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryIds);
}

/// The talent shown first on the profile. Defaults to the first id in the list.
@override final  String? primaryCategoryId;

/// Create a copy of SetTalents
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetTalentsCopyWith<_SetTalents> get copyWith => __$SetTalentsCopyWithImpl<_SetTalents>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetTalentsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetTalents&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds)&&(identical(other.primaryCategoryId, primaryCategoryId) || other.primaryCategoryId == primaryCategoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categoryIds),primaryCategoryId);

@override
String toString() {
  return 'SetTalents(categoryIds: $categoryIds, primaryCategoryId: $primaryCategoryId)';
}


}

/// @nodoc
abstract mixin class _$SetTalentsCopyWith<$Res> implements $SetTalentsCopyWith<$Res> {
  factory _$SetTalentsCopyWith(_SetTalents value, $Res Function(_SetTalents) _then) = __$SetTalentsCopyWithImpl;
@override @useResult
$Res call({
 List<String> categoryIds, String? primaryCategoryId
});




}
/// @nodoc
class __$SetTalentsCopyWithImpl<$Res>
    implements _$SetTalentsCopyWith<$Res> {
  __$SetTalentsCopyWithImpl(this._self, this._then);

  final _SetTalents _self;
  final $Res Function(_SetTalents) _then;

/// Create a copy of SetTalents
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryIds = null,Object? primaryCategoryId = freezed,}) {
  return _then(_SetTalents(
categoryIds: null == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,primaryCategoryId: freezed == primaryCategoryId ? _self.primaryCategoryId : primaryCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
