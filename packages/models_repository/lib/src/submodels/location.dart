import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 7)
class Location extends Equatable {
  @HiveField(0)
  final double latitude;
  @HiveField(1)
  final double longitude;
  @HiveField(2)
  final String address;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  static const empty = Location(
    latitude: 0,
    longitude: 0,
    address: '',
  );

  factory Location.fromMapPicker(
    double latitude,
    double longitude,
    String address,
  ) =>
      Location(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

  factory Location.fromJson(Map<String, dynamic> jsonMap) => Location(
        latitude: jsonMap['latitude'].toDouble(),
        longitude: jsonMap['longitude'].toDouble(),
        address: jsonMap['address'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  Location copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  @override
  String toString() =>
      'Delivery Location :\nLatitude: $latitude\nLongitude: $longitude\nAddress: $address\n';

  @override
  List<Object> get props {
    return [
      latitude,
      longitude,
      address,
    ];
  }
}
