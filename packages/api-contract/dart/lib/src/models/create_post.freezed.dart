// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePost {

 String? get body;/// Uploaded files, in display order: up to 10 photos, or one video.
 List<String>? get mediaIds;/// Show this video in Reels too.
 bool? get isReel;
/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePostCopyWith<CreatePost> get copyWith => _$CreatePostCopyWithImpl<CreatePost>(this as CreatePost, _$identity);

  /// Serializes this CreatePost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePost&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.mediaIds, mediaIds)&&(identical(other.isReel, isReel) || other.isReel == isReel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,body,const DeepCollectionEquality().hash(mediaIds),isReel);

@override
String toString() {
  return 'CreatePost(body: $body, mediaIds: $mediaIds, isReel: $isReel)';
}


}

/// @nodoc
abstract mixin class $CreatePostCopyWith<$Res>  {
  factory $CreatePostCopyWith(CreatePost value, $Res Function(CreatePost) _then) = _$CreatePostCopyWithImpl;
@useResult
$Res call({
 String? body, List<String>? mediaIds, bool? isReel
});




}
/// @nodoc
class _$CreatePostCopyWithImpl<$Res>
    implements $CreatePostCopyWith<$Res> {
  _$CreatePostCopyWithImpl(this._self, this._then);

  final CreatePost _self;
  final $Res Function(CreatePost) _then;

/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? body = freezed,Object? mediaIds = freezed,Object? isReel = freezed,}) {
  return _then(_self.copyWith(
body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,mediaIds: freezed == mediaIds ? _self.mediaIds : mediaIds // ignore: cast_nullable_to_non_nullable
as List<String>?,isReel: freezed == isReel ? _self.isReel : isReel // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePost].
extension CreatePostPatterns on CreatePost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePost value)  $default,){
final _that = this;
switch (_that) {
case _CreatePost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePost value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? body,  List<String>? mediaIds,  bool? isReel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
return $default(_that.body,_that.mediaIds,_that.isReel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? body,  List<String>? mediaIds,  bool? isReel)  $default,) {final _that = this;
switch (_that) {
case _CreatePost():
return $default(_that.body,_that.mediaIds,_that.isReel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? body,  List<String>? mediaIds,  bool? isReel)?  $default,) {final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
return $default(_that.body,_that.mediaIds,_that.isReel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePost implements CreatePost {
  const _CreatePost({this.body, final  List<String>? mediaIds, this.isReel}): _mediaIds = mediaIds;
  factory _CreatePost.fromJson(Map<String, dynamic> json) => _$CreatePostFromJson(json);

@override final  String? body;
/// Uploaded files, in display order: up to 10 photos, or one video.
 final  List<String>? _mediaIds;
/// Uploaded files, in display order: up to 10 photos, or one video.
@override List<String>? get mediaIds {
  final value = _mediaIds;
  if (value == null) return null;
  if (_mediaIds is EqualUnmodifiableListView) return _mediaIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Show this video in Reels too.
@override final  bool? isReel;

/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePostCopyWith<_CreatePost> get copyWith => __$CreatePostCopyWithImpl<_CreatePost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePost&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._mediaIds, _mediaIds)&&(identical(other.isReel, isReel) || other.isReel == isReel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,body,const DeepCollectionEquality().hash(_mediaIds),isReel);

@override
String toString() {
  return 'CreatePost(body: $body, mediaIds: $mediaIds, isReel: $isReel)';
}


}

/// @nodoc
abstract mixin class _$CreatePostCopyWith<$Res> implements $CreatePostCopyWith<$Res> {
  factory _$CreatePostCopyWith(_CreatePost value, $Res Function(_CreatePost) _then) = __$CreatePostCopyWithImpl;
@override @useResult
$Res call({
 String? body, List<String>? mediaIds, bool? isReel
});




}
/// @nodoc
class __$CreatePostCopyWithImpl<$Res>
    implements _$CreatePostCopyWith<$Res> {
  __$CreatePostCopyWithImpl(this._self, this._then);

  final _CreatePost _self;
  final $Res Function(_CreatePost) _then;

/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? body = freezed,Object? mediaIds = freezed,Object? isReel = freezed,}) {
  return _then(_CreatePost(
body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,mediaIds: freezed == mediaIds ? _self._mediaIds : mediaIds // ignore: cast_nullable_to_non_nullable
as List<String>?,isReel: freezed == isReel ? _self.isReel : isReel // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
