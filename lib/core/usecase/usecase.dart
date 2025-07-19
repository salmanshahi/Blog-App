import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SuccessTpye, Params> {
  Future<Either<Failures, SuccessTpye>> call(Params params);
}

class NoParams {}
