// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_rental_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveRentalEntity {

 int get id; String get status; DateTime get startTime; DateTime get endTime; double get rentFee; int get discountPoint; int get vehicleId; String get vehicleName; String get vehicleBrand; String get vehiclePlate; String get vehicleImageUrl; int get batteryLevel; double? get batteryCapacity; String? get stationName; String? get stationAddress; double? get stationLat; double? get stationLng; String? get contractStatus; String? get contractUrl; double? get rentalDeposit; String? get userEmail;
/// Create a copy of ActiveRentalEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveRentalEntityCopyWith<ActiveRentalEntity> get copyWith => _$ActiveRentalEntityCopyWithImpl<ActiveRentalEntity>(this as ActiveRentalEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveRentalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.rentFee, rentFee) || other.rentFee == rentFee)&&(identical(other.discountPoint, discountPoint) || other.discountPoint == discountPoint)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleBrand, vehicleBrand) || other.vehicleBrand == vehicleBrand)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.vehicleImageUrl, vehicleImageUrl) || other.vehicleImageUrl == vehicleImageUrl)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddress, stationAddress) || other.stationAddress == stationAddress)&&(identical(other.stationLat, stationLat) || other.stationLat == stationLat)&&(identical(other.stationLng, stationLng) || other.stationLng == stationLng)&&(identical(other.contractStatus, contractStatus) || other.contractStatus == contractStatus)&&(identical(other.contractUrl, contractUrl) || other.contractUrl == contractUrl)&&(identical(other.rentalDeposit, rentalDeposit) || other.rentalDeposit == rentalDeposit)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,status,startTime,endTime,rentFee,discountPoint,vehicleId,vehicleName,vehicleBrand,vehiclePlate,vehicleImageUrl,batteryLevel,batteryCapacity,stationName,stationAddress,stationLat,stationLng,contractStatus,contractUrl,rentalDeposit,userEmail]);

@override
String toString() {
  return 'ActiveRentalEntity(id: $id, status: $status, startTime: $startTime, endTime: $endTime, rentFee: $rentFee, discountPoint: $discountPoint, vehicleId: $vehicleId, vehicleName: $vehicleName, vehicleBrand: $vehicleBrand, vehiclePlate: $vehiclePlate, vehicleImageUrl: $vehicleImageUrl, batteryLevel: $batteryLevel, batteryCapacity: $batteryCapacity, stationName: $stationName, stationAddress: $stationAddress, stationLat: $stationLat, stationLng: $stationLng, contractStatus: $contractStatus, contractUrl: $contractUrl, rentalDeposit: $rentalDeposit, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class $ActiveRentalEntityCopyWith<$Res>  {
  factory $ActiveRentalEntityCopyWith(ActiveRentalEntity value, $Res Function(ActiveRentalEntity) _then) = _$ActiveRentalEntityCopyWithImpl;
@useResult
$Res call({
 int id, String status, DateTime startTime, DateTime endTime, double rentFee, int discountPoint, int vehicleId, String vehicleName, String vehicleBrand, String vehiclePlate, String vehicleImageUrl, int batteryLevel, double? batteryCapacity, String? stationName, String? stationAddress, double? stationLat, double? stationLng, String? contractStatus, String? contractUrl, double? rentalDeposit, String? userEmail
});




}
/// @nodoc
class _$ActiveRentalEntityCopyWithImpl<$Res>
    implements $ActiveRentalEntityCopyWith<$Res> {
  _$ActiveRentalEntityCopyWithImpl(this._self, this._then);

  final ActiveRentalEntity _self;
  final $Res Function(ActiveRentalEntity) _then;

/// Create a copy of ActiveRentalEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? startTime = null,Object? endTime = null,Object? rentFee = null,Object? discountPoint = null,Object? vehicleId = null,Object? vehicleName = null,Object? vehicleBrand = null,Object? vehiclePlate = null,Object? vehicleImageUrl = null,Object? batteryLevel = null,Object? batteryCapacity = freezed,Object? stationName = freezed,Object? stationAddress = freezed,Object? stationLat = freezed,Object? stationLng = freezed,Object? contractStatus = freezed,Object? contractUrl = freezed,Object? rentalDeposit = freezed,Object? userEmail = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,rentFee: null == rentFee ? _self.rentFee : rentFee // ignore: cast_nullable_to_non_nullable
as double,discountPoint: null == discountPoint ? _self.discountPoint : discountPoint // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,vehicleBrand: null == vehicleBrand ? _self.vehicleBrand : vehicleBrand // ignore: cast_nullable_to_non_nullable
as String,vehiclePlate: null == vehiclePlate ? _self.vehiclePlate : vehiclePlate // ignore: cast_nullable_to_non_nullable
as String,vehicleImageUrl: null == vehicleImageUrl ? _self.vehicleImageUrl : vehicleImageUrl // ignore: cast_nullable_to_non_nullable
as String,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,batteryCapacity: freezed == batteryCapacity ? _self.batteryCapacity : batteryCapacity // ignore: cast_nullable_to_non_nullable
as double?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationAddress: freezed == stationAddress ? _self.stationAddress : stationAddress // ignore: cast_nullable_to_non_nullable
as String?,stationLat: freezed == stationLat ? _self.stationLat : stationLat // ignore: cast_nullable_to_non_nullable
as double?,stationLng: freezed == stationLng ? _self.stationLng : stationLng // ignore: cast_nullable_to_non_nullable
as double?,contractStatus: freezed == contractStatus ? _self.contractStatus : contractStatus // ignore: cast_nullable_to_non_nullable
as String?,contractUrl: freezed == contractUrl ? _self.contractUrl : contractUrl // ignore: cast_nullable_to_non_nullable
as String?,rentalDeposit: freezed == rentalDeposit ? _self.rentalDeposit : rentalDeposit // ignore: cast_nullable_to_non_nullable
as double?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveRentalEntity].
extension ActiveRentalEntityPatterns on ActiveRentalEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveRentalEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveRentalEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveRentalEntity value)  $default,){
final _that = this;
switch (_that) {
case _ActiveRentalEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveRentalEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveRentalEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String status,  DateTime startTime,  DateTime endTime,  double rentFee,  int discountPoint,  int vehicleId,  String vehicleName,  String vehicleBrand,  String vehiclePlate,  String vehicleImageUrl,  int batteryLevel,  double? batteryCapacity,  String? stationName,  String? stationAddress,  double? stationLat,  double? stationLng,  String? contractStatus,  String? contractUrl,  double? rentalDeposit,  String? userEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveRentalEntity() when $default != null:
return $default(_that.id,_that.status,_that.startTime,_that.endTime,_that.rentFee,_that.discountPoint,_that.vehicleId,_that.vehicleName,_that.vehicleBrand,_that.vehiclePlate,_that.vehicleImageUrl,_that.batteryLevel,_that.batteryCapacity,_that.stationName,_that.stationAddress,_that.stationLat,_that.stationLng,_that.contractStatus,_that.contractUrl,_that.rentalDeposit,_that.userEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String status,  DateTime startTime,  DateTime endTime,  double rentFee,  int discountPoint,  int vehicleId,  String vehicleName,  String vehicleBrand,  String vehiclePlate,  String vehicleImageUrl,  int batteryLevel,  double? batteryCapacity,  String? stationName,  String? stationAddress,  double? stationLat,  double? stationLng,  String? contractStatus,  String? contractUrl,  double? rentalDeposit,  String? userEmail)  $default,) {final _that = this;
switch (_that) {
case _ActiveRentalEntity():
return $default(_that.id,_that.status,_that.startTime,_that.endTime,_that.rentFee,_that.discountPoint,_that.vehicleId,_that.vehicleName,_that.vehicleBrand,_that.vehiclePlate,_that.vehicleImageUrl,_that.batteryLevel,_that.batteryCapacity,_that.stationName,_that.stationAddress,_that.stationLat,_that.stationLng,_that.contractStatus,_that.contractUrl,_that.rentalDeposit,_that.userEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String status,  DateTime startTime,  DateTime endTime,  double rentFee,  int discountPoint,  int vehicleId,  String vehicleName,  String vehicleBrand,  String vehiclePlate,  String vehicleImageUrl,  int batteryLevel,  double? batteryCapacity,  String? stationName,  String? stationAddress,  double? stationLat,  double? stationLng,  String? contractStatus,  String? contractUrl,  double? rentalDeposit,  String? userEmail)?  $default,) {final _that = this;
switch (_that) {
case _ActiveRentalEntity() when $default != null:
return $default(_that.id,_that.status,_that.startTime,_that.endTime,_that.rentFee,_that.discountPoint,_that.vehicleId,_that.vehicleName,_that.vehicleBrand,_that.vehiclePlate,_that.vehicleImageUrl,_that.batteryLevel,_that.batteryCapacity,_that.stationName,_that.stationAddress,_that.stationLat,_that.stationLng,_that.contractStatus,_that.contractUrl,_that.rentalDeposit,_that.userEmail);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveRentalEntity extends ActiveRentalEntity {
  const _ActiveRentalEntity({required this.id, required this.status, required this.startTime, required this.endTime, required this.rentFee, this.discountPoint = 0, required this.vehicleId, required this.vehicleName, required this.vehicleBrand, required this.vehiclePlate, this.vehicleImageUrl = '', this.batteryLevel = 0, this.batteryCapacity, this.stationName, this.stationAddress, this.stationLat, this.stationLng, this.contractStatus, this.contractUrl, this.rentalDeposit, this.userEmail}): super._();
  

@override final  int id;
@override final  String status;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  double rentFee;
@override@JsonKey() final  int discountPoint;
@override final  int vehicleId;
@override final  String vehicleName;
@override final  String vehicleBrand;
@override final  String vehiclePlate;
@override@JsonKey() final  String vehicleImageUrl;
@override@JsonKey() final  int batteryLevel;
@override final  double? batteryCapacity;
@override final  String? stationName;
@override final  String? stationAddress;
@override final  double? stationLat;
@override final  double? stationLng;
@override final  String? contractStatus;
@override final  String? contractUrl;
@override final  double? rentalDeposit;
@override final  String? userEmail;

/// Create a copy of ActiveRentalEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveRentalEntityCopyWith<_ActiveRentalEntity> get copyWith => __$ActiveRentalEntityCopyWithImpl<_ActiveRentalEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveRentalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.rentFee, rentFee) || other.rentFee == rentFee)&&(identical(other.discountPoint, discountPoint) || other.discountPoint == discountPoint)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleBrand, vehicleBrand) || other.vehicleBrand == vehicleBrand)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.vehicleImageUrl, vehicleImageUrl) || other.vehicleImageUrl == vehicleImageUrl)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddress, stationAddress) || other.stationAddress == stationAddress)&&(identical(other.stationLat, stationLat) || other.stationLat == stationLat)&&(identical(other.stationLng, stationLng) || other.stationLng == stationLng)&&(identical(other.contractStatus, contractStatus) || other.contractStatus == contractStatus)&&(identical(other.contractUrl, contractUrl) || other.contractUrl == contractUrl)&&(identical(other.rentalDeposit, rentalDeposit) || other.rentalDeposit == rentalDeposit)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,status,startTime,endTime,rentFee,discountPoint,vehicleId,vehicleName,vehicleBrand,vehiclePlate,vehicleImageUrl,batteryLevel,batteryCapacity,stationName,stationAddress,stationLat,stationLng,contractStatus,contractUrl,rentalDeposit,userEmail]);

@override
String toString() {
  return 'ActiveRentalEntity(id: $id, status: $status, startTime: $startTime, endTime: $endTime, rentFee: $rentFee, discountPoint: $discountPoint, vehicleId: $vehicleId, vehicleName: $vehicleName, vehicleBrand: $vehicleBrand, vehiclePlate: $vehiclePlate, vehicleImageUrl: $vehicleImageUrl, batteryLevel: $batteryLevel, batteryCapacity: $batteryCapacity, stationName: $stationName, stationAddress: $stationAddress, stationLat: $stationLat, stationLng: $stationLng, contractStatus: $contractStatus, contractUrl: $contractUrl, rentalDeposit: $rentalDeposit, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class _$ActiveRentalEntityCopyWith<$Res> implements $ActiveRentalEntityCopyWith<$Res> {
  factory _$ActiveRentalEntityCopyWith(_ActiveRentalEntity value, $Res Function(_ActiveRentalEntity) _then) = __$ActiveRentalEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String status, DateTime startTime, DateTime endTime, double rentFee, int discountPoint, int vehicleId, String vehicleName, String vehicleBrand, String vehiclePlate, String vehicleImageUrl, int batteryLevel, double? batteryCapacity, String? stationName, String? stationAddress, double? stationLat, double? stationLng, String? contractStatus, String? contractUrl, double? rentalDeposit, String? userEmail
});




}
/// @nodoc
class __$ActiveRentalEntityCopyWithImpl<$Res>
    implements _$ActiveRentalEntityCopyWith<$Res> {
  __$ActiveRentalEntityCopyWithImpl(this._self, this._then);

  final _ActiveRentalEntity _self;
  final $Res Function(_ActiveRentalEntity) _then;

/// Create a copy of ActiveRentalEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? startTime = null,Object? endTime = null,Object? rentFee = null,Object? discountPoint = null,Object? vehicleId = null,Object? vehicleName = null,Object? vehicleBrand = null,Object? vehiclePlate = null,Object? vehicleImageUrl = null,Object? batteryLevel = null,Object? batteryCapacity = freezed,Object? stationName = freezed,Object? stationAddress = freezed,Object? stationLat = freezed,Object? stationLng = freezed,Object? contractStatus = freezed,Object? contractUrl = freezed,Object? rentalDeposit = freezed,Object? userEmail = freezed,}) {
  return _then(_ActiveRentalEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,rentFee: null == rentFee ? _self.rentFee : rentFee // ignore: cast_nullable_to_non_nullable
as double,discountPoint: null == discountPoint ? _self.discountPoint : discountPoint // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,vehicleBrand: null == vehicleBrand ? _self.vehicleBrand : vehicleBrand // ignore: cast_nullable_to_non_nullable
as String,vehiclePlate: null == vehiclePlate ? _self.vehiclePlate : vehiclePlate // ignore: cast_nullable_to_non_nullable
as String,vehicleImageUrl: null == vehicleImageUrl ? _self.vehicleImageUrl : vehicleImageUrl // ignore: cast_nullable_to_non_nullable
as String,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,batteryCapacity: freezed == batteryCapacity ? _self.batteryCapacity : batteryCapacity // ignore: cast_nullable_to_non_nullable
as double?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationAddress: freezed == stationAddress ? _self.stationAddress : stationAddress // ignore: cast_nullable_to_non_nullable
as String?,stationLat: freezed == stationLat ? _self.stationLat : stationLat // ignore: cast_nullable_to_non_nullable
as double?,stationLng: freezed == stationLng ? _self.stationLng : stationLng // ignore: cast_nullable_to_non_nullable
as double?,contractStatus: freezed == contractStatus ? _self.contractStatus : contractStatus // ignore: cast_nullable_to_non_nullable
as String?,contractUrl: freezed == contractUrl ? _self.contractUrl : contractUrl // ignore: cast_nullable_to_non_nullable
as String?,rentalDeposit: freezed == rentalDeposit ? _self.rentalDeposit : rentalDeposit // ignore: cast_nullable_to_non_nullable
as double?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
