import 'package:equatable/equatable.dart';

class DeliveryLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const DeliveryLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  static const empty = DeliveryLocation(
    latitude: 0,
    longitude: 0,
    address: '',
  );

  factory DeliveryLocation.fromMapPicker(
    double latitude,
    double longitude,
    String address,
  ) =>
      DeliveryLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

  factory DeliveryLocation.fromJson(Map<String, dynamic> jsonMap) =>
      DeliveryLocation(
        latitude: jsonMap['latitude'].toDouble(),
        longitude: jsonMap['longitude'].toDouble(),
        address: jsonMap['address'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  DeliveryLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return DeliveryLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  @override
  String toString() => 'Delivery Location :\nLatitude: $latitude\nLongitude: $longitude\nAddress: $address\n';

  @override
  List<Object> get props {
    return [
      latitude,
      longitude,
      address,
    ];
  }
}
