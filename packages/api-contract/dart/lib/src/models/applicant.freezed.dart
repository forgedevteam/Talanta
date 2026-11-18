// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'applicant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Applicant {

 String get applicationId; ApplicationStatus get status; String get message; DateTime get createdAt; PersonSummary get applicant; PortfolioItem? get portfolioItem;
/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicantCopyWith<Applicant> get copyWith => _$ApplicantCopyWithImpl<Applicant>(this as Applicant, _$identity);

  /// Serializes this Applicant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Applicant&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.applicant, applicant) || other.applicant == applicant)&&(identical(other.portfolioItem, portfolioItem) || other.portfolioItem == portfolioItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,status,message,createdAt,applicant,portfolioItem);

@override
String toString() {
  return 'Applicant(applicationId: $applicationId, status: $status, message: $message, createdAt: $createdAt, applicant: $applicant, portfolioItem: $portfolioItem)';
}


}

/// @nodoc
abstract mixin class $ApplicantCopyWith<$Res>  {
  factory $ApplicantCopyWith(Applicant value, $Res Function(Applicant) _then) = _$ApplicantCopyWithImpl;
@useResult
$Res call({
 String applicationId, ApplicationStatus status, String message, DateTime createdAt, PersonSummary applicant, PortfolioItem? portfolioItem
});


$PersonSummaryCopyWith<$Res> get applicant;$PortfolioItemCopyWith<$Res>? get portfolioItem;

}
/// @nodoc
class _$ApplicantCopyWithImpl<$Res>
    implements $ApplicantCopyWith<$Res> {
  _$ApplicantCopyWithImpl(this._self, this._then);

  final Applicant _self;
  final $Res Function(Applicant) _then;

/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applicationId = null,Object? status = null,Object? message = null,Object? createdAt = null,Object? applicant = null,Object? portfolioItem = freezed,}) {
  return _then(_self.copyWith(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,applicant: null == applicant ? _self.applicant : applicant // ignore: cast_nullable_to_non_nullable
as PersonSummary,portfolioItem: freezed == portfolioItem ? _self.portfolioItem : portfolioItem // ignore: cast_nullable_to_non_nullable
as PortfolioItem?,
  ));
}
/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res> get applicant {
  
  return $PersonSummaryCopyWith<$Res>(_self.applicant, (value) {
    return _then(_self.copyWith(applicant: value));
  });
}/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioItemCopyWith<$Res>? get portfolioItem {
    if (_self.portfolioItem == null) {
    return null;
  }

  return $PortfolioItemCopyWith<$Res>(_self.portfolioItem!, (value) {
    return _then(_self.copyWith(portfolioItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [Applicant].
extension ApplicantPatterns on Applicant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Applicant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Applicant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Applicant value)  $default,){
final _that = this;
switch (_that) {
case _Applicant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Applicant value)?  $default,){
final _that = this;
switch (_that) {
case _Applicant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String applicationId,  ApplicationStatus status,  String message,  DateTime createdAt,  PersonSummary applicant,  PortfolioItem? portfolioItem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Applicant() when $default != null:
return $default(_that.applicationId,_that.status,_that.message,_that.createdAt,_that.applicant,_that.portfolioItem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String applicationId,  ApplicationStatus status,  String message,  DateTime createdAt,  PersonSummary applicant,  PortfolioItem? portfolioItem)  $default,) {final _that = this;
switch (_that) {
case _Applicant():
return $default(_that.applicationId,_that.status,_that.message,_that.createdAt,_that.applicant,_that.portfolioItem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String applicationId,  ApplicationStatus status,  String message,  DateTime createdAt,  PersonSummary applicant,  PortfolioItem? portfolioItem)?  $default,) {final _that = this;
switch (_that) {
case _Applicant() when $default != null:
return $default(_that.applicationId,_that.status,_that.message,_that.createdAt,_that.applicant,_that.portfolioItem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Applicant implements Applicant {
  const _Applicant({required this.applicationId, required this.status, required this.message, required this.createdAt, required this.applicant, required this.portfolioItem});
  factory _Applicant.fromJson(Map<String, dynamic> json) => _$ApplicantFromJson(json);

@override final  String applicationId;
@override final  ApplicationStatus status;
@override final  String message;
@override final  DateTime createdAt;
@override final  PersonSummary applicant;
@override final  PortfolioItem? portfolioItem;

/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicantCopyWith<_Applicant> get copyWith => __$ApplicantCopyWithImpl<_Applicant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Applicant&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.applicant, applicant) || other.applicant == applicant)&&(identical(other.portfolioItem, portfolioItem) || other.portfolioItem == portfolioItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,status,message,createdAt,applicant,portfolioItem);

@override
String toString() {
  return 'Applicant(applicationId: $applicationId, status: $status, message: $message, createdAt: $createdAt, applicant: $applicant, portfolioItem: $portfolioItem)';
}


}

/// @nodoc
abstract mixin class _$ApplicantCopyWith<$Res> implements $ApplicantCopyWith<$Res> {
  factory _$ApplicantCopyWith(_Applicant value, $Res Function(_Applicant) _then) = __$ApplicantCopyWithImpl;
@override @useResult
$Res call({
 String applicationId, ApplicationStatus status, String message, DateTime createdAt, PersonSummary applicant, PortfolioItem? portfolioItem
});


@override $PersonSummaryCopyWith<$Res> get applicant;@override $PortfolioItemCopyWith<$Res>? get portfolioItem;

}
/// @nodoc
class __$ApplicantCopyWithImpl<$Res>
    implements _$ApplicantCopyWith<$Res> {
  __$ApplicantCopyWithImpl(this._self, this._then);

  final _Applicant _self;
  final $Res Function(_Applicant) _then;

/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applicationId = null,Object? status = null,Object? message = null,Object? createdAt = null,Object? applicant = null,Object? portfolioItem = freezed,}) {
  return _then(_Applicant(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,applicant: null == applicant ? _self.applicant : applicant // ignore: cast_nullable_to_non_nullable
as PersonSummary,portfolioItem: freezed == portfolioItem ? _self.portfolioItem : portfolioItem // ignore: cast_nullable_to_non_nullable
as PortfolioItem?,
  ));
}

/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res> get applicant {
  
  return $PersonSummaryCopyWith<$Res>(_self.applicant, (value) {
    return _then(_self.copyWith(applicant: value));
  });
}/// Create a copy of Applicant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioItemCopyWith<$Res>? get portfolioItem {
    if (_self.portfolioItem == null) {
    return null;
  }

  return $PortfolioItemCopyWith<$Res>(_self.portfolioItem!, (value) {
    return _then(_self.copyWith(portfolioItem: value));
  });
}
}

// dart format on
