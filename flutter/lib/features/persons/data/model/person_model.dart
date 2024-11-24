import 'package:persons/features/persons/domain/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  PersonModel({
    required super.name,
    required super.id,
    required super.age,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'],
      id: json['id'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson(PersonModel model) {
    return {
      'name': model.name,
      'id': model.id,
      'age': model.age,
    };
  }

  factory PersonModel.fromEntity(PersonEntity entity) {
    return PersonModel(
      name: entity.name,
      id: entity.id,
      age: entity.age,
    );
  }
}
