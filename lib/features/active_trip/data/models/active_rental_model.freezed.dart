// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_rental_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveRentalModel {

 int get id; String get status; DateTime get startTime; DateTime get endTime; double get rentFee; int get discountPoint; int get vehicleId; String get vehicleName; String get vehicleBrand; String get vehiclePlate; String get vehicleImageUrl; int get batteryLevel; double? get batteryCapacity; String? get stationName; String? get stationAddress; double? get stationLat; double? get stationLng; String? get contractStatus; String? get contractUrl; double? get rentalDeposit; String? get userEmail;
/// Create a copy of ActiveRentalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveRentalModelCopyWith<ActiveRentalModel> get copyWith => _$ActiveRentalModelCopyWithImpl<ActiveRentalModel>(this as ActiveRentalModel, _$identity);

  /// Serializes this ActiveRentalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveRentalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.rentFee, rentFee) || other.rentFee == rentFee)&&(identical(other.discountPoint, discountPoint) || other.discountPoint == discountPoint)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleBrand, vehicleBrand) || other.vehicleBrand == vehicleBrand)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.vehicleImageUrl, vehicleImageUrl) || other.vehicleImageUrl == vehicleImageUrl)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddress, stationAddress) || other.stationAddress == stationAddress)&&(identical(other.stationLat, stationLat) || other.stationLat == stationLat)&&(identical(other.stationLng, stationLng) || other.stationLng == stationLng)&&(identical(other.contractStatus, contractStatus) || other.contractStatus == contractStatus)&&(identical(other.contractUrl, contractUrl) || other.contractUrl == contractUrl)&&(identical(other.rentalDeposit, rentalDeposit) || other.rentalDeposit == rentalDeposit)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,status,startTime,endTime,rentFee,discountPoint,vehicleId,vehicleName,vehicleBrand,vehiclePlate,vehicleImageUrl,batteryLevel,batteryCapacity,stationName,stationAddress,stationLat,stationLng,contractStatus,contractUrl,rentalDeposit,userEmail]);

@override
String toString() {
  return 'ActiveRentalModel(id: $id, status: $status, startTime: $startTime, endTime: $endTime, rentFee: $rentFee, discountPoint: $discountPoint, vehicleId: $vehicleId, vehicleName: $vehicleName, vehicleBrand: $vehicleBrand, vehiclePlate: $vehiclePlate, vehicleImageUrl: $vehicleImageUrl, batteryLevel: $batteryLevel, batteryCapacity: $batteryCapacity, stationName: $stationName, stationAddress: $stationAddress, stationLat: $stationLat, stationLng: $stationLng, contractStatus: $contractStatus, contractUrl: $contractUrl, rentalDeposit: $rentalDeposit, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class $ActiveRentalModelCopyWith<$Res>  {
  factory $ActiveRentalModelCopyWith(ActiveRentalModel value, $Res Function(ActiveRentalModel) _then) = _$ActiveRentalModelCopyWithImpl;
@useResult
$Res call({
 int id, String status, DateTime startTime, DateTime endTime, double rentFee, int discountPoint, int vehicleId, String vehicleName, String vehicleBrand, String vehiclePlate, String vehicleImageUrl, int batteryLevel, double? batteryCapacity, String? stationName, String? stationAddress, double? stationLat, double? stationLng, String? contractStatus, String? contractUrl, double? rentalDeposit, String? userEmail
});




}
/// @nodoc
class _$ActiveRentalModelCopyWithImpl<$Res>
    implements $ActiveRentalModelCopyWith<$Res> {
  _$ActiveRentalModelCopyWithImpl(this._self, this._then);

  final ActiveRentalModel _self;
  final $Res Function(ActiveRentalModel) _then;

/// Create a copy of ActiveRentalModel
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


/// Adds pattern-matching-related methods to [ActiveRentalModel].
extension ActiveRentalModelPatterns on ActiveRentalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveRentalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveRentalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveRentalModel value)  $default,){
final _that = this;
switch (_that) {
case _ActiveRentalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveRentalModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveRentalModel() when $default != null:
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
case _ActiveRentalModel() when $default != null:
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
case _ActiveRentalModel():
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
case _ActiveRentalModel() when $default != null:
return $default(_that.id,_that.status,_that.startTime,_that.endTime,_that.rentFee,_that.discountPoint,_that.vehicleId,_that.vehicleName,_that.vehicleBrand,_that.vehiclePlate,_that.vehicleImageUrl,_that.batteryLevel,_that.batteryCapacity,_that.stationName,_that.stationAddress,_that.stationLat,_that.stationLng,_that.contractStatus,_that.contractUrl,_that.rentalDeposit,_that.userEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveRentalModel extends ActiveRentalModel {
  const _ActiveRentalModel({required this.id, this.status = 'PENDING', required this.startTime, required this.endTime, this.rentFee = 0.0, this.discountPoint = 0, this.vehicleId = 0, this.vehicleName = 'Xe điện E-Motion', this.vehicleBrand = 'E-MOTION', this.vehiclePlate = '', this.vehicleImageUrl = '', this.batteryLevel = 0, this.batteryCapacity, this.stationName, this.stationAddress, this.stationLat, this.stationLng, this.contractStatus, this.contractUrl, this.rentalDeposit, this.userEmail}): super._();
  factory _ActiveRentalModel.fromJson(Map<String, dynamic> json) => _$ActiveRentalModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String status;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override@JsonKey() final  double rentFee;
@override@JsonKey() final  int discountPoint;
@override@JsonKey() final  int vehicleId;
@override@JsonKey() final  String vehicleName;
@override@JsonKey() final  String vehicleBrand;
@override@JsonKey() final  String vehiclePlate;
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

/// Create a copy of ActiveRentalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveRentalModelCopyWith<_ActiveRentalModel> get copyWith => __$ActiveRentalModelCopyWithImpl<_ActiveRentalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveRentalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveRentalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.rentFee, rentFee) || other.rentFee == rentFee)&&(identical(other.discountPoint, discountPoint) || other.discountPoint == discountPoint)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleBrand, vehicleBrand) || other.vehicleBrand == vehicleBrand)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.vehicleImageUrl, vehicleImageUrl) || other.vehicleImageUrl == vehicleImageUrl)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddress, stationAddress) || other.stationAddress == stationAddress)&&(identical(other.stationLat, stationLat) || other.stationLat == stationLat)&&(identical(other.stationLng, stationLng) || other.stationLng == stationLng)&&(identical(other.contractStatus, contractStatus) || other.contractStatus == contractStatus)&&(identical(other.contractUrl, contractUrl) || other.contractUrl == contractUrl)&&(identical(other.rentalDeposit, rentalDeposit) || other.rentalDeposit == rentalDeposit)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,status,startTime,endTime,rentFee,discountPoint,vehicleId,vehicleName,vehicleBrand,vehiclePlate,vehicleImageUrl,batteryLevel,batteryCapacity,stationName,stationAddress,stationLat,stationLng,contractStatus,contractUrl,rentalDeposit,userEmail]);

@override
String toString() {
  return 'ActiveRentalModel(id: $id, status: $status, startTime: $startTime, endTime: $endTime, rentFee: $rentFee, discountPoint: $discountPoint, vehicleId: $vehicleId, vehicleName: $vehicleName, vehicleBrand: $vehicleBrand, vehiclePlate: $vehiclePlate, vehicleImageUrl: $vehicleImageUrl, batteryLevel: $batteryLevel, batteryCapacity: $batteryCapacity, stationName: $stationName, stationAddress: $stationAddress, stationLat: $stationLat, stationLng: $stationLng, contractStatus: $contractStatus, contractUrl: $contractUrl, rentalDeposit: $rentalDeposit, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class _$ActiveRentalModelCopyWith<$Res> implements $ActiveRentalModelCopyWith<$Res> {
  factory _$ActiveRentalModelCopyWith(_ActiveRentalModel value, $Res Function(_ActiveRentalModel) _then) = __$ActiveRentalModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String status, DateTime startTime, DateTime endTime, double rentFee, int discountPoint, int vehicleId, String vehicleName, String vehicleBrand, String vehiclePlate, String vehicleImageUrl, int batteryLevel, double? batteryCapacity, String? stationName, String? stationAddress, double? stationLat, double? stationLng, String? contractStatus, String? contractUrl, double? rentalDeposit, String? userEmail
});




}
/// @nodoc
class __$ActiveRentalModelCopyWithImpl<$Res>
    implements _$ActiveRentalModelCopyWith<$Res> {
  __$ActiveRentalModelCopyWithImpl(this._self, this._then);

  final _ActiveRentalModel _self;
  final $Res Function(_ActiveRentalModel) _then;

/// Create a copy of ActiveRentalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? startTime = null,Object? endTime = null,Object? rentFee = null,Object? discountPoint = null,Object? vehicleId = null,Object? vehicleName = null,Object? vehicleBrand = null,Object? vehiclePlate = null,Object? vehicleImageUrl = null,Object? batteryLevel = null,Object? batteryCapacity = freezed,Object? stationName = freezed,Object? stationAddress = freezed,Object? stationLat = freezed,Object? stationLng = freezed,Object? contractStatus = freezed,Object? contractUrl = freezed,Object? rentalDeposit = freezed,Object? userEmail = freezed,}) {
  return _then(_ActiveRentalModel(
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
