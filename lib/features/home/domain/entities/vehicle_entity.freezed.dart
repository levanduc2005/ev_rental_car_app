// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleEntity {

 int get id; String get name; String get status; String? get category; String get brand; String? get plateNumber; int get seats; double get pricePer4Hours; double get pricePer8Hours; double get pricePer12Hours; double get pricePerDay; double get priceRate; double get hourRate; double? get consumptionRate; double? get batteryCapacity; int get batteryLevel; StationEntity? get station; String? get mainImage; int get point;
/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleEntityCopyWith<VehicleEntity> get copyWith => _$VehicleEntityCopyWithImpl<VehicleEntity>(this as VehicleEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.pricePer4Hours, pricePer4Hours) || other.pricePer4Hours == pricePer4Hours)&&(identical(other.pricePer8Hours, pricePer8Hours) || other.pricePer8Hours == pricePer8Hours)&&(identical(other.pricePer12Hours, pricePer12Hours) || other.pricePer12Hours == pricePer12Hours)&&(identical(other.pricePerDay, pricePerDay) || other.pricePerDay == pricePerDay)&&(identical(other.priceRate, priceRate) || other.priceRate == priceRate)&&(identical(other.hourRate, hourRate) || other.hourRate == hourRate)&&(identical(other.consumptionRate, consumptionRate) || other.consumptionRate == consumptionRate)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.station, station) || other.station == station)&&(identical(other.mainImage, mainImage) || other.mainImage == mainImage)&&(identical(other.point, point) || other.point == point));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,status,category,brand,plateNumber,seats,pricePer4Hours,pricePer8Hours,pricePer12Hours,pricePerDay,priceRate,hourRate,consumptionRate,batteryCapacity,batteryLevel,station,mainImage,point]);

@override
String toString() {
  return 'VehicleEntity(id: $id, name: $name, status: $status, category: $category, brand: $brand, plateNumber: $plateNumber, seats: $seats, pricePer4Hours: $pricePer4Hours, pricePer8Hours: $pricePer8Hours, pricePer12Hours: $pricePer12Hours, pricePerDay: $pricePerDay, priceRate: $priceRate, hourRate: $hourRate, consumptionRate: $consumptionRate, batteryCapacity: $batteryCapacity, batteryLevel: $batteryLevel, station: $station, mainImage: $mainImage, point: $point)';
}


}

/// @nodoc
abstract mixin class $VehicleEntityCopyWith<$Res>  {
  factory $VehicleEntityCopyWith(VehicleEntity value, $Res Function(VehicleEntity) _then) = _$VehicleEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String status, String? category, String brand, String? plateNumber, int seats, double pricePer4Hours, double pricePer8Hours, double pricePer12Hours, double pricePerDay, double priceRate, double hourRate, double? consumptionRate, double? batteryCapacity, int batteryLevel, StationEntity? station, String? mainImage, int point
});


$StationEntityCopyWith<$Res>? get station;

}
/// @nodoc
class _$VehicleEntityCopyWithImpl<$Res>
    implements $VehicleEntityCopyWith<$Res> {
  _$VehicleEntityCopyWithImpl(this._self, this._then);

  final VehicleEntity _self;
  final $Res Function(VehicleEntity) _then;

/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? category = freezed,Object? brand = null,Object? plateNumber = freezed,Object? seats = null,Object? pricePer4Hours = null,Object? pricePer8Hours = null,Object? pricePer12Hours = null,Object? pricePerDay = null,Object? priceRate = null,Object? hourRate = null,Object? consumptionRate = freezed,Object? batteryCapacity = freezed,Object? batteryLevel = null,Object? station = freezed,Object? mainImage = freezed,Object? point = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,pricePer4Hours: null == pricePer4Hours ? _self.pricePer4Hours : pricePer4Hours // ignore: cast_nullable_to_non_nullable
as double,pricePer8Hours: null == pricePer8Hours ? _self.pricePer8Hours : pricePer8Hours // ignore: cast_nullable_to_non_nullable
as double,pricePer12Hours: null == pricePer12Hours ? _self.pricePer12Hours : pricePer12Hours // ignore: cast_nullable_to_non_nullable
as double,pricePerDay: null == pricePerDay ? _self.pricePerDay : pricePerDay // ignore: cast_nullable_to_non_nullable
as double,priceRate: null == priceRate ? _self.priceRate : priceRate // ignore: cast_nullable_to_non_nullable
as double,hourRate: null == hourRate ? _self.hourRate : hourRate // ignore: cast_nullable_to_non_nullable
as double,consumptionRate: freezed == consumptionRate ? _self.consumptionRate : consumptionRate // ignore: cast_nullable_to_non_nullable
as double?,batteryCapacity: freezed == batteryCapacity ? _self.batteryCapacity : batteryCapacity // ignore: cast_nullable_to_non_nullable
as double?,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as StationEntity?,mainImage: freezed == mainImage ? _self.mainImage : mainImage // ignore: cast_nullable_to_non_nullable
as String?,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationEntityCopyWith<$Res>? get station {
    if (_self.station == null) {
    return null;
  }

  return $StationEntityCopyWith<$Res>(_self.station!, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}


/// Adds pattern-matching-related methods to [VehicleEntity].
extension VehicleEntityPatterns on VehicleEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleEntity value)  $default,){
final _that = this;
switch (_that) {
case _VehicleEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String status,  String? category,  String brand,  String? plateNumber,  int seats,  double pricePer4Hours,  double pricePer8Hours,  double pricePer12Hours,  double pricePerDay,  double priceRate,  double hourRate,  double? consumptionRate,  double? batteryCapacity,  int batteryLevel,  StationEntity? station,  String? mainImage,  int point)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleEntity() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.category,_that.brand,_that.plateNumber,_that.seats,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.priceRate,_that.hourRate,_that.consumptionRate,_that.batteryCapacity,_that.batteryLevel,_that.station,_that.mainImage,_that.point);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String status,  String? category,  String brand,  String? plateNumber,  int seats,  double pricePer4Hours,  double pricePer8Hours,  double pricePer12Hours,  double pricePerDay,  double priceRate,  double hourRate,  double? consumptionRate,  double? batteryCapacity,  int batteryLevel,  StationEntity? station,  String? mainImage,  int point)  $default,) {final _that = this;
switch (_that) {
case _VehicleEntity():
return $default(_that.id,_that.name,_that.status,_that.category,_that.brand,_that.plateNumber,_that.seats,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.priceRate,_that.hourRate,_that.consumptionRate,_that.batteryCapacity,_that.batteryLevel,_that.station,_that.mainImage,_that.point);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String status,  String? category,  String brand,  String? plateNumber,  int seats,  double pricePer4Hours,  double pricePer8Hours,  double pricePer12Hours,  double pricePerDay,  double priceRate,  double hourRate,  double? consumptionRate,  double? batteryCapacity,  int batteryLevel,  StationEntity? station,  String? mainImage,  int point)?  $default,) {final _that = this;
switch (_that) {
case _VehicleEntity() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.category,_that.brand,_that.plateNumber,_that.seats,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.priceRate,_that.hourRate,_that.consumptionRate,_that.batteryCapacity,_that.batteryLevel,_that.station,_that.mainImage,_that.point);case _:
  return null;

}
}

}

/// @nodoc


class _VehicleEntity extends VehicleEntity {
  const _VehicleEntity({required this.id, required this.name, this.status = 'AVAILABLE', this.category, required this.brand, this.plateNumber, this.seats = 4, this.pricePer4Hours = 0.0, this.pricePer8Hours = 0.0, this.pricePer12Hours = 0.0, this.pricePerDay = 0.0, this.priceRate = 0.0, this.hourRate = 0.0, this.consumptionRate, this.batteryCapacity, this.batteryLevel = 0, this.station, this.mainImage, this.point = 5}): super._();
  

@override final  int id;
@override final  String name;
@override@JsonKey() final  String status;
@override final  String? category;
@override final  String brand;
@override final  String? plateNumber;
@override@JsonKey() final  int seats;
@override@JsonKey() final  double pricePer4Hours;
@override@JsonKey() final  double pricePer8Hours;
@override@JsonKey() final  double pricePer12Hours;
@override@JsonKey() final  double pricePerDay;
@override@JsonKey() final  double priceRate;
@override@JsonKey() final  double hourRate;
@override final  double? consumptionRate;
@override final  double? batteryCapacity;
@override@JsonKey() final  int batteryLevel;
@override final  StationEntity? station;
@override final  String? mainImage;
@override@JsonKey() final  int point;

/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleEntityCopyWith<_VehicleEntity> get copyWith => __$VehicleEntityCopyWithImpl<_VehicleEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.pricePer4Hours, pricePer4Hours) || other.pricePer4Hours == pricePer4Hours)&&(identical(other.pricePer8Hours, pricePer8Hours) || other.pricePer8Hours == pricePer8Hours)&&(identical(other.pricePer12Hours, pricePer12Hours) || other.pricePer12Hours == pricePer12Hours)&&(identical(other.pricePerDay, pricePerDay) || other.pricePerDay == pricePerDay)&&(identical(other.priceRate, priceRate) || other.priceRate == priceRate)&&(identical(other.hourRate, hourRate) || other.hourRate == hourRate)&&(identical(other.consumptionRate, consumptionRate) || other.consumptionRate == consumptionRate)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.station, station) || other.station == station)&&(identical(other.mainImage, mainImage) || other.mainImage == mainImage)&&(identical(other.point, point) || other.point == point));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,status,category,brand,plateNumber,seats,pricePer4Hours,pricePer8Hours,pricePer12Hours,pricePerDay,priceRate,hourRate,consumptionRate,batteryCapacity,batteryLevel,station,mainImage,point]);

@override
String toString() {
  return 'VehicleEntity(id: $id, name: $name, status: $status, category: $category, brand: $brand, plateNumber: $plateNumber, seats: $seats, pricePer4Hours: $pricePer4Hours, pricePer8Hours: $pricePer8Hours, pricePer12Hours: $pricePer12Hours, pricePerDay: $pricePerDay, priceRate: $priceRate, hourRate: $hourRate, consumptionRate: $consumptionRate, batteryCapacity: $batteryCapacity, batteryLevel: $batteryLevel, station: $station, mainImage: $mainImage, point: $point)';
}


}

/// @nodoc
abstract mixin class _$VehicleEntityCopyWith<$Res> implements $VehicleEntityCopyWith<$Res> {
  factory _$VehicleEntityCopyWith(_VehicleEntity value, $Res Function(_VehicleEntity) _then) = __$VehicleEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String status, String? category, String brand, String? plateNumber, int seats, double pricePer4Hours, double pricePer8Hours, double pricePer12Hours, double pricePerDay, double priceRate, double hourRate, double? consumptionRate, double? batteryCapacity, int batteryLevel, StationEntity? station, String? mainImage, int point
});


@override $StationEntityCopyWith<$Res>? get station;

}
/// @nodoc
class __$VehicleEntityCopyWithImpl<$Res>
    implements _$VehicleEntityCopyWith<$Res> {
  __$VehicleEntityCopyWithImpl(this._self, this._then);

  final _VehicleEntity _self;
  final $Res Function(_VehicleEntity) _then;

/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? category = freezed,Object? brand = null,Object? plateNumber = freezed,Object? seats = null,Object? pricePer4Hours = null,Object? pricePer8Hours = null,Object? pricePer12Hours = null,Object? pricePerDay = null,Object? priceRate = null,Object? hourRate = null,Object? consumptionRate = freezed,Object? batteryCapacity = freezed,Object? batteryLevel = null,Object? station = freezed,Object? mainImage = freezed,Object? point = null,}) {
  return _then(_VehicleEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,pricePer4Hours: null == pricePer4Hours ? _self.pricePer4Hours : pricePer4Hours // ignore: cast_nullable_to_non_nullable
as double,pricePer8Hours: null == pricePer8Hours ? _self.pricePer8Hours : pricePer8Hours // ignore: cast_nullable_to_non_nullable
as double,pricePer12Hours: null == pricePer12Hours ? _self.pricePer12Hours : pricePer12Hours // ignore: cast_nullable_to_non_nullable
as double,pricePerDay: null == pricePerDay ? _self.pricePerDay : pricePerDay // ignore: cast_nullable_to_non_nullable
as double,priceRate: null == priceRate ? _self.priceRate : priceRate // ignore: cast_nullable_to_non_nullable
as double,hourRate: null == hourRate ? _self.hourRate : hourRate // ignore: cast_nullable_to_non_nullable
as double,consumptionRate: freezed == consumptionRate ? _self.consumptionRate : consumptionRate // ignore: cast_nullable_to_non_nullable
as double?,batteryCapacity: freezed == batteryCapacity ? _self.batteryCapacity : batteryCapacity // ignore: cast_nullable_to_non_nullable
as double?,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as StationEntity?,mainImage: freezed == mainImage ? _self.mainImage : mainImage // ignore: cast_nullable_to_non_nullable
as String?,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationEntityCopyWith<$Res>? get station {
    if (_self.station == null) {
    return null;
  }

  return $StationEntityCopyWith<$Res>(_self.station!, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}

// dart format on
