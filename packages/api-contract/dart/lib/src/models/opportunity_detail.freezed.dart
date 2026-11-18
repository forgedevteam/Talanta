// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opportunity_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpportunityDetail {

 String get id; String get title; TalentCategory get category; String get city; String get country; CompensationType get compensation; num? get budgetAmount; String get currency;/// YYYY-MM-DD.
 String? get deadline; OpportunityStatus get status;/// Paid placement. Show with a Featured label.
 bool get isFeatured; num get applicationsCount; PersonSummary? get poster; DateTime get createdAt; String get description;/// The signed-in person posted this.
 bool get isMine; MyApplicationRef? get myApplication;
/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpportunityDetailCopyWith<OpportunityDetail> get copyWith => _$OpportunityDetailCopyWithImpl<OpportunityDetail>(this as OpportunityDetail, _$identity);

  /// Serializes this OpportunityDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunityDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.compensation, compensation) || other.compensation == compensation)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.applicationsCount, applicationsCount) || other.applicationsCount == applicationsCount)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.myApplication, myApplication) || other.myApplication == myApplication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,city,country,compensation,budgetAmount,currency,deadline,status,isFeatured,applicationsCount,poster,createdAt,description,isMine,myApplication);

@override
String toString() {
  return 'OpportunityDetail(id: $id, title: $title, category: $category, city: $city, country: $country, compensation: $compensation, budgetAmount: $budgetAmount, currency: $currency, deadline: $deadline, status: $status, isFeatured: $isFeatured, applicationsCount: $applicationsCount, poster: $poster, createdAt: $createdAt, description: $description, isMine: $isMine, myApplication: $myApplication)';
}


}

/// @nodoc
abstract mixin class $OpportunityDetailCopyWith<$Res>  {
  factory $OpportunityDetailCopyWith(OpportunityDetail value, $Res Function(OpportunityDetail) _then) = _$OpportunityDetailCopyWithImpl;
@useResult
$Res call({
 String id, String title, TalentCategory category, String city, String country, CompensationType compensation, num? budgetAmount, String currency, String? deadline, OpportunityStatus status, bool isFeatured, num applicationsCount, PersonSummary? poster, DateTime createdAt, String description, bool isMine, MyApplicationRef? myApplication
});


$TalentCategoryCopyWith<$Res> get category;$PersonSummaryCopyWith<$Res>? get poster;$MyApplicationRefCopyWith<$Res>? get myApplication;

}
/// @nodoc
class _$OpportunityDetailCopyWithImpl<$Res>
    implements $OpportunityDetailCopyWith<$Res> {
  _$OpportunityDetailCopyWithImpl(this._self, this._then);

  final OpportunityDetail _self;
  final $Res Function(OpportunityDetail) _then;

/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? city = null,Object? country = null,Object? compensation = null,Object? budgetAmount = freezed,Object? currency = null,Object? deadline = freezed,Object? status = null,Object? isFeatured = null,Object? applicationsCount = null,Object? poster = freezed,Object? createdAt = null,Object? description = null,Object? isMine = null,Object? myApplication = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TalentCategory,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,compensation: null == compensation ? _self.compensation : compensation // ignore: cast_nullable_to_non_nullable
as CompensationType,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as num?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OpportunityStatus,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,applicationsCount: null == applicationsCount ? _self.applicationsCount : applicationsCount // ignore: cast_nullable_to_non_nullable
as num,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as PersonSummary?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,myApplication: freezed == myApplication ? _self.myApplication : myApplication // ignore: cast_nullable_to_non_nullable
as MyApplicationRef?,
  ));
}
/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TalentCategoryCopyWith<$Res> get category {
  
  return $TalentCategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res>? get poster {
    if (_self.poster == null) {
    return null;
  }

  return $PersonSummaryCopyWith<$Res>(_self.poster!, (value) {
    return _then(_self.copyWith(poster: value));
  });
}/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyApplicationRefCopyWith<$Res>? get myApplication {
    if (_self.myApplication == null) {
    return null;
  }

  return $MyApplicationRefCopyWith<$Res>(_self.myApplication!, (value) {
    return _then(_self.copyWith(myApplication: value));
  });
}
}


/// Adds pattern-matching-related methods to [OpportunityDetail].
extension OpportunityDetailPatterns on OpportunityDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpportunityDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpportunityDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpportunityDetail value)  $default,){
final _that = this;
switch (_that) {
case _OpportunityDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpportunityDetail value)?  $default,){
final _that = this;
switch (_that) {
case _OpportunityDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  TalentCategory category,  String city,  String country,  CompensationType compensation,  num? budgetAmount,  String currency,  String? deadline,  OpportunityStatus status,  bool isFeatured,  num applicationsCount,  PersonSummary? poster,  DateTime createdAt,  String description,  bool isMine,  MyApplicationRef? myApplication)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpportunityDetail() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.city,_that.country,_that.compensation,_that.budgetAmount,_that.currency,_that.deadline,_that.status,_that.isFeatured,_that.applicationsCount,_that.poster,_that.createdAt,_that.description,_that.isMine,_that.myApplication);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  TalentCategory category,  String city,  String country,  CompensationType compensation,  num? budgetAmount,  String currency,  String? deadline,  OpportunityStatus status,  bool isFeatured,  num applicationsCount,  PersonSummary? poster,  DateTime createdAt,  String description,  bool isMine,  MyApplicationRef? myApplication)  $default,) {final _that = this;
switch (_that) {
case _OpportunityDetail():
return $default(_that.id,_that.title,_that.category,_that.city,_that.country,_that.compensation,_that.budgetAmount,_that.currency,_that.deadline,_that.status,_that.isFeatured,_that.applicationsCount,_that.poster,_that.createdAt,_that.description,_that.isMine,_that.myApplication);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  TalentCategory category,  String city,  String country,  CompensationType compensation,  num? budgetAmount,  String currency,  String? deadline,  OpportunityStatus status,  bool isFeatured,  num applicationsCount,  PersonSummary? poster,  DateTime createdAt,  String description,  bool isMine,  MyApplicationRef? myApplication)?  $default,) {final _that = this;
switch (_that) {
case _OpportunityDetail() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.city,_that.country,_that.compensation,_that.budgetAmount,_that.currency,_that.deadline,_that.status,_that.isFeatured,_that.applicationsCount,_that.poster,_that.createdAt,_that.description,_that.isMine,_that.myApplication);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpportunityDetail implements OpportunityDetail {
  const _OpportunityDetail({required this.id, required this.title, required this.category, required this.city, required this.country, required this.compensation, required this.budgetAmount, required this.currency, required this.deadline, required this.status, required this.isFeatured, required this.applicationsCount, required this.poster, required this.createdAt, required this.description, required this.isMine, required this.myApplication});
  factory _OpportunityDetail.fromJson(Map<String, dynamic> json) => _$OpportunityDetailFromJson(json);

@override final  String id;
@override final  String title;
@override final  TalentCategory category;
@override final  String city;
@override final  String country;
@override final  CompensationType compensation;
@override final  num? budgetAmount;
@override final  String currency;
/// YYYY-MM-DD.
@override final  String? deadline;
@override final  OpportunityStatus status;
/// Paid placement. Show with a Featured label.
@override final  bool isFeatured;
@override final  num applicationsCount;
@override final  PersonSummary? poster;
@override final  DateTime createdAt;
@override final  String description;
/// The signed-in person posted this.
@override final  bool isMine;
@override final  MyApplicationRef? myApplication;

/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpportunityDetailCopyWith<_OpportunityDetail> get copyWith => __$OpportunityDetailCopyWithImpl<_OpportunityDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpportunityDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpportunityDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.compensation, compensation) || other.compensation == compensation)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.applicationsCount, applicationsCount) || other.applicationsCount == applicationsCount)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.myApplication, myApplication) || other.myApplication == myApplication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,city,country,compensation,budgetAmount,currency,deadline,status,isFeatured,applicationsCount,poster,createdAt,description,isMine,myApplication);

@override
String toString() {
  return 'OpportunityDetail(id: $id, title: $title, category: $category, city: $city, country: $country, compensation: $compensation, budgetAmount: $budgetAmount, currency: $currency, deadline: $deadline, status: $status, isFeatured: $isFeatured, applicationsCount: $applicationsCount, poster: $poster, createdAt: $createdAt, description: $description, isMine: $isMine, myApplication: $myApplication)';
}


}

/// @nodoc
abstract mixin class _$OpportunityDetailCopyWith<$Res> implements $OpportunityDetailCopyWith<$Res> {
  factory _$OpportunityDetailCopyWith(_OpportunityDetail value, $Res Function(_OpportunityDetail) _then) = __$OpportunityDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, TalentCategory category, String city, String country, CompensationType compensation, num? budgetAmount, String currency, String? deadline, OpportunityStatus status, bool isFeatured, num applicationsCount, PersonSummary? poster, DateTime createdAt, String description, bool isMine, MyApplicationRef? myApplication
});


@override $TalentCategoryCopyWith<$Res> get category;@override $PersonSummaryCopyWith<$Res>? get poster;@override $MyApplicationRefCopyWith<$Res>? get myApplication;

}
/// @nodoc
class __$OpportunityDetailCopyWithImpl<$Res>
    implements _$OpportunityDetailCopyWith<$Res> {
  __$OpportunityDetailCopyWithImpl(this._self, this._then);

  final _OpportunityDetail _self;
  final $Res Function(_OpportunityDetail) _then;

/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? city = null,Object? country = null,Object? compensation = null,Object? budgetAmount = freezed,Object? currency = null,Object? deadline = freezed,Object? status = null,Object? isFeatured = null,Object? applicationsCount = null,Object? poster = freezed,Object? createdAt = null,Object? description = null,Object? isMine = null,Object? myApplication = freezed,}) {
  return _then(_OpportunityDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TalentCategory,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,compensation: null == compensation ? _self.compensation : compensation // ignore: cast_nullable_to_non_nullable
as CompensationType,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as num?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OpportunityStatus,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,applicationsCount: null == applicationsCount ? _self.applicationsCount : applicationsCount // ignore: cast_nullable_to_non_nullable
as num,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as PersonSummary?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,myApplication: freezed == myApplication ? _self.myApplication : myApplication // ignore: cast_nullable_to_non_nullable
as MyApplicationRef?,
  ));
}

/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TalentCategoryCopyWith<$Res> get category {
  
  return $TalentCategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res>? get poster {
    if (_self.poster == null) {
    return null;
  }

  return $PersonSummaryCopyWith<$Res>(_self.poster!, (value) {
    return _then(_self.copyWith(poster: value));
  });
}/// Create a copy of OpportunityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyApplicationRefCopyWith<$Res>? get myApplication {
    if (_self.myApplication == null) {
    return null;
  }

  return $MyApplicationRefCopyWith<$Res>(_self.myApplication!, (value) {
    return _then(_self.copyWith(myApplication: value));
  });
}
}

// dart format on
