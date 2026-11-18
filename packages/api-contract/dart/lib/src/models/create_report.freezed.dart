// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateReport {

 ReportTarget get targetType;/// For a user, their username is resolved by the client to the id shown on cards.
 String get targetId; ReportReason get reason; String? get details;
/// Create a copy of CreateReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateReportCopyWith<CreateReport> get copyWith => _$CreateReportCopyWithImpl<CreateReport>(this as CreateReport, _$identity);

  /// Serializes this CreateReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateReport&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetType,targetId,reason,details);

@override
String toString() {
  return 'CreateReport(targetType: $targetType, targetId: $targetId, reason: $reason, details: $details)';
}


}

/// @nodoc
abstract mixin class $CreateReportCopyWith<$Res>  {
  factory $CreateReportCopyWith(CreateReport value, $Res Function(CreateReport) _then) = _$CreateReportCopyWithImpl;
@useResult
$Res call({
 ReportTarget targetType, String targetId, ReportReason reason, String? details
});




}
/// @nodoc
class _$CreateReportCopyWithImpl<$Res>
    implements $CreateReportCopyWith<$Res> {
  _$CreateReportCopyWithImpl(this._self, this._then);

  final CreateReport _self;
  final $Res Function(CreateReport) _then;

/// Create a copy of CreateReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetType = null,Object? targetId = null,Object? reason = null,Object? details = freezed,}) {
  return _then(_self.copyWith(
targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as ReportTarget,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReportReason,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateReport].
extension CreateReportPatterns on CreateReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateReport value)  $default,){
final _that = this;
switch (_that) {
case _CreateReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateReport value)?  $default,){
final _that = this;
switch (_that) {
case _CreateReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportTarget targetType,  String targetId,  ReportReason reason,  String? details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateReport() when $default != null:
return $default(_that.targetType,_that.targetId,_that.reason,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportTarget targetType,  String targetId,  ReportReason reason,  String? details)  $default,) {final _that = this;
switch (_that) {
case _CreateReport():
return $default(_that.targetType,_that.targetId,_that.reason,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportTarget targetType,  String targetId,  ReportReason reason,  String? details)?  $default,) {final _that = this;
switch (_that) {
case _CreateReport() when $default != null:
return $default(_that.targetType,_that.targetId,_that.reason,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateReport implements CreateReport {
  const _CreateReport({required this.targetType, required this.targetId, required this.reason, this.details});
  factory _CreateReport.fromJson(Map<String, dynamic> json) => _$CreateReportFromJson(json);

@override final  ReportTarget targetType;
/// For a user, their username is resolved by the client to the id shown on cards.
@override final  String targetId;
@override final  ReportReason reason;
@override final  String? details;

/// Create a copy of CreateReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateReportCopyWith<_CreateReport> get copyWith => __$CreateReportCopyWithImpl<_CreateReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateReport&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetType,targetId,reason,details);

@override
String toString() {
  return 'CreateReport(targetType: $targetType, targetId: $targetId, reason: $reason, details: $details)';
}


}

/// @nodoc
abstract mixin class _$CreateReportCopyWith<$Res> implements $CreateReportCopyWith<$Res> {
  factory _$CreateReportCopyWith(_CreateReport value, $Res Function(_CreateReport) _then) = __$CreateReportCopyWithImpl;
@override @useResult
$Res call({
 ReportTarget targetType, String targetId, ReportReason reason, String? details
});




}
/// @nodoc
class __$CreateReportCopyWithImpl<$Res>
    implements _$CreateReportCopyWith<$Res> {
  __$CreateReportCopyWithImpl(this._self, this._then);

  final _CreateReport _self;
  final $Res Function(_CreateReport) _then;

/// Create a copy of CreateReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetType = null,Object? targetId = null,Object? reason = null,Object? details = freezed,}) {
  return _then(_CreateReport(
targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as ReportTarget,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReportReason,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
