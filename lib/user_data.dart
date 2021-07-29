import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'user_data.g.dart';

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  String movieName;

  @HiveField(1)
  String directorName;

  @HiveField(2)
  Uint8List file;

  Person(
      {required this.movieName,
      required this.directorName,
      required this.file});
}
