import 'package:hive/hive.dart';

part 'userModel.g.dart';  // Make sure this matches the file name

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String city;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  int rupee;

  User({required this.name, required this.phone, required this.city, required this.imageUrl, required this.rupee});
}
