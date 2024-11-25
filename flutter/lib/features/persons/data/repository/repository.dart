import 'package:fpdart/fpdart.dart';
import 'package:persons/core/errors/kfailure.dart';
import 'package:persons/core/errors/kustom_exception.dart';
import 'package:persons/features/persons/data/data_source/remote_data_source.dart';
import 'package:persons/features/persons/data/model/person_model.dart';
import 'package:persons/features/persons/domain/entities/person_entity.dart';
import 'package:persons/features/persons/domain/repository/repository.dart';

class RemoteRespositoryImpl implements RemoteRepository {
  final RemoteDataSource remoteDataSource;

  RemoteRespositoryImpl(this.remoteDataSource);

  @override
  Future<Either<KFailure, List<PersonModel>>> getAllPersons({int? fromAge, int? toAge, String? name}) async {
    try {
      return right(await remoteDataSource.getAllPersons(fromAge: fromAge, name: name, toAge: toAge));
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, void>> addPerson(PersonEntity personEntity) async {
    try {
      await remoteDataSource.addPerson(PersonModel.fromEntity(personEntity));
      return right(null);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, void>> deletePerson(int id) async {
    try {
      await remoteDataSource.deletePerson(id);
      return right(null);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }
}
