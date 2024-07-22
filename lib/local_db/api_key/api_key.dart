import 'package:hive/hive.dart';
part 'api_key.g.dart';

@HiveType(typeId: 0)
class ApiKeyModel {

  @HiveField(0)
  final String id;



  const ApiKeyModel(this.id);
}