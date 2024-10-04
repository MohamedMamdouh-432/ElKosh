import 'package:equatable/equatable.dart';

class DeliveryLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String houseNumber;
  final String road;
  final String neighbourhood;
  final String city;
  final String state;
  final String country;

  const DeliveryLocation({
    required this.latitude,
    required this.longitude,
    required this.houseNumber,
    required this.road,
    required this.neighbourhood,
    required this.city,
    required this.state,
    required this.country,
  });

  static const empty = DeliveryLocation(
    latitude: 0,
    longitude: 0,
    houseNumber: '',
    road: '',
    neighbourhood: '',
    city: '',
    state: '',
    country: '',
  );

  factory DeliveryLocation.fromMapPicker(
    double latitude,
    double longitude,
    Map<String, dynamic> jsonMap,
  ) =>
      DeliveryLocation(
        latitude: latitude,
        longitude: longitude,
        houseNumber: jsonMap['house_number'],
        road: jsonMap['road'],
        neighbourhood: jsonMap['neighbourhood'],
        city: jsonMap['city'],
        state: jsonMap['state'],
        country: jsonMap['country'],
      );

  factory DeliveryLocation.fromJson(Map<String, dynamic> jsonMap) =>
      DeliveryLocation(
        latitude: jsonMap['latitude'],
        longitude: jsonMap['longitude'],
        houseNumber: jsonMap['houseNumber'],
        road: jsonMap['road'],
        neighbourhood: jsonMap['neighbourhood'],
        city: jsonMap['city'],
        state: jsonMap['state'],
        country: jsonMap['country'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'houseNumber': houseNumber,
        'road': road,
        'neighbourhood': neighbourhood,
        'city': city,
        'state': state,
        'country': country,
      };

  DeliveryLocation copyWith({
    double? latitude,
    double? longitude,
    String? houseNumber,
    String? road,
    String? neighbourhood,
    String? city,
    String? state,
    String? country,
  }) {
    return DeliveryLocation(
      houseNumber: houseNumber ?? this.houseNumber,
      road: road ?? this.road,
      neighbourhood: neighbourhood ?? this.neighbourhood,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() => '';

  @override
  List<Object> get props {
    return [
      houseNumber,
      road,
      neighbourhood,
      city,
      state,
      country,
      latitude,
      longitude,
    ];
  }
}
