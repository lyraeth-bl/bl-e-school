import 'package:fpdart/fpdart.dart';

import '../../../core/failure/failure.dart';

typedef Result<T> = Either<Failure, T>;
