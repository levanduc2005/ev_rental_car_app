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

 String get id; String get name; String get location; double get distanceKm; int get originalPriceK; int get salePriceK; String get priceUnit; String get estimatedDuration; int get viewingCount; int get seats; String get transmission; String get fuelType; String get imageUrl; String get discountText; String get deliveryType; bool get isLuxury; String get luxuryTag; String? get consumption; String? get description; List<String>? get imageUrls; String? get rentalFee; String? get insuranceFee; String? get discountAmount; String? get vatAmount; String? get totalRental; String? get holdingDeposit; String? get collateralDeposit; double? get pricePer4Hours; double? get pricePer8Hours; double? get pricePer12Hours; double? get pricePerDay; String? get stationName;
/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleEntityCopyWith<VehicleEntity> get copyWith => _$VehicleEntityCopyWithImpl<VehicleEntity>(this as VehicleEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.originalPriceK, originalPriceK) || other.originalPriceK == originalPriceK)&&(identical(other.salePriceK, salePriceK) || other.salePriceK == salePriceK)&&(identical(other.priceUnit, priceUnit) || other.priceUnit == priceUnit)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.viewingCount, viewingCount) || other.viewingCount == viewingCount)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.transmission, transmission) || other.transmission == transmission)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.discountText, discountText) || other.discountText == discountText)&&(identical(other.deliveryType, deliveryType) || other.deliveryType == deliveryType)&&(identical(other.isLuxury, isLuxury) || other.isLuxury == isLuxury)&&(identical(other.luxuryTag, luxuryTag) || other.luxuryTag == luxuryTag)&&(identical(other.consumption, consumption) || other.consumption == consumption)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.rentalFee, rentalFee) || other.rentalFee == rentalFee)&&(identical(other.insuranceFee, insuranceFee) || other.insuranceFee == insuranceFee)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.totalRental, totalRental) || other.totalRental == totalRental)&&(identical(other.holdingDeposit, holdingDeposit) || other.holdingDeposit == holdingDeposit)&&(identical(other.collateralDeposit, collateralDeposit) || other.collateralDeposit == collateralDeposit)&&(identical(other.pricePer4Hours, pricePer4Hours) || other.pricePer4Hours == pricePer4Hours)&&(identical(other.pricePer8Hours, pricePer8Hours) || other.pricePer8Hours == pricePer8Hours)&&(identical(other.pricePer12Hours, pricePer12Hours) || other.pricePer12Hours == pricePer12Hours)&&(identical(other.pricePerDay, pricePerDay) || other.pricePerDay == pricePerDay)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,location,distanceKm,originalPriceK,salePriceK,priceUnit,estimatedDuration,viewingCount,seats,transmission,fuelType,imageUrl,discountText,deliveryType,isLuxury,luxuryTag,consumption,description,const DeepCollectionEquality().hash(imageUrls),rentalFee,insuranceFee,discountAmount,vatAmount,totalRental,holdingDeposit,collateralDeposit,pricePer4Hours,pricePer8Hours,pricePer12Hours,pricePerDay,stationName]);

@override
String toString() {
  return 'VehicleEntity(id: $id, name: $name, location: $location, distanceKm: $distanceKm, originalPriceK: $originalPriceK, salePriceK: $salePriceK, priceUnit: $priceUnit, estimatedDuration: $estimatedDuration, viewingCount: $viewingCount, seats: $seats, transmission: $transmission, fuelType: $fuelType, imageUrl: $imageUrl, discountText: $discountText, deliveryType: $deliveryType, isLuxury: $isLuxury, luxuryTag: $luxuryTag, consumption: $consumption, description: $description, imageUrls: $imageUrls, rentalFee: $rentalFee, insuranceFee: $insuranceFee, discountAmount: $discountAmount, vatAmount: $vatAmount, totalRental: $totalRental, holdingDeposit: $holdingDeposit, collateralDeposit: $collateralDeposit, pricePer4Hours: $pricePer4Hours, pricePer8Hours: $pricePer8Hours, pricePer12Hours: $pricePer12Hours, pricePerDay: $pricePerDay, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class $VehicleEntityCopyWith<$Res>  {
  factory $VehicleEntityCopyWith(VehicleEntity value, $Res Function(VehicleEntity) _then) = _$VehicleEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String location, double distanceKm, int originalPriceK, int salePriceK, String priceUnit, String estimatedDuration, int viewingCount, int seats, String transmission, String fuelType, String imageUrl, String discountText, String deliveryType, bool isLuxury, String luxuryTag, String? consumption, String? description, List<String>? imageUrls, String? rentalFee, String? insuranceFee, String? discountAmount, String? vatAmount, String? totalRental, String? holdingDeposit, String? collateralDeposit, double? pricePer4Hours, double? pricePer8Hours, double? pricePer12Hours, double? pricePerDay, String? stationName
});




}
/// @nodoc
class _$VehicleEntityCopyWithImpl<$Res>
    implements $VehicleEntityCopyWith<$Res> {
  _$VehicleEntityCopyWithImpl(this._self, this._then);

  final VehicleEntity _self;
  final $Res Function(VehicleEntity) _then;

/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? location = null,Object? distanceKm = null,Object? originalPriceK = null,Object? salePriceK = null,Object? priceUnit = null,Object? estimatedDuration = null,Object? viewingCount = null,Object? seats = null,Object? transmission = null,Object? fuelType = null,Object? imageUrl = null,Object? discountText = null,Object? deliveryType = null,Object? isLuxury = null,Object? luxuryTag = null,Object? consumption = freezed,Object? description = freezed,Object? imageUrls = freezed,Object? rentalFee = freezed,Object? insuranceFee = freezed,Object? discountAmount = freezed,Object? vatAmount = freezed,Object? totalRental = freezed,Object? holdingDeposit = freezed,Object? collateralDeposit = freezed,Object? pricePer4Hours = freezed,Object? pricePer8Hours = freezed,Object? pricePer12Hours = freezed,Object? pricePerDay = freezed,Object? stationName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,originalPriceK: null == originalPriceK ? _self.originalPriceK : originalPriceK // ignore: cast_nullable_to_non_nullable
as int,salePriceK: null == salePriceK ? _self.salePriceK : salePriceK // ignore: cast_nullable_to_non_nullable
as int,priceUnit: null == priceUnit ? _self.priceUnit : priceUnit // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as String,viewingCount: null == viewingCount ? _self.viewingCount : viewingCount // ignore: cast_nullable_to_non_nullable
as int,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,transmission: null == transmission ? _self.transmission : transmission // ignore: cast_nullable_to_non_nullable
as String,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,discountText: null == discountText ? _self.discountText : discountText // ignore: cast_nullable_to_non_nullable
as String,deliveryType: null == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as String,isLuxury: null == isLuxury ? _self.isLuxury : isLuxury // ignore: cast_nullable_to_non_nullable
as bool,luxuryTag: null == luxuryTag ? _self.luxuryTag : luxuryTag // ignore: cast_nullable_to_non_nullable
as String,consumption: freezed == consumption ? _self.consumption : consumption // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: freezed == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,rentalFee: freezed == rentalFee ? _self.rentalFee : rentalFee // ignore: cast_nullable_to_non_nullable
as String?,insuranceFee: freezed == insuranceFee ? _self.insuranceFee : insuranceFee // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String?,vatAmount: freezed == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as String?,totalRental: freezed == totalRental ? _self.totalRental : totalRental // ignore: cast_nullable_to_non_nullable
as String?,holdingDeposit: freezed == holdingDeposit ? _self.holdingDeposit : holdingDeposit // ignore: cast_nullable_to_non_nullable
as String?,collateralDeposit: freezed == collateralDeposit ? _self.collateralDeposit : collateralDeposit // ignore: cast_nullable_to_non_nullable
as String?,pricePer4Hours: freezed == pricePer4Hours ? _self.pricePer4Hours : pricePer4Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer8Hours: freezed == pricePer8Hours ? _self.pricePer8Hours : pricePer8Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer12Hours: freezed == pricePer12Hours ? _self.pricePer12Hours : pricePer12Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePerDay: freezed == pricePerDay ? _self.pricePerDay : pricePerDay // ignore: cast_nullable_to_non_nullable
as double?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String location,  double distanceKm,  int originalPriceK,  int salePriceK,  String priceUnit,  String estimatedDuration,  int viewingCount,  int seats,  String transmission,  String fuelType,  String imageUrl,  String discountText,  String deliveryType,  bool isLuxury,  String luxuryTag,  String? consumption,  String? description,  List<String>? imageUrls,  String? rentalFee,  String? insuranceFee,  String? discountAmount,  String? vatAmount,  String? totalRental,  String? holdingDeposit,  String? collateralDeposit,  double? pricePer4Hours,  double? pricePer8Hours,  double? pricePer12Hours,  double? pricePerDay,  String? stationName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleEntity() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.distanceKm,_that.originalPriceK,_that.salePriceK,_that.priceUnit,_that.estimatedDuration,_that.viewingCount,_that.seats,_that.transmission,_that.fuelType,_that.imageUrl,_that.discountText,_that.deliveryType,_that.isLuxury,_that.luxuryTag,_that.consumption,_that.description,_that.imageUrls,_that.rentalFee,_that.insuranceFee,_that.discountAmount,_that.vatAmount,_that.totalRental,_that.holdingDeposit,_that.collateralDeposit,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.stationName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String location,  double distanceKm,  int originalPriceK,  int salePriceK,  String priceUnit,  String estimatedDuration,  int viewingCount,  int seats,  String transmission,  String fuelType,  String imageUrl,  String discountText,  String deliveryType,  bool isLuxury,  String luxuryTag,  String? consumption,  String? description,  List<String>? imageUrls,  String? rentalFee,  String? insuranceFee,  String? discountAmount,  String? vatAmount,  String? totalRental,  String? holdingDeposit,  String? collateralDeposit,  double? pricePer4Hours,  double? pricePer8Hours,  double? pricePer12Hours,  double? pricePerDay,  String? stationName)  $default,) {final _that = this;
switch (_that) {
case _VehicleEntity():
return $default(_that.id,_that.name,_that.location,_that.distanceKm,_that.originalPriceK,_that.salePriceK,_that.priceUnit,_that.estimatedDuration,_that.viewingCount,_that.seats,_that.transmission,_that.fuelType,_that.imageUrl,_that.discountText,_that.deliveryType,_that.isLuxury,_that.luxuryTag,_that.consumption,_that.description,_that.imageUrls,_that.rentalFee,_that.insuranceFee,_that.discountAmount,_that.vatAmount,_that.totalRental,_that.holdingDeposit,_that.collateralDeposit,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.stationName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String location,  double distanceKm,  int originalPriceK,  int salePriceK,  String priceUnit,  String estimatedDuration,  int viewingCount,  int seats,  String transmission,  String fuelType,  String imageUrl,  String discountText,  String deliveryType,  bool isLuxury,  String luxuryTag,  String? consumption,  String? description,  List<String>? imageUrls,  String? rentalFee,  String? insuranceFee,  String? discountAmount,  String? vatAmount,  String? totalRental,  String? holdingDeposit,  String? collateralDeposit,  double? pricePer4Hours,  double? pricePer8Hours,  double? pricePer12Hours,  double? pricePerDay,  String? stationName)?  $default,) {final _that = this;
switch (_that) {
case _VehicleEntity() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.distanceKm,_that.originalPriceK,_that.salePriceK,_that.priceUnit,_that.estimatedDuration,_that.viewingCount,_that.seats,_that.transmission,_that.fuelType,_that.imageUrl,_that.discountText,_that.deliveryType,_that.isLuxury,_that.luxuryTag,_that.consumption,_that.description,_that.imageUrls,_that.rentalFee,_that.insuranceFee,_that.discountAmount,_that.vatAmount,_that.totalRental,_that.holdingDeposit,_that.collateralDeposit,_that.pricePer4Hours,_that.pricePer8Hours,_that.pricePer12Hours,_that.pricePerDay,_that.stationName);case _:
  return null;

}
}

}

/// @nodoc


class _VehicleEntity implements VehicleEntity {
  const _VehicleEntity({required this.id, required this.name, required this.location, required this.distanceKm, required this.originalPriceK, required this.salePriceK, required this.priceUnit, required this.estimatedDuration, required this.viewingCount, required this.seats, required this.transmission, required this.fuelType, required this.imageUrl, required this.discountText, required this.deliveryType, required this.isLuxury, required this.luxuryTag, this.consumption, this.description, final  List<String>? imageUrls, this.rentalFee, this.insuranceFee, this.discountAmount, this.vatAmount, this.totalRental, this.holdingDeposit, this.collateralDeposit, this.pricePer4Hours, this.pricePer8Hours, this.pricePer12Hours, this.pricePerDay, this.stationName}): _imageUrls = imageUrls;
  

@override final  String id;
@override final  String name;
@override final  String location;
@override final  double distanceKm;
@override final  int originalPriceK;
@override final  int salePriceK;
@override final  String priceUnit;
@override final  String estimatedDuration;
@override final  int viewingCount;
@override final  int seats;
@override final  String transmission;
@override final  String fuelType;
@override final  String imageUrl;
@override final  String discountText;
@override final  String deliveryType;
@override final  bool isLuxury;
@override final  String luxuryTag;
@override final  String? consumption;
@override final  String? description;
 final  List<String>? _imageUrls;
@override List<String>? get imageUrls {
  final value = _imageUrls;
  if (value == null) return null;
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? rentalFee;
@override final  String? insuranceFee;
@override final  String? discountAmount;
@override final  String? vatAmount;
@override final  String? totalRental;
@override final  String? holdingDeposit;
@override final  String? collateralDeposit;
@override final  double? pricePer4Hours;
@override final  double? pricePer8Hours;
@override final  double? pricePer12Hours;
@override final  double? pricePerDay;
@override final  String? stationName;

/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleEntityCopyWith<_VehicleEntity> get copyWith => __$VehicleEntityCopyWithImpl<_VehicleEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.originalPriceK, originalPriceK) || other.originalPriceK == originalPriceK)&&(identical(other.salePriceK, salePriceK) || other.salePriceK == salePriceK)&&(identical(other.priceUnit, priceUnit) || other.priceUnit == priceUnit)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.viewingCount, viewingCount) || other.viewingCount == viewingCount)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.transmission, transmission) || other.transmission == transmission)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.discountText, discountText) || other.discountText == discountText)&&(identical(other.deliveryType, deliveryType) || other.deliveryType == deliveryType)&&(identical(other.isLuxury, isLuxury) || other.isLuxury == isLuxury)&&(identical(other.luxuryTag, luxuryTag) || other.luxuryTag == luxuryTag)&&(identical(other.consumption, consumption) || other.consumption == consumption)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.rentalFee, rentalFee) || other.rentalFee == rentalFee)&&(identical(other.insuranceFee, insuranceFee) || other.insuranceFee == insuranceFee)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.totalRental, totalRental) || other.totalRental == totalRental)&&(identical(other.holdingDeposit, holdingDeposit) || other.holdingDeposit == holdingDeposit)&&(identical(other.collateralDeposit, collateralDeposit) || other.collateralDeposit == collateralDeposit)&&(identical(other.pricePer4Hours, pricePer4Hours) || other.pricePer4Hours == pricePer4Hours)&&(identical(other.pricePer8Hours, pricePer8Hours) || other.pricePer8Hours == pricePer8Hours)&&(identical(other.pricePer12Hours, pricePer12Hours) || other.pricePer12Hours == pricePer12Hours)&&(identical(other.pricePerDay, pricePerDay) || other.pricePerDay == pricePerDay)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,location,distanceKm,originalPriceK,salePriceK,priceUnit,estimatedDuration,viewingCount,seats,transmission,fuelType,imageUrl,discountText,deliveryType,isLuxury,luxuryTag,consumption,description,const DeepCollectionEquality().hash(_imageUrls),rentalFee,insuranceFee,discountAmount,vatAmount,totalRental,holdingDeposit,collateralDeposit,pricePer4Hours,pricePer8Hours,pricePer12Hours,pricePerDay,stationName]);

@override
String toString() {
  return 'VehicleEntity(id: $id, name: $name, location: $location, distanceKm: $distanceKm, originalPriceK: $originalPriceK, salePriceK: $salePriceK, priceUnit: $priceUnit, estimatedDuration: $estimatedDuration, viewingCount: $viewingCount, seats: $seats, transmission: $transmission, fuelType: $fuelType, imageUrl: $imageUrl, discountText: $discountText, deliveryType: $deliveryType, isLuxury: $isLuxury, luxuryTag: $luxuryTag, consumption: $consumption, description: $description, imageUrls: $imageUrls, rentalFee: $rentalFee, insuranceFee: $insuranceFee, discountAmount: $discountAmount, vatAmount: $vatAmount, totalRental: $totalRental, holdingDeposit: $holdingDeposit, collateralDeposit: $collateralDeposit, pricePer4Hours: $pricePer4Hours, pricePer8Hours: $pricePer8Hours, pricePer12Hours: $pricePer12Hours, pricePerDay: $pricePerDay, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class _$VehicleEntityCopyWith<$Res> implements $VehicleEntityCopyWith<$Res> {
  factory _$VehicleEntityCopyWith(_VehicleEntity value, $Res Function(_VehicleEntity) _then) = __$VehicleEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String location, double distanceKm, int originalPriceK, int salePriceK, String priceUnit, String estimatedDuration, int viewingCount, int seats, String transmission, String fuelType, String imageUrl, String discountText, String deliveryType, bool isLuxury, String luxuryTag, String? consumption, String? description, List<String>? imageUrls, String? rentalFee, String? insuranceFee, String? discountAmount, String? vatAmount, String? totalRental, String? holdingDeposit, String? collateralDeposit, double? pricePer4Hours, double? pricePer8Hours, double? pricePer12Hours, double? pricePerDay, String? stationName
});




}
/// @nodoc
class __$VehicleEntityCopyWithImpl<$Res>
    implements _$VehicleEntityCopyWith<$Res> {
  __$VehicleEntityCopyWithImpl(this._self, this._then);

  final _VehicleEntity _self;
  final $Res Function(_VehicleEntity) _then;

/// Create a copy of VehicleEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? location = null,Object? distanceKm = null,Object? originalPriceK = null,Object? salePriceK = null,Object? priceUnit = null,Object? estimatedDuration = null,Object? viewingCount = null,Object? seats = null,Object? transmission = null,Object? fuelType = null,Object? imageUrl = null,Object? discountText = null,Object? deliveryType = null,Object? isLuxury = null,Object? luxuryTag = null,Object? consumption = freezed,Object? description = freezed,Object? imageUrls = freezed,Object? rentalFee = freezed,Object? insuranceFee = freezed,Object? discountAmount = freezed,Object? vatAmount = freezed,Object? totalRental = freezed,Object? holdingDeposit = freezed,Object? collateralDeposit = freezed,Object? pricePer4Hours = freezed,Object? pricePer8Hours = freezed,Object? pricePer12Hours = freezed,Object? pricePerDay = freezed,Object? stationName = freezed,}) {
  return _then(_VehicleEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,originalPriceK: null == originalPriceK ? _self.originalPriceK : originalPriceK // ignore: cast_nullable_to_non_nullable
as int,salePriceK: null == salePriceK ? _self.salePriceK : salePriceK // ignore: cast_nullable_to_non_nullable
as int,priceUnit: null == priceUnit ? _self.priceUnit : priceUnit // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as String,viewingCount: null == viewingCount ? _self.viewingCount : viewingCount // ignore: cast_nullable_to_non_nullable
as int,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,transmission: null == transmission ? _self.transmission : transmission // ignore: cast_nullable_to_non_nullable
as String,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,discountText: null == discountText ? _self.discountText : discountText // ignore: cast_nullable_to_non_nullable
as String,deliveryType: null == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as String,isLuxury: null == isLuxury ? _self.isLuxury : isLuxury // ignore: cast_nullable_to_non_nullable
as bool,luxuryTag: null == luxuryTag ? _self.luxuryTag : luxuryTag // ignore: cast_nullable_to_non_nullable
as String,consumption: freezed == consumption ? _self.consumption : consumption // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: freezed == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,rentalFee: freezed == rentalFee ? _self.rentalFee : rentalFee // ignore: cast_nullable_to_non_nullable
as String?,insuranceFee: freezed == insuranceFee ? _self.insuranceFee : insuranceFee // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String?,vatAmount: freezed == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as String?,totalRental: freezed == totalRental ? _self.totalRental : totalRental // ignore: cast_nullable_to_non_nullable
as String?,holdingDeposit: freezed == holdingDeposit ? _self.holdingDeposit : holdingDeposit // ignore: cast_nullable_to_non_nullable
as String?,collateralDeposit: freezed == collateralDeposit ? _self.collateralDeposit : collateralDeposit // ignore: cast_nullable_to_non_nullable
as String?,pricePer4Hours: freezed == pricePer4Hours ? _self.pricePer4Hours : pricePer4Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer8Hours: freezed == pricePer8Hours ? _self.pricePer8Hours : pricePer8Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePer12Hours: freezed == pricePer12Hours ? _self.pricePer12Hours : pricePer12Hours // ignore: cast_nullable_to_non_nullable
as double?,pricePerDay: freezed == pricePerDay ? _self.pricePerDay : pricePerDay // ignore: cast_nullable_to_non_nullable
as double?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
