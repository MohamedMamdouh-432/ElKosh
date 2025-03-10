import 'package:hive/hive.dart';

part 'order_status.g.dart';

@HiveType(typeId: 0)
enum OrderStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  shipped,

  @HiveField(2)
  cancelled,

  @HiveField(3)
  delivered,

  @HiveField(4)
  refused,
}
