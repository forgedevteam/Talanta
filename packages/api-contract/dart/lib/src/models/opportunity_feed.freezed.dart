// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opportunity_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpportunityFeed {

/// Paid placements, only on the first page.
 List<OpportunitySummary> get featured; List<OpportunitySummary> get items; String? get nextCursor;
/// Create a copy of OpportunityFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpportunityFeedCopyWith<OpportunityFeed> get copyWith => _$OpportunityFeedCopyWithImpl<OpportunityFeed>(this as OpportunityFeed, _$identity);

  /// Serializes this OpportunityFeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunityFeed&&const DeepCollectionEquality().equals(other.featured, featured)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(featured),const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'OpportunityFeed(featured: $featured, items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $OpportunityFeedCopyWith<$Res>  {
  factory $OpportunityFeedCopyWith(OpportunityFeed value, $Res Function(OpportunityFeed) _then) = _$OpportunityFeedCopyWithImpl;
@useResult
$Res call({
 List<OpportunitySummary> featured, List<OpportunitySummary> items, String? nextCursor
});




}
/// @nodoc
class _$OpportunityFeedCopyWithImpl<$Res>
    implements $OpportunityFeedCopyWith<$Res> {
  _$OpportunityFeedCopyWithImpl(this._self, this._then);

  final OpportunityFeed _self;
  final $Res Function(OpportunityFeed) _then;

/// Create a copy of OpportunityFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? featured = null,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as List<OpportunitySummary>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OpportunitySummary>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpportunityFeed].
extension OpportunityFeedPatterns on OpportunityFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpportunityFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpportunityFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpportunityFeed value)  $default,){
final _that = this;
switch (_that) {
case _OpportunityFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpportunityFeed value)?  $default,){
final _that = this;
switch (_that) {
case _OpportunityFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OpportunitySummary> featured,  List<OpportunitySummary> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpportunityFeed() when $default != null:
return $default(_that.featured,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OpportunitySummary> featured,  List<OpportunitySummary> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _OpportunityFeed():
return $default(_that.featured,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OpportunitySummary> featured,  List<OpportunitySummary> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _OpportunityFeed() when $default != null:
return $default(_that.featured,_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpportunityFeed implements OpportunityFeed {
  const _OpportunityFeed({required final  List<OpportunitySummary> featured, required final  List<OpportunitySummary> items, required this.nextCursor}): _featured = featured,_items = items;
  factory _OpportunityFeed.fromJson(Map<String, dynamic> json) => _$OpportunityFeedFromJson(json);

/// Paid placements, only on the first page.
 final  List<OpportunitySummary> _featured;
/// Paid placements, only on the first page.
@override List<OpportunitySummary> get featured {
  if (_featured is EqualUnmodifiableListView) return _featured;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featured);
}

 final  List<OpportunitySummary> _items;
@override List<OpportunitySummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of OpportunityFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpportunityFeedCopyWith<_OpportunityFeed> get copyWith => __$OpportunityFeedCopyWithImpl<_OpportunityFeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpportunityFeedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpportunityFeed&&const DeepCollectionEquality().equals(other._featured, _featured)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_featured),const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'OpportunityFeed(featured: $featured, items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$OpportunityFeedCopyWith<$Res> implements $OpportunityFeedCopyWith<$Res> {
  factory _$OpportunityFeedCopyWith(_OpportunityFeed value, $Res Function(_OpportunityFeed) _then) = __$OpportunityFeedCopyWithImpl;
@override @useResult
$Res call({
 List<OpportunitySummary> featured, List<OpportunitySummary> items, String? nextCursor
});




}
/// @nodoc
class __$OpportunityFeedCopyWithImpl<$Res>
    implements _$OpportunityFeedCopyWith<$Res> {
  __$OpportunityFeedCopyWithImpl(this._self, this._then);

  final _OpportunityFeed _self;
  final $Res Function(_OpportunityFeed) _then;

/// Create a copy of OpportunityFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? featured = null,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_OpportunityFeed(
featured: null == featured ? _self._featured : featured // ignore: cast_nullable_to_non_nullable
as List<OpportunitySummary>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OpportunitySummary>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
