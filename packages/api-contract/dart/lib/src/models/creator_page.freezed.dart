// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'creator_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatorPage {

 List<CreatorCard> get items; String? get nextCursor;
/// Create a copy of CreatorPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatorPageCopyWith<CreatorPage> get copyWith => _$CreatorPageCopyWithImpl<CreatorPage>(this as CreatorPage, _$identity);

  /// Serializes this CreatorPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatorPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'CreatorPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $CreatorPageCopyWith<$Res>  {
  factory $CreatorPageCopyWith(CreatorPage value, $Res Function(CreatorPage) _then) = _$CreatorPageCopyWithImpl;
@useResult
$Res call({
 List<CreatorCard> items, String? nextCursor
});




}
/// @nodoc
class _$CreatorPageCopyWithImpl<$Res>
    implements $CreatorPageCopyWith<$Res> {
  _$CreatorPageCopyWithImpl(this._self, this._then);

  final CreatorPage _self;
  final $Res Function(CreatorPage) _then;

/// Create a copy of CreatorPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CreatorCard>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatorPage].
extension CreatorPagePatterns on CreatorPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatorPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatorPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatorPage value)  $default,){
final _that = this;
switch (_that) {
case _CreatorPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatorPage value)?  $default,){
final _that = this;
switch (_that) {
case _CreatorPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CreatorCard> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatorPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CreatorCard> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _CreatorPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CreatorCard> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _CreatorPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatorPage implements CreatorPage {
  const _CreatorPage({required final  List<CreatorCard> items, required this.nextCursor}): _items = items;
  factory _CreatorPage.fromJson(Map<String, dynamic> json) => _$CreatorPageFromJson(json);

 final  List<CreatorCard> _items;
@override List<CreatorCard> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of CreatorPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatorPageCopyWith<_CreatorPage> get copyWith => __$CreatorPageCopyWithImpl<_CreatorPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatorPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatorPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'CreatorPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$CreatorPageCopyWith<$Res> implements $CreatorPageCopyWith<$Res> {
  factory _$CreatorPageCopyWith(_CreatorPage value, $Res Function(_CreatorPage) _then) = __$CreatorPageCopyWithImpl;
@override @useResult
$Res call({
 List<CreatorCard> items, String? nextCursor
});




}
/// @nodoc
class __$CreatorPageCopyWithImpl<$Res>
    implements _$CreatorPageCopyWith<$Res> {
  __$CreatorPageCopyWithImpl(this._self, this._then);

  final _CreatorPage _self;
  final $Res Function(_CreatorPage) _then;

/// Create a copy of CreatorPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_CreatorPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CreatorCard>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
