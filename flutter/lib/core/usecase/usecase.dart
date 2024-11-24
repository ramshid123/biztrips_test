import 'package:fpdart/fpdart.dart';
import 'package:persons/core/errors/kfailure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<KFailure, SuccessType>> call(Params params);
}
