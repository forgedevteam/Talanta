// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityPage {

 List<ActivityItem> get items; String? get nextCursor;
/// Create a copy of ActivityPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityPageCopyWith<ActivityPage> get copyWith => _$ActivityPageCopyWithImpl<ActivityPage>(this as ActivityPage, _$identity);

  /// Serializes this ActivityPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'ActivityPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $ActivityPageCopyWith<$Res>  {
  factory $ActivityPageCopyWith(ActivityPage value, $Res Function(ActivityPage) _then) = _$ActivityPageCopyWithImpl;
@useResult
$Res call({
 List<ActivityItem> items, String? nextCursor
});




}
/// @nodoc
class _$ActivityPageCopyWithImpl<$Res>
    implements $ActivityPageCopyWith<$Res> {
  _$ActivityPageCopyWithImpl(this._self, this._then);

  final ActivityPage _self;
  final $Res Function(ActivityPage) _then;

/// Create a copy of ActivityPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ActivityItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityPage].
extension ActivityPagePatterns on ActivityPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityPage value)  $default,){
final _that = this;
switch (_that) {
case _ActivityPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityPage value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ActivityItem> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ActivityItem> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ActivityPage():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ActivityItem> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ActivityPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityPage implements ActivityPage {
  const _ActivityPage({required final  List<ActivityItem> items, required this.nextCursor}): _items = items;
  factory _ActivityPage.fromJson(Map<String, dynamic> json) => _$ActivityPageFromJson(json);

 final  List<ActivityItem> _items;
@override List<ActivityItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of ActivityPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityPageCopyWith<_ActivityPage> get copyWith => __$ActivityPageCopyWithImpl<_ActivityPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'ActivityPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ActivityPageCopyWith<$Res> implements $ActivityPageCopyWith<$Res> {
  factory _$ActivityPageCopyWith(_ActivityPage value, $Res Function(_ActivityPage) _then) = __$ActivityPageCopyWithImpl;
@override @useResult
$Res call({
 List<ActivityItem> items, String? nextCursor
});




}
/// @nodoc
class __$ActivityPageCopyWithImpl<$Res>
    implements _$ActivityPageCopyWith<$Res> {
  __$ActivityPageCopyWithImpl(this._self, this._then);

  final _ActivityPage _self;
  final $Res Function(_ActivityPage) _then;

/// Create a copy of ActivityPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_ActivityPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ActivityItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
