// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_promotion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePromotion {

 PromotionPlacement get placement; String get sponsorName; String get title; String get body; String get ctaLabel; String get url; DateTime get startsAt; DateTime get endsAt;
/// Create a copy of CreatePromotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePromotionCopyWith<CreatePromotion> get copyWith => _$CreatePromotionCopyWithImpl<CreatePromotion>(this as CreatePromotion, _$identity);

  /// Serializes this CreatePromotion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePromotion&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.sponsorName, sponsorName) || other.sponsorName == sponsorName)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.ctaLabel, ctaLabel) || other.ctaLabel == ctaLabel)&&(identical(other.url, url) || other.url == url)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,placement,sponsorName,title,body,ctaLabel,url,startsAt,endsAt);

@override
String toString() {
  return 'CreatePromotion(placement: $placement, sponsorName: $sponsorName, title: $title, body: $body, ctaLabel: $ctaLabel, url: $url, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $CreatePromotionCopyWith<$Res>  {
  factory $CreatePromotionCopyWith(CreatePromotion value, $Res Function(CreatePromotion) _then) = _$CreatePromotionCopyWithImpl;
@useResult
$Res call({
 PromotionPlacement placement, String sponsorName, String title, String body, String ctaLabel, String url, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class _$CreatePromotionCopyWithImpl<$Res>
    implements $CreatePromotionCopyWith<$Res> {
  _$CreatePromotionCopyWithImpl(this._self, this._then);

  final CreatePromotion _self;
  final $Res Function(CreatePromotion) _then;

/// Create a copy of CreatePromotion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? placement = null,Object? sponsorName = null,Object? title = null,Object? body = null,Object? ctaLabel = null,Object? url = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_self.copyWith(
placement: null == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as PromotionPlacement,sponsorName: null == sponsorName ? _self.sponsorName : sponsorName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,ctaLabel: null == ctaLabel ? _self.ctaLabel : ctaLabel // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePromotion].
extension CreatePromotionPatterns on CreatePromotion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePromotion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePromotion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePromotion value)  $default,){
final _that = this;
switch (_that) {
case _CreatePromotion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePromotion value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePromotion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PromotionPlacement placement,  String sponsorName,  String title,  String body,  String ctaLabel,  String url,  DateTime startsAt,  DateTime endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePromotion() when $default != null:
return $default(_that.placement,_that.sponsorName,_that.title,_that.body,_that.ctaLabel,_that.url,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PromotionPlacement placement,  String sponsorName,  String title,  String body,  String ctaLabel,  String url,  DateTime startsAt,  DateTime endsAt)  $default,) {final _that = this;
switch (_that) {
case _CreatePromotion():
return $default(_that.placement,_that.sponsorName,_that.title,_that.body,_that.ctaLabel,_that.url,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PromotionPlacement placement,  String sponsorName,  String title,  String body,  String ctaLabel,  String url,  DateTime startsAt,  DateTime endsAt)?  $default,) {final _that = this;
switch (_that) {
case _CreatePromotion() when $default != null:
return $default(_that.placement,_that.sponsorName,_that.title,_that.body,_that.ctaLabel,_that.url,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePromotion implements CreatePromotion {
  const _CreatePromotion({required this.placement, required this.sponsorName, required this.title, required this.body, required this.ctaLabel, required this.url, required this.startsAt, required this.endsAt});
  factory _CreatePromotion.fromJson(Map<String, dynamic> json) => _$CreatePromotionFromJson(json);

@override final  PromotionPlacement placement;
@override final  String sponsorName;
@override final  String title;
@override final  String body;
@override final  String ctaLabel;
@override final  String url;
@override final  DateTime startsAt;
@override final  DateTime endsAt;

/// Create a copy of CreatePromotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePromotionCopyWith<_CreatePromotion> get copyWith => __$CreatePromotionCopyWithImpl<_CreatePromotion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePromotionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePromotion&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.sponsorName, sponsorName) || other.sponsorName == sponsorName)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.ctaLabel, ctaLabel) || other.ctaLabel == ctaLabel)&&(identical(other.url, url) || other.url == url)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,placement,sponsorName,title,body,ctaLabel,url,startsAt,endsAt);

@override
String toString() {
  return 'CreatePromotion(placement: $placement, sponsorName: $sponsorName, title: $title, body: $body, ctaLabel: $ctaLabel, url: $url, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$CreatePromotionCopyWith<$Res> implements $CreatePromotionCopyWith<$Res> {
  factory _$CreatePromotionCopyWith(_CreatePromotion value, $Res Function(_CreatePromotion) _then) = __$CreatePromotionCopyWithImpl;
@override @useResult
$Res call({
 PromotionPlacement placement, String sponsorName, String title, String body, String ctaLabel, String url, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class __$CreatePromotionCopyWithImpl<$Res>
    implements _$CreatePromotionCopyWith<$Res> {
  __$CreatePromotionCopyWithImpl(this._self, this._then);

  final _CreatePromotion _self;
  final $Res Function(_CreatePromotion) _then;

/// Create a copy of CreatePromotion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? placement = null,Object? sponsorName = null,Object? title = null,Object? body = null,Object? ctaLabel = null,Object? url = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_CreatePromotion(
placement: null == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as PromotionPlacement,sponsorName: null == sponsorName ? _self.sponsorName : sponsorName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,ctaLabel: null == ctaLabel ? _self.ctaLabel : ctaLabel // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
