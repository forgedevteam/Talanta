// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_opportunity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateOpportunity {

 String get title; String get description; String get categoryId; String get city; CompensationType get compensation;/// Required when the work is paid, so talent knows what to expect.
 num? get budgetAmount; String? get deadline;
/// Create a copy of CreateOpportunity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOpportunityCopyWith<CreateOpportunity> get copyWith => _$CreateOpportunityCopyWithImpl<CreateOpportunity>(this as CreateOpportunity, _$identity);

  /// Serializes this CreateOpportunity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOpportunity&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.city, city) || other.city == city)&&(identical(other.compensation, compensation) || other.compensation == compensation)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.deadline, deadline) || other.deadline == deadline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,categoryId,city,compensation,budgetAmount,deadline);

@override
String toString() {
  return 'CreateOpportunity(title: $title, description: $description, categoryId: $categoryId, city: $city, compensation: $compensation, budgetAmount: $budgetAmount, deadline: $deadline)';
}


}

/// @nodoc
abstract mixin class $CreateOpportunityCopyWith<$Res>  {
  factory $CreateOpportunityCopyWith(CreateOpportunity value, $Res Function(CreateOpportunity) _then) = _$CreateOpportunityCopyWithImpl;
@useResult
$Res call({
 String title, String description, String categoryId, String city, CompensationType compensation, num? budgetAmount, String? deadline
});




}
/// @nodoc
class _$CreateOpportunityCopyWithImpl<$Res>
    implements $CreateOpportunityCopyWith<$Res> {
  _$CreateOpportunityCopyWithImpl(this._self, this._then);

  final CreateOpportunity _self;
  final $Res Function(CreateOpportunity) _then;

/// Create a copy of CreateOpportunity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? categoryId = null,Object? city = null,Object? compensation = null,Object? budgetAmount = freezed,Object? deadline = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,compensation: null == compensation ? _self.compensation : compensation // ignore: cast_nullable_to_non_nullable
as CompensationType,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as num?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOpportunity].
extension CreateOpportunityPatterns on CreateOpportunity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOpportunity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOpportunity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOpportunity value)  $default,){
final _that = this;
switch (_that) {
case _CreateOpportunity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOpportunity value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOpportunity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  String categoryId,  String city,  CompensationType compensation,  num? budgetAmount,  String? deadline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOpportunity() when $default != null:
return $default(_that.title,_that.description,_that.categoryId,_that.city,_that.compensation,_that.budgetAmount,_that.deadline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  String categoryId,  String city,  CompensationType compensation,  num? budgetAmount,  String? deadline)  $default,) {final _that = this;
switch (_that) {
case _CreateOpportunity():
return $default(_that.title,_that.description,_that.categoryId,_that.city,_that.compensation,_that.budgetAmount,_that.deadline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  String categoryId,  String city,  CompensationType compensation,  num? budgetAmount,  String? deadline)?  $default,) {final _that = this;
switch (_that) {
case _CreateOpportunity() when $default != null:
return $default(_that.title,_that.description,_that.categoryId,_that.city,_that.compensation,_that.budgetAmount,_that.deadline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateOpportunity implements CreateOpportunity {
  const _CreateOpportunity({required this.title, required this.description, required this.categoryId, required this.city, required this.compensation, this.budgetAmount, this.deadline});
  factory _CreateOpportunity.fromJson(Map<String, dynamic> json) => _$CreateOpportunityFromJson(json);

@override final  String title;
@override final  String description;
@override final  String categoryId;
@override final  String city;
@override final  CompensationType compensation;
/// Required when the work is paid, so talent knows what to expect.
@override final  num? budgetAmount;
@override final  String? deadline;

/// Create a copy of CreateOpportunity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOpportunityCopyWith<_CreateOpportunity> get copyWith => __$CreateOpportunityCopyWithImpl<_CreateOpportunity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateOpportunityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOpportunity&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.city, city) || other.city == city)&&(identical(other.compensation, compensation) || other.compensation == compensation)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.deadline, deadline) || other.deadline == deadline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,categoryId,city,compensation,budgetAmount,deadline);

@override
String toString() {
  return 'CreateOpportunity(title: $title, description: $description, categoryId: $categoryId, city: $city, compensation: $compensation, budgetAmount: $budgetAmount, deadline: $deadline)';
}


}

/// @nodoc
abstract mixin class _$CreateOpportunityCopyWith<$Res> implements $CreateOpportunityCopyWith<$Res> {
  factory _$CreateOpportunityCopyWith(_CreateOpportunity value, $Res Function(_CreateOpportunity) _then) = __$CreateOpportunityCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String categoryId, String city, CompensationType compensation, num? budgetAmount, String? deadline
});




}
/// @nodoc
class __$CreateOpportunityCopyWithImpl<$Res>
    implements _$CreateOpportunityCopyWith<$Res> {
  __$CreateOpportunityCopyWithImpl(this._self, this._then);

  final _CreateOpportunity _self;
  final $Res Function(_CreateOpportunity) _then;

/// Create a copy of CreateOpportunity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? categoryId = null,Object? city = null,Object? compensation = null,Object? budgetAmount = freezed,Object? deadline = freezed,}) {
  return _then(_CreateOpportunity(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,compensation: null == compensation ? _self.compensation : compensation // ignore: cast_nullable_to_non_nullable
as CompensationType,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as num?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
