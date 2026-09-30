// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VehicleModel {

 int get id; String get name; String get status; String? get category; String get brand; String? get plateNumber; int get seats; double? get pricePer4Hours; double? get pricePer8Hours; double? get pricePer12Hours; double? get pricePerDay; double get priceRate; double get hourRate; double? get consumptionRate; double? get batteryCapacity; int get batteryLevel; StationModel? get station; String? get stationName; String? get main; List<String>? get images; String? get description; int get point; double get distanceKm; double? get depositFee; double? get holdFee;
/// Create a copy of VehicleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleModelCopyWith<VehicleModel> get copyWith => _$VehicleModelCopyWithImpl<VehicleModel>(this as VehicleModel, _$identity);

  /// Serializes this VehicleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.pricePer4Hours, pricePer4Hours) || other.pricePer4Hours == pricePer4Hours)&&(identical(other.pricePer8Hours, pricePer8Hours) || other.pricePer8Hours == pricePer8Hours)&&(identical(other.pricePer12Hours, pricePer12Hours) || other.pricePer12Hours == pricePer12Hours)&&(identical(other.pricePerDay, pricePerDay) || other.pricePerDay == pricePerDay)&&(identical(other.priceRate, priceRate) || other.priceRate == priceRate)&&(identical(other.hourRate, hourRate) || other.hourRate == hourRate)&&(identical(other.consumptionRate, consumptionRate) || other.consumptionRate == consumptionRate)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.station, station) || other.station == station)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.main, main) || other.main == main)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.description, description) || other.description == description)&&(identical(other.point, point) || other.point == point)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.depositFee, depositFee) || other.depositFee == depositFee)&&(identical(other.holdFee, holdFee) || other.holdFee == holdFee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,status,category,brand,plateNumber,seats,pricePer4Hours,pricePer8Hours,pricePer12Hours,pricePerDay,priceRate,hourRate,consumptionRate,batteryCapacity,batteryLevel,station,stationName,main,const DeepCollectionEquality().hash(images),description,point,distanceKm,depositFee,holdFee]);

@override
String toString() {
  return 'VehicleModel(id: $id, name: $name, status: $status, category: $category, brand: $brand, plateNumber: $plateNumber, seats: $seats, pricePer4Hours: $pricePer4Hours, pricePer8Hours: $pricePer8Hours, pricePer12Hours: $pricePer12Hours, pricePerDay: $pricePerDay, priceRate: $priceRate, hourRate: $hourRate, consumptionRate: $consumptionRate, batteryCapacity: $batteryCapacity, batteryLevel: $batteryLevel, station: $station, stationName: $stationName, main: $main, images: $images, description: $description, point: $point, distanceKm: $distanceKm, depositFee: $depositFee, holdFee: $holdFee)';
}


}

/// @nodoc
abstract mixin class $VehicleModelCopyWith<$Res>  {
  factory $VehicleModelCopyWith(VehicleModel value, $Res Function(VehicleModel) _then) = _$VehicleModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String status, String? category, String brand, String? plateNumber, int seats, double? pricePer4Hours, double? pricePer8Hours, double? pricePer12Hours, double? pricePerDay, double priceRate, double hourRate, double? consumptionRate, double? batteryCapacity, int batteryLevel, StationModel? station, String? stationName, String? main, List<String>? images, String? description, int point, double distanceKm, double? depositFee, double? holdFee
});


$StationModelCopyWith<$Res>? get station;

}
/// @nodoc
class _$VehicleModelCopyWithImpl<$Res>
    implements $VehicleModelCopyWith<$Res> {
  _$VehicleModelCopyWithImpl(this._self, this._then);

  final VehicleModel _self;
  final $Res Function(VehicleModel) _then;

/// Create a copy of VehicleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? category = freezed,Object? brand = null,Object? plateNumber = freezed,Object? seats = null,Object? pricePer4Hours = freezed,Object? pricePer8Hours = freezed,Object? pricePer12Hours = freezed,Object? pricePerDay = freezed,Object? priceRate = null,Object? hourRate = null,Object? consumptionRate = freezed,Object? batteryCapacity = freezed,Object? batteryLevel = null,Object? station = freezed,Object? stationName = freezed,Object? main = freezed,Object? images = freezed,Object? description = freezed,Object? point = null,Object? distanceKm = null,Object? depositFee = freezed,Object? holdFee = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,pricePer4Hours: freezed == pricePer4Hours ? _self.pricePer4Hours : pricePer4Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer8Hours: freezed == pricePer8Hours ? _self.pricePer8Hours : pricePer8Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer12Hours: freezed == pricePer12Hours ? _self.pricePer12Hours : pricePer12Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePerDay: freezed == pricePerDay ? _self.pricePerDay : pricePerDay // ignore: cast_nullable_to_non_nullable
as double?,priceRate: null == priceRate ? _self.priceRate : priceRate // ignore: cast_nullable_to_non_nullable
as double,hourRate: null == hourRate ? _self.hourRate : hourRate // ignore: cast_nullable_to_non_nullable
as double,consumptionRate: freezed == consumptionRate ? _self.consumptionRate : consumptionRate // ignore: cast_nullable_to_non_nullable
as double?,batteryCapacity: freezed == batteryCapacity ? _self.batteryCapacity : batteryCapacity // ignore: cast_nullable_to_non_nullable
as double?,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as StationModel?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,main: freezed == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as int,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,depositFee: freezed == depositFee ? _self.depositFee : depositFee // ignore: cast_nullable_to_non_nullable
as double?,holdFee: freezed == holdFee ? _self.holdFee : holdFee // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of VehicleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationModelCopyWith<$Res>? get station {
    if (_self.station == null) {
    return null;
  }

  return $StationModelCopyWith<$Res>(_self.station!, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}


/// Adds pattern-matching-related methods to [VehicleModel].
extension VehicleModelPatterns on VehicleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleModel value)  $default,){
final _that = this;
switch (_that) {
case _VehicleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleModel value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String status,  String? category,  String brand,  String? plateNumber,  int seats,  double? pricePer4Hours,  double? pricePer8Hours,  double? pricePer12Hours,  double? pricePerDay,  double priceRate,  double hourRate,  double? consumptionRate,  double? batteryCapacity,  int batteryLevel,  StationModel? station,  String? stationName,  String? main,  List<String>? images,  String? description,  int point,  double distanceKm,  double? depositFee,  double? holdFee)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleModel() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.category,_that.brand,_that.plateNumber,_that.seats,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.priceRate,_that.hourRate,_that.consumptionRate,_that.batteryCapacity,_that.batteryLevel,_that.station,_that.stationName,_that.main,_that.images,_that.description,_that.point,_that.distanceKm,_that.depositFee,_that.holdFee);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String status,  String? category,  String brand,  String? plateNumber,  int seats,  double? pricePer4Hours,  double? pricePer8Hours,  double? pricePer12Hours,  double? pricePerDay,  double priceRate,  double hourRate,  double? consumptionRate,  double? batteryCapacity,  int batteryLevel,  StationModel? station,  String? stationName,  String? main,  List<String>? images,  String? description,  int point,  double distanceKm,  double? depositFee,  double? holdFee)  $default,) {final _that = this;
switch (_that) {
case _VehicleModel():
return $default(_that.id,_that.name,_that.status,_that.category,_that.brand,_that.plateNumber,_that.seats,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.priceRate,_that.hourRate,_that.consumptionRate,_that.batteryCapacity,_that.batteryLevel,_that.station,_that.stationName,_that.main,_that.images,_that.description,_that.point,_that.distanceKm,_that.depositFee,_that.holdFee);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String status,  String? category,  String brand,  String? plateNumber,  int seats,  double? pricePer4Hours,  double? pricePer8Hours,  double? pricePer12Hours,  double? pricePerDay,  double priceRate,  double hourRate,  double? consumptionRate,  double? batteryCapacity,  int batteryLevel,  StationModel? station,  String? stationName,  String? main,  List<String>? images,  String? description,  int point,  double distanceKm,  double? depositFee,  double? holdFee)?  $default,) {final _that = this;
switch (_that) {
case _VehicleModel() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.category,_that.brand,_that.plateNumber,_that.seats,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.priceRate,_that.hourRate,_that.consumptionRate,_that.batteryCapacity,_that.batteryLevel,_that.station,_that.stationName,_that.main,_that.images,_that.description,_that.point,_that.distanceKm,_that.depositFee,_that.holdFee);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleModel implements VehicleModel {
  const _VehicleModel({required this.id, required this.name, this.status = 'AVAILABLE', this.category, required this.brand, this.plateNumber, this.seats = 4, this.pricePer4Hours, this.pricePer8Hours, this.pricePer12Hours, this.pricePerDay, this.priceRate = 0.0, this.hourRate = 0.0, this.consumptionRate, this.batteryCapacity, this.batteryLevel = 0, this.station, this.stationName, this.main, final  List<String>? images, this.description, this.point = 5, this.distanceKm = 0.0, this.depositFee, this.holdFee}): _images = images;
  factory _VehicleModel.fromJson(Map<String, dynamic> json) => _$VehicleModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String status;
@override final  String? category;
@override final  String brand;
@override final  String? plateNumber;
@override@JsonKey() final  int seats;
@override final  double? pricePer4Hours;
@override final  double? pricePer8Hours;
@override final  double? pricePer12Hours;
@override final  double? pricePerDay;
@override@JsonKey() final  double priceRate;
@override@JsonKey() final  double hourRate;
@override final  double? consumptionRate;
@override final  double? batteryCapacity;
@override@JsonKey() final  int batteryLevel;
@override final  StationModel? station;
@override final  String? stationName;
@override final  String? main;
 final  List<String>? _images;
@override List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? description;
@override@JsonKey() final  int point;
@override@JsonKey() final  double distanceKm;
@override final  double? depositFee;
@override final  double? holdFee;

/// Create a copy of VehicleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleModelCopyWith<_VehicleModel> get copyWith => __$VehicleModelCopyWithImpl<_VehicleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.pricePer4Hours, pricePer4Hours) || other.pricePer4Hours == pricePer4Hours)&&(identical(other.pricePer8Hours, pricePer8Hours) || other.pricePer8Hours == pricePer8Hours)&&(identical(other.pricePer12Hours, pricePer12Hours) || other.pricePer12Hours == pricePer12Hours)&&(identical(other.pricePerDay, pricePerDay) || other.pricePerDay == pricePerDay)&&(identical(other.priceRate, priceRate) || other.priceRate == priceRate)&&(identical(other.hourRate, hourRate) || other.hourRate == hourRate)&&(identical(other.consumptionRate, consumptionRate) || other.consumptionRate == consumptionRate)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.station, station) || other.station == station)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.main, main) || other.main == main)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.description, description) || other.description == description)&&(identical(other.point, point) || other.point == point)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.depositFee, depositFee) || other.depositFee == depositFee)&&(identical(other.holdFee, holdFee) || other.holdFee == holdFee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,status,category,brand,plateNumber,seats,pricePer4Hours,pricePer8Hours,pricePer12Hours,pricePerDay,priceRate,hourRate,consumptionRate,batteryCapacity,batteryLevel,station,stationName,main,const DeepCollectionEquality().hash(_images),description,point,distanceKm,depositFee,holdFee]);

@override
String toString() {
  return 'VehicleModel(id: $id, name: $name, status: $status, category: $category, brand: $brand, plateNumber: $plateNumber, seats: $seats, pricePer4Hours: $pricePer4Hours, pricePer8Hours: $pricePer8Hours, pricePer12Hours: $pricePer12Hours, pricePerDay: $pricePerDay, priceRate: $priceRate, hourRate: $hourRate, consumptionRate: $consumptionRate, batteryCapacity: $batteryCapacity, batteryLevel: $batteryLevel, station: $station, stationName: $stationName, main: $main, images: $images, description: $description, point: $point, distanceKm: $distanceKm, depositFee: $depositFee, holdFee: $holdFee)';
}


}

/// @nodoc
abstract mixin class _$VehicleModelCopyWith<$Res> implements $VehicleModelCopyWith<$Res> {
  factory _$VehicleModelCopyWith(_VehicleModel value, $Res Function(_VehicleModel) _then) = __$VehicleModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String status, String? category, String brand, String? plateNumber, int seats, double? pricePer4Hours, double? pricePer8Hours, double? pricePer12Hours, double? pricePerDay, double priceRate, double hourRate, double? consumptionRate, double? batteryCapacity, int batteryLevel, StationModel? station, String? stationName, String? main, List<String>? images, String? description, int point, double distanceKm, double? depositFee, double? holdFee
});


@override $StationModelCopyWith<$Res>? get station;

}
/// @nodoc
class __$VehicleModelCopyWithImpl<$Res>
    implements _$VehicleModelCopyWith<$Res> {
  __$VehicleModelCopyWithImpl(this._self, this._then);

  final _VehicleModel _self;
  final $Res Function(_VehicleModel) _then;

/// Create a copy of VehicleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? category = freezed,Object? brand = null,Object? plateNumber = freezed,Object? seats = null,Object? pricePer4Hours = freezed,Object? pricePer8Hours = freezed,Object? pricePer12Hours = freezed,Object? pricePerDay = freezed,Object? priceRate = null,Object? hourRate = null,Object? consumptionRate = freezed,Object? batteryCapacity = freezed,Object? batteryLevel = null,Object? station = freezed,Object? stationName = freezed,Object? main = freezed,Object? images = freezed,Object? description = freezed,Object? point = null,Object? distanceKm = null,Object? depositFee = freezed,Object? holdFee = freezed,}) {
  return _then(_VehicleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,pricePer4Hours: freezed == pricePer4Hours ? _self.pricePer4Hours : pricePer4Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer8Hours: freezed == pricePer8Hours ? _self.pricePer8Hours : pricePer8Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer12Hours: freezed == pricePer12Hours ? _self.pricePer12Hours : pricePer12Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePerDay: freezed == pricePerDay ? _self.pricePerDay : pricePerDay // ignore: cast_nullable_to_non_nullable
as double?,priceRate: null == priceRate ? _self.priceRate : priceRate // ignore: cast_nullable_to_non_nullable
as double,hourRate: null == hourRate ? _self.hourRate : hourRate // ignore: cast_nullable_to_non_nullable
as double,consumptionRate: freezed == consumptionRate ? _self.consumptionRate : consumptionRate // ignore: cast_nullable_to_non_nullable
as double?,batteryCapacity: freezed == batteryCapacity ? _self.batteryCapacity : batteryCapacity // ignore: cast_nullable_to_non_nullable
as double?,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as StationModel?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,main: freezed == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as int,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,depositFee: freezed == depositFee ? _self.depositFee : depositFee // ignore: cast_nullable_to_non_nullable
as double?,holdFee: freezed == holdFee ? _self.holdFee : holdFee // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of VehicleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationModelCopyWith<$Res>? get station {
    if (_self.station == null) {
    return null;
  }

  return $StationModelCopyWith<$Res>(_self.station!, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}

// dart format on
