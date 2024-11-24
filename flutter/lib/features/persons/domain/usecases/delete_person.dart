import 'package:fpdart/fpdart.dart';
import 'package:persons/core/errors/kfailure.dart';
import 'package:persons/core/usecase/usecase.dart';
import 'package:persons/features/persons/domain/repository/repository.dart';

class UseCaseDeletePerson implements UseCase<void, UseCaseDeletePersonParams> {
  final RemoteRepository remoteRepository;

  UseCaseDeletePerson(this.remoteRepository);

  @override
  Future<Either<KFailure, void>> call(UseCaseDeletePersonParams params) async =>
      await remoteRepository.deletePerson(params.id);
}

class UseCaseDeletePersonParams {
  final int id;

  UseCaseDeletePersonParams(this.id);
}
