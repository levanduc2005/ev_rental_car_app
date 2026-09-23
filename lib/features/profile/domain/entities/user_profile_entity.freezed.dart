// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfileEntity {

 String get email; String? get fullName; String? get phone; String get role; int get point; bool get isBlocked; DateTime? get createdAt; String? get avatarUrl; List<KycDocumentEntity> get documents;
/// Create a copy of UserProfileEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileEntityCopyWith<UserProfileEntity> get copyWith => _$UserProfileEntityCopyWithImpl<UserProfileEntity>(this as UserProfileEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileEntity&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.point, point) || other.point == point)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&const DeepCollectionEquality().equals(other.documents, documents));
}


@override
int get hashCode => Object.hash(runtimeType,email,fullName,phone,role,point,isBlocked,createdAt,avatarUrl,const DeepCollectionEquality().hash(documents));

@override
String toString() {
  return 'UserProfileEntity(email: $email, fullName: $fullName, phone: $phone, role: $role, point: $point, isBlocked: $isBlocked, createdAt: $createdAt, avatarUrl: $avatarUrl, documents: $documents)';
}


}

/// @nodoc
abstract mixin class $UserProfileEntityCopyWith<$Res>  {
  factory $UserProfileEntityCopyWith(UserProfileEntity value, $Res Function(UserProfileEntity) _then) = _$UserProfileEntityCopyWithImpl;
@useResult
$Res call({
 String email, String? fullName, String? phone, String role, int point, bool isBlocked, DateTime? createdAt, String? avatarUrl, List<KycDocumentEntity> documents
});




}
/// @nodoc
class _$UserProfileEntityCopyWithImpl<$Res>
    implements $UserProfileEntityCopyWith<$Res> {
  _$UserProfileEntityCopyWithImpl(this._self, this._then);

  final UserProfileEntity _self;
  final $Res Function(UserProfileEntity) _then;

/// Create a copy of UserProfileEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? fullName = freezed,Object? phone = freezed,Object? role = null,Object? point = null,Object? isBlocked = null,Object? createdAt = freezed,Object? avatarUrl = freezed,Object? documents = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as int,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as List<KycDocumentEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileEntity].
extension UserProfileEntityPatterns on UserProfileEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String? fullName,  String? phone,  String role,  int point,  bool isBlocked,  DateTime? createdAt,  String? avatarUrl,  List<KycDocumentEntity> documents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileEntity() when $default != null:
return $default(_that.email,_that.fullName,_that.phone,_that.role,_that.point,_that.isBlocked,_that.createdAt,_that.avatarUrl,_that.documents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String? fullName,  String? phone,  String role,  int point,  bool isBlocked,  DateTime? createdAt,  String? avatarUrl,  List<KycDocumentEntity> documents)  $default,) {final _that = this;
switch (_that) {
case _UserProfileEntity():
return $default(_that.email,_that.fullName,_that.phone,_that.role,_that.point,_that.isBlocked,_that.createdAt,_that.avatarUrl,_that.documents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String? fullName,  String? phone,  String role,  int point,  bool isBlocked,  DateTime? createdAt,  String? avatarUrl,  List<KycDocumentEntity> documents)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileEntity() when $default != null:
return $default(_that.email,_that.fullName,_that.phone,_that.role,_that.point,_that.isBlocked,_that.createdAt,_that.avatarUrl,_that.documents);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfileEntity extends UserProfileEntity {
  const _UserProfileEntity({required this.email, this.fullName, this.phone, this.role = 'RENTER', this.point = 0, this.isBlocked = false, this.createdAt, this.avatarUrl, final  List<KycDocumentEntity> documents = const []}): _documents = documents,super._();
  

@override final  String email;
@override final  String? fullName;
@override final  String? phone;
@override@JsonKey() final  String role;
@override@JsonKey() final  int point;
@override@JsonKey() final  bool isBlocked;
@override final  DateTime? createdAt;
@override final  String? avatarUrl;
 final  List<KycDocumentEntity> _documents;
@override@JsonKey() List<KycDocumentEntity> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}


/// Create a copy of UserProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileEntityCopyWith<_UserProfileEntity> get copyWith => __$UserProfileEntityCopyWithImpl<_UserProfileEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileEntity&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.point, point) || other.point == point)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&const DeepCollectionEquality().equals(other._documents, _documents));
}


@override
int get hashCode => Object.hash(runtimeType,email,fullName,phone,role,point,isBlocked,createdAt,avatarUrl,const DeepCollectionEquality().hash(_documents));

@override
String toString() {
  return 'UserProfileEntity(email: $email, fullName: $fullName, phone: $phone, role: $role, point: $point, isBlocked: $isBlocked, createdAt: $createdAt, avatarUrl: $avatarUrl, documents: $documents)';
}


}

/// @nodoc
abstract mixin class _$UserProfileEntityCopyWith<$Res> implements $UserProfileEntityCopyWith<$Res> {
  factory _$UserProfileEntityCopyWith(_UserProfileEntity value, $Res Function(_UserProfileEntity) _then) = __$UserProfileEntityCopyWithImpl;
@override @useResult
$Res call({
 String email, String? fullName, String? phone, String role, int point, bool isBlocked, DateTime? createdAt, String? avatarUrl, List<KycDocumentEntity> documents
});




}
/// @nodoc
class __$UserProfileEntityCopyWithImpl<$Res>
    implements _$UserProfileEntityCopyWith<$Res> {
  __$UserProfileEntityCopyWithImpl(this._self, this._then);

  final _UserProfileEntity _self;
  final $Res Function(_UserProfileEntity) _then;

/// Create a copy of UserProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? fullName = freezed,Object? phone = freezed,Object? role = null,Object? point = null,Object? isBlocked = null,Object? createdAt = freezed,Object? avatarUrl = freezed,Object? documents = null,}) {
  return _then(_UserProfileEntity(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as int,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<KycDocumentEntity>,
  ));
}


}

// dart format on
