// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  city: json['city'] as String,
  street: json['street'] as String,
  house: json['house'] as String,
  flat: (json['flat'] as num).toInt(),
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'city': instance.city,
  'street': instance.street,
  'house': instance.house,
  'flat': instance.flat,
};
