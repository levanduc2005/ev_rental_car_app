// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StationModel {

 int get id; String get name; String get address; String? get city; double? get latitude; double? get longitude; String? get status;
/// Create a copy of StationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationModelCopyWith<StationModel> get copyWith => _$StationModelCopyWithImpl<StationModel>(this as StationModel, _$identity);

  /// Serializes this StationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,latitude,longitude,status);

@override
String toString() {
  return 'StationModel(id: $id, name: $name, address: $address, city: $city, latitude: $latitude, longitude: $longitude, status: $status)';
}


}

/// @nodoc
abstract mixin class $StationModelCopyWith<$Res>  {
  factory $StationModelCopyWith(StationModel value, $Res Function(StationModel) _then) = _$StationModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String address, String? city, double? latitude, double? longitude, String? status
});




}
/// @nodoc
class _$StationModelCopyWithImpl<$Res>
    implements $StationModelCopyWith<$Res> {
  _$StationModelCopyWithImpl(this._self, this._then);

  final StationModel _self;
  final $Res Function(StationModel) _then;

/// Create a copy of StationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationModel].
extension StationModelPatterns on StationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationModel value)  $default,){
final _that = this;
switch (_that) {
case _StationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationModel value)?  $default,){
final _that = this;
switch (_that) {
case _StationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String address,  String? city,  double? latitude,  double? longitude,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String address,  String? city,  double? latitude,  double? longitude,  String? status)  $default,) {final _that = this;
switch (_that) {
case _StationModel():
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String address,  String? city,  double? latitude,  double? longitude,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _StationModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationModel implements StationModel {
  const _StationModel({required this.id, required this.name, this.address = '', this.city, this.latitude, this.longitude, this.status});
  factory _StationModel.fromJson(Map<String, dynamic> json) => _$StationModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey() final  String address;
@override final  String? city;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? status;

/// Create a copy of StationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationModelCopyWith<_StationModel> get copyWith => __$StationModelCopyWithImpl<_StationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,latitude,longitude,status);

@override
String toString() {
  return 'StationModel(id: $id, name: $name, address: $address, city: $city, latitude: $latitude, longitude: $longitude, status: $status)';
}


}

/// @nodoc
abstract mixin class _$StationModelCopyWith<$Res> implements $StationModelCopyWith<$Res> {
  factory _$StationModelCopyWith(_StationModel value, $Res Function(_StationModel) _then) = __$StationModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String address, String? city, double? latitude, double? longitude, String? status
});




}
/// @nodoc
class __$StationModelCopyWithImpl<$Res>
    implements _$StationModelCopyWith<$Res> {
  __$StationModelCopyWithImpl(this._self, this._then);

  final _StationModel _self;
  final $Res Function(_StationModel) _then;

/// Create a copy of StationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? status = freezed,}) {
  return _then(_StationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
