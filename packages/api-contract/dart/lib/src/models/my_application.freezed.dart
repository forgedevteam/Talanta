// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyApplication {

 String get applicationId; ApplicationStatus get status; DateTime get createdAt; OpportunitySummary get opportunity;
/// Create a copy of MyApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyApplicationCopyWith<MyApplication> get copyWith => _$MyApplicationCopyWithImpl<MyApplication>(this as MyApplication, _$identity);

  /// Serializes this MyApplication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyApplication&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.opportunity, opportunity) || other.opportunity == opportunity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,status,createdAt,opportunity);

@override
String toString() {
  return 'MyApplication(applicationId: $applicationId, status: $status, createdAt: $createdAt, opportunity: $opportunity)';
}


}

/// @nodoc
abstract mixin class $MyApplicationCopyWith<$Res>  {
  factory $MyApplicationCopyWith(MyApplication value, $Res Function(MyApplication) _then) = _$MyApplicationCopyWithImpl;
@useResult
$Res call({
 String applicationId, ApplicationStatus status, DateTime createdAt, OpportunitySummary opportunity
});


$OpportunitySummaryCopyWith<$Res> get opportunity;

}
/// @nodoc
class _$MyApplicationCopyWithImpl<$Res>
    implements $MyApplicationCopyWith<$Res> {
  _$MyApplicationCopyWithImpl(this._self, this._then);

  final MyApplication _self;
  final $Res Function(MyApplication) _then;

/// Create a copy of MyApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applicationId = null,Object? status = null,Object? createdAt = null,Object? opportunity = null,}) {
  return _then(_self.copyWith(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,opportunity: null == opportunity ? _self.opportunity : opportunity // ignore: cast_nullable_to_non_nullable
as OpportunitySummary,
  ));
}
/// Create a copy of MyApplication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpportunitySummaryCopyWith<$Res> get opportunity {
  
  return $OpportunitySummaryCopyWith<$Res>(_self.opportunity, (value) {
    return _then(_self.copyWith(opportunity: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyApplication].
extension MyApplicationPatterns on MyApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyApplication value)  $default,){
final _that = this;
switch (_that) {
case _MyApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyApplication value)?  $default,){
final _that = this;
switch (_that) {
case _MyApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String applicationId,  ApplicationStatus status,  DateTime createdAt,  OpportunitySummary opportunity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyApplication() when $default != null:
return $default(_that.applicationId,_that.status,_that.createdAt,_that.opportunity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String applicationId,  ApplicationStatus status,  DateTime createdAt,  OpportunitySummary opportunity)  $default,) {final _that = this;
switch (_that) {
case _MyApplication():
return $default(_that.applicationId,_that.status,_that.createdAt,_that.opportunity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String applicationId,  ApplicationStatus status,  DateTime createdAt,  OpportunitySummary opportunity)?  $default,) {final _that = this;
switch (_that) {
case _MyApplication() when $default != null:
return $default(_that.applicationId,_that.status,_that.createdAt,_that.opportunity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyApplication implements MyApplication {
  const _MyApplication({required this.applicationId, required this.status, required this.createdAt, required this.opportunity});
  factory _MyApplication.fromJson(Map<String, dynamic> json) => _$MyApplicationFromJson(json);

@override final  String applicationId;
@override final  ApplicationStatus status;
@override final  DateTime createdAt;
@override final  OpportunitySummary opportunity;

/// Create a copy of MyApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyApplicationCopyWith<_MyApplication> get copyWith => __$MyApplicationCopyWithImpl<_MyApplication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyApplication&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.opportunity, opportunity) || other.opportunity == opportunity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,status,createdAt,opportunity);

@override
String toString() {
  return 'MyApplication(applicationId: $applicationId, status: $status, createdAt: $createdAt, opportunity: $opportunity)';
}


}

/// @nodoc
abstract mixin class _$MyApplicationCopyWith<$Res> implements $MyApplicationCopyWith<$Res> {
  factory _$MyApplicationCopyWith(_MyApplication value, $Res Function(_MyApplication) _then) = __$MyApplicationCopyWithImpl;
@override @useResult
$Res call({
 String applicationId, ApplicationStatus status, DateTime createdAt, OpportunitySummary opportunity
});


@override $OpportunitySummaryCopyWith<$Res> get opportunity;

}
/// @nodoc
class __$MyApplicationCopyWithImpl<$Res>
    implements _$MyApplicationCopyWith<$Res> {
  __$MyApplicationCopyWithImpl(this._self, this._then);

  final _MyApplication _self;
  final $Res Function(_MyApplication) _then;

/// Create a copy of MyApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applicationId = null,Object? status = null,Object? createdAt = null,Object? opportunity = null,}) {
  return _then(_MyApplication(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,opportunity: null == opportunity ? _self.opportunity : opportunity // ignore: cast_nullable_to_non_nullable
as OpportunitySummary,
  ));
}

/// Create a copy of MyApplication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpportunitySummaryCopyWith<$Res> get opportunity {
  
  return $OpportunitySummaryCopyWith<$Res>(_self.opportunity, (value) {
    return _then(_self.copyWith(opportunity: value));
  });
}
}

// dart format on
