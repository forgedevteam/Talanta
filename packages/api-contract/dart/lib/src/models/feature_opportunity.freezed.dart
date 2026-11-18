// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_opportunity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeatureOpportunity {

/// Days to show in the Featured row.
 num get days;
/// Create a copy of FeatureOpportunity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureOpportunityCopyWith<FeatureOpportunity> get copyWith => _$FeatureOpportunityCopyWithImpl<FeatureOpportunity>(this as FeatureOpportunity, _$identity);

  /// Serializes this FeatureOpportunity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureOpportunity&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,days);

@override
String toString() {
  return 'FeatureOpportunity(days: $days)';
}


}

/// @nodoc
abstract mixin class $FeatureOpportunityCopyWith<$Res>  {
  factory $FeatureOpportunityCopyWith(FeatureOpportunity value, $Res Function(FeatureOpportunity) _then) = _$FeatureOpportunityCopyWithImpl;
@useResult
$Res call({
 num days
});




}
/// @nodoc
class _$FeatureOpportunityCopyWithImpl<$Res>
    implements $FeatureOpportunityCopyWith<$Res> {
  _$FeatureOpportunityCopyWithImpl(this._self, this._then);

  final FeatureOpportunity _self;
  final $Res Function(FeatureOpportunity) _then;

/// Create a copy of FeatureOpportunity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,}) {
  return _then(_self.copyWith(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureOpportunity].
extension FeatureOpportunityPatterns on FeatureOpportunity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureOpportunity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureOpportunity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureOpportunity value)  $default,){
final _that = this;
switch (_that) {
case _FeatureOpportunity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureOpportunity value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureOpportunity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureOpportunity() when $default != null:
return $default(_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num days)  $default,) {final _that = this;
switch (_that) {
case _FeatureOpportunity():
return $default(_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num days)?  $default,) {final _that = this;
switch (_that) {
case _FeatureOpportunity() when $default != null:
return $default(_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureOpportunity implements FeatureOpportunity {
  const _FeatureOpportunity({required this.days});
  factory _FeatureOpportunity.fromJson(Map<String, dynamic> json) => _$FeatureOpportunityFromJson(json);

/// Days to show in the Featured row.
@override final  num days;

/// Create a copy of FeatureOpportunity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureOpportunityCopyWith<_FeatureOpportunity> get copyWith => __$FeatureOpportunityCopyWithImpl<_FeatureOpportunity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureOpportunityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureOpportunity&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,days);

@override
String toString() {
  return 'FeatureOpportunity(days: $days)';
}


}

/// @nodoc
abstract mixin class _$FeatureOpportunityCopyWith<$Res> implements $FeatureOpportunityCopyWith<$Res> {
  factory _$FeatureOpportunityCopyWith(_FeatureOpportunity value, $Res Function(_FeatureOpportunity) _then) = __$FeatureOpportunityCopyWithImpl;
@override @useResult
$Res call({
 num days
});




}
/// @nodoc
class __$FeatureOpportunityCopyWithImpl<$Res>
    implements _$FeatureOpportunityCopyWith<$Res> {
  __$FeatureOpportunityCopyWithImpl(this._self, this._then);

  final _FeatureOpportunity _self;
  final $Res Function(_FeatureOpportunity) _then;

/// Create a copy of FeatureOpportunity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,}) {
  return _then(_FeatureOpportunity(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
