// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_application_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyApplicationRef {

 String get id; ApplicationStatus get status;
/// Create a copy of MyApplicationRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyApplicationRefCopyWith<MyApplicationRef> get copyWith => _$MyApplicationRefCopyWithImpl<MyApplicationRef>(this as MyApplicationRef, _$identity);

  /// Serializes this MyApplicationRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyApplicationRef&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status);

@override
String toString() {
  return 'MyApplicationRef(id: $id, status: $status)';
}


}

/// @nodoc
abstract mixin class $MyApplicationRefCopyWith<$Res>  {
  factory $MyApplicationRefCopyWith(MyApplicationRef value, $Res Function(MyApplicationRef) _then) = _$MyApplicationRefCopyWithImpl;
@useResult
$Res call({
 String id, ApplicationStatus status
});




}
/// @nodoc
class _$MyApplicationRefCopyWithImpl<$Res>
    implements $MyApplicationRefCopyWith<$Res> {
  _$MyApplicationRefCopyWithImpl(this._self, this._then);

  final MyApplicationRef _self;
  final $Res Function(MyApplicationRef) _then;

/// Create a copy of MyApplicationRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MyApplicationRef].
extension MyApplicationRefPatterns on MyApplicationRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyApplicationRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyApplicationRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyApplicationRef value)  $default,){
final _that = this;
switch (_that) {
case _MyApplicationRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyApplicationRef value)?  $default,){
final _that = this;
switch (_that) {
case _MyApplicationRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ApplicationStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyApplicationRef() when $default != null:
return $default(_that.id,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ApplicationStatus status)  $default,) {final _that = this;
switch (_that) {
case _MyApplicationRef():
return $default(_that.id,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ApplicationStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MyApplicationRef() when $default != null:
return $default(_that.id,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyApplicationRef implements MyApplicationRef {
  const _MyApplicationRef({required this.id, required this.status});
  factory _MyApplicationRef.fromJson(Map<String, dynamic> json) => _$MyApplicationRefFromJson(json);

@override final  String id;
@override final  ApplicationStatus status;

/// Create a copy of MyApplicationRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyApplicationRefCopyWith<_MyApplicationRef> get copyWith => __$MyApplicationRefCopyWithImpl<_MyApplicationRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyApplicationRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyApplicationRef&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status);

@override
String toString() {
  return 'MyApplicationRef(id: $id, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MyApplicationRefCopyWith<$Res> implements $MyApplicationRefCopyWith<$Res> {
  factory _$MyApplicationRefCopyWith(_MyApplicationRef value, $Res Function(_MyApplicationRef) _then) = __$MyApplicationRefCopyWithImpl;
@override @useResult
$Res call({
 String id, ApplicationStatus status
});




}
/// @nodoc
class __$MyApplicationRefCopyWithImpl<$Res>
    implements _$MyApplicationRefCopyWith<$Res> {
  __$MyApplicationRefCopyWithImpl(this._self, this._then);

  final _MyApplicationRef _self;
  final $Res Function(_MyApplicationRef) _then;

/// Create a copy of MyApplicationRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,}) {
  return _then(_MyApplicationRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,
  ));
}


}

// dart format on
