// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityItem {

 String get id; NotificationType get type; PersonSummary? get actor; String? get opportunityId; String? get opportunityTitle;/// The application’s current status, for status notifications.
 ApplicationStatus? get applicationStatus; bool get isRead; DateTime get createdAt;
/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityItemCopyWith<ActivityItem> get copyWith => _$ActivityItemCopyWithImpl<ActivityItem>(this as ActivityItem, _$identity);

  /// Serializes this ActivityItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.opportunityId, opportunityId) || other.opportunityId == opportunityId)&&(identical(other.opportunityTitle, opportunityTitle) || other.opportunityTitle == opportunityTitle)&&(identical(other.applicationStatus, applicationStatus) || other.applicationStatus == applicationStatus)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,actor,opportunityId,opportunityTitle,applicationStatus,isRead,createdAt);

@override
String toString() {
  return 'ActivityItem(id: $id, type: $type, actor: $actor, opportunityId: $opportunityId, opportunityTitle: $opportunityTitle, applicationStatus: $applicationStatus, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ActivityItemCopyWith<$Res>  {
  factory $ActivityItemCopyWith(ActivityItem value, $Res Function(ActivityItem) _then) = _$ActivityItemCopyWithImpl;
@useResult
$Res call({
 String id, NotificationType type, PersonSummary? actor, String? opportunityId, String? opportunityTitle, ApplicationStatus? applicationStatus, bool isRead, DateTime createdAt
});


$PersonSummaryCopyWith<$Res>? get actor;

}
/// @nodoc
class _$ActivityItemCopyWithImpl<$Res>
    implements $ActivityItemCopyWith<$Res> {
  _$ActivityItemCopyWithImpl(this._self, this._then);

  final ActivityItem _self;
  final $Res Function(ActivityItem) _then;

/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? actor = freezed,Object? opportunityId = freezed,Object? opportunityTitle = freezed,Object? applicationStatus = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as PersonSummary?,opportunityId: freezed == opportunityId ? _self.opportunityId : opportunityId // ignore: cast_nullable_to_non_nullable
as String?,opportunityTitle: freezed == opportunityTitle ? _self.opportunityTitle : opportunityTitle // ignore: cast_nullable_to_non_nullable
as String?,applicationStatus: freezed == applicationStatus ? _self.applicationStatus : applicationStatus // ignore: cast_nullable_to_non_nullable
as ApplicationStatus?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res>? get actor {
    if (_self.actor == null) {
    return null;
  }

  return $PersonSummaryCopyWith<$Res>(_self.actor!, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityItem].
extension ActivityItemPatterns on ActivityItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityItem value)  $default,){
final _that = this;
switch (_that) {
case _ActivityItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityItem value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  NotificationType type,  PersonSummary? actor,  String? opportunityId,  String? opportunityTitle,  ApplicationStatus? applicationStatus,  bool isRead,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
return $default(_that.id,_that.type,_that.actor,_that.opportunityId,_that.opportunityTitle,_that.applicationStatus,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  NotificationType type,  PersonSummary? actor,  String? opportunityId,  String? opportunityTitle,  ApplicationStatus? applicationStatus,  bool isRead,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ActivityItem():
return $default(_that.id,_that.type,_that.actor,_that.opportunityId,_that.opportunityTitle,_that.applicationStatus,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  NotificationType type,  PersonSummary? actor,  String? opportunityId,  String? opportunityTitle,  ApplicationStatus? applicationStatus,  bool isRead,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
return $default(_that.id,_that.type,_that.actor,_that.opportunityId,_that.opportunityTitle,_that.applicationStatus,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityItem implements ActivityItem {
  const _ActivityItem({required this.id, required this.type, required this.actor, required this.opportunityId, required this.opportunityTitle, required this.applicationStatus, required this.isRead, required this.createdAt});
  factory _ActivityItem.fromJson(Map<String, dynamic> json) => _$ActivityItemFromJson(json);

@override final  String id;
@override final  NotificationType type;
@override final  PersonSummary? actor;
@override final  String? opportunityId;
@override final  String? opportunityTitle;
/// The application’s current status, for status notifications.
@override final  ApplicationStatus? applicationStatus;
@override final  bool isRead;
@override final  DateTime createdAt;

/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityItemCopyWith<_ActivityItem> get copyWith => __$ActivityItemCopyWithImpl<_ActivityItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.opportunityId, opportunityId) || other.opportunityId == opportunityId)&&(identical(other.opportunityTitle, opportunityTitle) || other.opportunityTitle == opportunityTitle)&&(identical(other.applicationStatus, applicationStatus) || other.applicationStatus == applicationStatus)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,actor,opportunityId,opportunityTitle,applicationStatus,isRead,createdAt);

@override
String toString() {
  return 'ActivityItem(id: $id, type: $type, actor: $actor, opportunityId: $opportunityId, opportunityTitle: $opportunityTitle, applicationStatus: $applicationStatus, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ActivityItemCopyWith<$Res> implements $ActivityItemCopyWith<$Res> {
  factory _$ActivityItemCopyWith(_ActivityItem value, $Res Function(_ActivityItem) _then) = __$ActivityItemCopyWithImpl;
@override @useResult
$Res call({
 String id, NotificationType type, PersonSummary? actor, String? opportunityId, String? opportunityTitle, ApplicationStatus? applicationStatus, bool isRead, DateTime createdAt
});


@override $PersonSummaryCopyWith<$Res>? get actor;

}
/// @nodoc
class __$ActivityItemCopyWithImpl<$Res>
    implements _$ActivityItemCopyWith<$Res> {
  __$ActivityItemCopyWithImpl(this._self, this._then);

  final _ActivityItem _self;
  final $Res Function(_ActivityItem) _then;

/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? actor = freezed,Object? opportunityId = freezed,Object? opportunityTitle = freezed,Object? applicationStatus = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_ActivityItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as PersonSummary?,opportunityId: freezed == opportunityId ? _self.opportunityId : opportunityId // ignore: cast_nullable_to_non_nullable
as String?,opportunityTitle: freezed == opportunityTitle ? _self.opportunityTitle : opportunityTitle // ignore: cast_nullable_to_non_nullable
as String?,applicationStatus: freezed == applicationStatus ? _self.applicationStatus : applicationStatus // ignore: cast_nullable_to_non_nullable
as ApplicationStatus?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<$Res>? get actor {
    if (_self.actor == null) {
    return null;
  }

  return $PersonSummaryCopyWith<$Res>(_self.actor!, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}

// dart format on
