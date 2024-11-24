import 'package:fpdart/fpdart.dart';
import 'package:persons/core/errors/kfailure.dart';
import 'package:persons/features/persons/domain/entities/person_entity.dart';

abstract interface class RemoteRepository {
  Future<Either<KFailure, List<PersonEntity>>> getAllPersons();

  Future<Either<KFailure, void>> addPerson(PersonEntity personEntity);

  Future<Either<KFailure, void>> deletePerson(int id);
}
