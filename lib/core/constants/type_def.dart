import 'package:fpdart/fpdart.dart';
import 'package:yappr/core/constants/failure.dart';

typedef FutureEither<T> = Future<Either<Failure,T>>;
typedef FutureVoid = FutureEither<void>;