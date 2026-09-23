// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kyc_document_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KycDocumentEntity {

 int get id; String get imgUrl; DocumentType get type; String get number; String? get email; String? get licenseClass; DateTime? get expiryDate; KycStatus get status; String? get rejectReason;
/// Create a copy of KycDocumentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KycDocumentEntityCopyWith<KycDocumentEntity> get copyWith => _$KycDocumentEntityCopyWithImpl<KycDocumentEntity>(this as KycDocumentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KycDocumentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.number, number) || other.number == number)&&(identical(other.email, email) || other.email == email)&&(identical(other.licenseClass, licenseClass) || other.licenseClass == licenseClass)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,imgUrl,type,number,email,licenseClass,expiryDate,status,rejectReason);

@override
String toString() {
  return 'KycDocumentEntity(id: $id, imgUrl: $imgUrl, type: $type, number: $number, email: $email, licenseClass: $licenseClass, expiryDate: $expiryDate, status: $status, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class $KycDocumentEntityCopyWith<$Res>  {
  factory $KycDocumentEntityCopyWith(KycDocumentEntity value, $Res Function(KycDocumentEntity) _then) = _$KycDocumentEntityCopyWithImpl;
@useResult
$Res call({
 int id, String imgUrl, DocumentType type, String number, String? email, String? licenseClass, DateTime? expiryDate, KycStatus status, String? rejectReason
});




}
/// @nodoc
class _$KycDocumentEntityCopyWithImpl<$Res>
    implements $KycDocumentEntityCopyWith<$Res> {
  _$KycDocumentEntityCopyWithImpl(this._self, this._then);

  final KycDocumentEntity _self;
  final $Res Function(KycDocumentEntity) _then;

/// Create a copy of KycDocumentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imgUrl = null,Object? type = null,Object? number = null,Object? email = freezed,Object? licenseClass = freezed,Object? expiryDate = freezed,Object? status = null,Object? rejectReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imgUrl: null == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,licenseClass: freezed == licenseClass ? _self.licenseClass : licenseClass // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KycStatus,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KycDocumentEntity].
extension KycDocumentEntityPatterns on KycDocumentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KycDocumentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KycDocumentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KycDocumentEntity value)  $default,){
final _that = this;
switch (_that) {
case _KycDocumentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KycDocumentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _KycDocumentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String imgUrl,  DocumentType type,  String number,  String? email,  String? licenseClass,  DateTime? expiryDate,  KycStatus status,  String? rejectReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KycDocumentEntity() when $default != null:
return $default(_that.id,_that.imgUrl,_that.type,_that.number,_that.email,_that.licenseClass,_that.expiryDate,_that.status,_that.rejectReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String imgUrl,  DocumentType type,  String number,  String? email,  String? licenseClass,  DateTime? expiryDate,  KycStatus status,  String? rejectReason)  $default,) {final _that = this;
switch (_that) {
case _KycDocumentEntity():
return $default(_that.id,_that.imgUrl,_that.type,_that.number,_that.email,_that.licenseClass,_that.expiryDate,_that.status,_that.rejectReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String imgUrl,  DocumentType type,  String number,  String? email,  String? licenseClass,  DateTime? expiryDate,  KycStatus status,  String? rejectReason)?  $default,) {final _that = this;
switch (_that) {
case _KycDocumentEntity() when $default != null:
return $default(_that.id,_that.imgUrl,_that.type,_that.number,_that.email,_that.licenseClass,_that.expiryDate,_that.status,_that.rejectReason);case _:
  return null;

}
}

}

/// @nodoc


class _KycDocumentEntity implements KycDocumentEntity {
  const _KycDocumentEntity({required this.id, required this.imgUrl, required this.type, required this.number, this.email, this.licenseClass, this.expiryDate, this.status = KycStatus.none, this.rejectReason});
  

@override final  int id;
@override final  String imgUrl;
@override final  DocumentType type;
@override final  String number;
@override final  String? email;
@override final  String? licenseClass;
@override final  DateTime? expiryDate;
@override@JsonKey() final  KycStatus status;
@override final  String? rejectReason;

/// Create a copy of KycDocumentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KycDocumentEntityCopyWith<_KycDocumentEntity> get copyWith => __$KycDocumentEntityCopyWithImpl<_KycDocumentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KycDocumentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.number, number) || other.number == number)&&(identical(other.email, email) || other.email == email)&&(identical(other.licenseClass, licenseClass) || other.licenseClass == licenseClass)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,imgUrl,type,number,email,licenseClass,expiryDate,status,rejectReason);

@override
String toString() {
  return 'KycDocumentEntity(id: $id, imgUrl: $imgUrl, type: $type, number: $number, email: $email, licenseClass: $licenseClass, expiryDate: $expiryDate, status: $status, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class _$KycDocumentEntityCopyWith<$Res> implements $KycDocumentEntityCopyWith<$Res> {
  factory _$KycDocumentEntityCopyWith(_KycDocumentEntity value, $Res Function(_KycDocumentEntity) _then) = __$KycDocumentEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String imgUrl, DocumentType type, String number, String? email, String? licenseClass, DateTime? expiryDate, KycStatus status, String? rejectReason
});




}
/// @nodoc
class __$KycDocumentEntityCopyWithImpl<$Res>
    implements _$KycDocumentEntityCopyWith<$Res> {
  __$KycDocumentEntityCopyWithImpl(this._self, this._then);

  final _KycDocumentEntity _self;
  final $Res Function(_KycDocumentEntity) _then;

/// Create a copy of KycDocumentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imgUrl = null,Object? type = null,Object? number = null,Object? email = freezed,Object? licenseClass = freezed,Object? expiryDate = freezed,Object? status = null,Object? rejectReason = freezed,}) {
  return _then(_KycDocumentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imgUrl: null == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,licenseClass: freezed == licenseClass ? _self.licenseClass : licenseClass // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KycStatus,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
