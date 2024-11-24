import 'package:fpdart/fpdart.dart';
import 'package:persons/core/errors/kfailure.dart';
import 'package:persons/core/usecase/usecase.dart';
import 'package:persons/features/persons/domain/entities/person_entity.dart';
import 'package:persons/features/persons/domain/repository/repository.dart';

class UseCaseGetAllPersons
    implements UseCase<List<PersonEntity>, UseCaseGetAllPersonsParams> {
  final RemoteRepository remoteRepository;

  UseCaseGetAllPersons(this.remoteRepository);

  @override
  Future<Either<KFailure, List<PersonEntity>>> call(
      UseCaseGetAllPersonsParams params) async {
    return await remoteRepository.getAllPersons();
  }
}

class UseCaseGetAllPersonsParams {}
