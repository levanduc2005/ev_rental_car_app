// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationEntity {

 int get id; String get name; String get address; String? get city; double? get latitude; double? get longitude; String? get status; int? get availableVehiclesCount; int? get totalSlots;
/// Create a copy of StationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationEntityCopyWith<StationEntity> get copyWith => _$StationEntityCopyWithImpl<StationEntity>(this as StationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.status, status) || other.status == status)&&(identical(other.availableVehiclesCount, availableVehiclesCount) || other.availableVehiclesCount == availableVehiclesCount)&&(identical(other.totalSlots, totalSlots) || other.totalSlots == totalSlots));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,latitude,longitude,status,availableVehiclesCount,totalSlots);

@override
String toString() {
  return 'StationEntity(id: $id, name: $name, address: $address, city: $city, latitude: $latitude, longitude: $longitude, status: $status, availableVehiclesCount: $availableVehiclesCount, totalSlots: $totalSlots)';
}


}

/// @nodoc
abstract mixin class $StationEntityCopyWith<$Res>  {
  factory $StationEntityCopyWith(StationEntity value, $Res Function(StationEntity) _then) = _$StationEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String address, String? city, double? latitude, double? longitude, String? status, int? availableVehiclesCount, int? totalSlots
});




}
/// @nodoc
class _$StationEntityCopyWithImpl<$Res>
    implements $StationEntityCopyWith<$Res> {
  _$StationEntityCopyWithImpl(this._self, this._then);

  final StationEntity _self;
  final $Res Function(StationEntity) _then;

/// Create a copy of StationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? status = freezed,Object? availableVehiclesCount = freezed,Object? totalSlots = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,availableVehiclesCount: freezed == availableVehiclesCount ? _self.availableVehiclesCount : availableVehiclesCount // ignore: cast_nullable_to_non_nullable
as int?,totalSlots: freezed == totalSlots ? _self.totalSlots : totalSlots // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationEntity].
extension StationEntityPatterns on StationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationEntity value)  $default,){
final _that = this;
switch (_that) {
case _StationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String address,  String? city,  double? latitude,  double? longitude,  String? status,  int? availableVehiclesCount,  int? totalSlots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationEntity() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.status,_that.availableVehiclesCount,_that.totalSlots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String address,  String? city,  double? latitude,  double? longitude,  String? status,  int? availableVehiclesCount,  int? totalSlots)  $default,) {final _that = this;
switch (_that) {
case _StationEntity():
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.status,_that.availableVehiclesCount,_that.totalSlots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String address,  String? city,  double? latitude,  double? longitude,  String? status,  int? availableVehiclesCount,  int? totalSlots)?  $default,) {final _that = this;
switch (_that) {
case _StationEntity() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.status,_that.availableVehiclesCount,_that.totalSlots);case _:
  return null;

}
}

}

/// @nodoc


class _StationEntity implements StationEntity {
  const _StationEntity({required this.id, required this.name, this.address = '', this.city, this.latitude, this.longitude, this.status, this.availableVehiclesCount, this.totalSlots});
  

@override final  int id;
@override final  String name;
@override@JsonKey() final  String address;
@override final  String? city;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? status;
@override final  int? availableVehiclesCount;
@override final  int? totalSlots;

/// Create a copy of StationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationEntityCopyWith<_StationEntity> get copyWith => __$StationEntityCopyWithImpl<_StationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.status, status) || other.status == status)&&(identical(other.availableVehiclesCount, availableVehiclesCount) || other.availableVehiclesCount == availableVehiclesCount)&&(identical(other.totalSlots, totalSlots) || other.totalSlots == totalSlots));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,latitude,longitude,status,availableVehiclesCount,totalSlots);

@override
String toString() {
  return 'StationEntity(id: $id, name: $name, address: $address, city: $city, latitude: $latitude, longitude: $longitude, status: $status, availableVehiclesCount: $availableVehiclesCount, totalSlots: $totalSlots)';
}


}

/// @nodoc
abstract mixin class _$StationEntityCopyWith<$Res> implements $StationEntityCopyWith<$Res> {
  factory _$StationEntityCopyWith(_StationEntity value, $Res Function(_StationEntity) _then) = __$StationEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String address, String? city, double? latitude, double? longitude, String? status, int? availableVehiclesCount, int? totalSlots
});




}
/// @nodoc
class __$StationEntityCopyWithImpl<$Res>
    implements _$StationEntityCopyWith<$Res> {
  __$StationEntityCopyWithImpl(this._self, this._then);

  final _StationEntity _self;
  final $Res Function(_StationEntity) _then;

/// Create a copy of StationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? status = freezed,Object? availableVehiclesCount = freezed,Object? totalSlots = freezed,}) {
  return _then(_StationEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,availableVehiclesCount: freezed == availableVehiclesCount ? _self.availableVehiclesCount : availableVehiclesCount // ignore: cast_nullable_to_non_nullable
as int?,totalSlots: freezed == totalSlots ? _self.totalSlots : totalSlots // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
