import 'package:fpdart/fpdart.dart';
import 'package:persons/core/errors/kfailure.dart';
import 'package:persons/core/usecase/usecase.dart';
import 'package:persons/features/persons/domain/entities/person_entity.dart';
import 'package:persons/features/persons/domain/repository/repository.dart';

class UseCaseAddPerson implements UseCase<void, UseCaseAddPersonParams> {
  final RemoteRepository remoteRepository;

  UseCaseAddPerson(this.remoteRepository);

  @override
  Future<Either<KFailure, void>> call(UseCaseAddPersonParams params) async =>
      await remoteRepository
          .addPerson(PersonEntity(name: params.name, id: 0, age: params.age));
}

class UseCaseAddPersonParams {
  final String name;
  final int age;

  UseCaseAddPersonParams({required this.name, required this.age});
}
