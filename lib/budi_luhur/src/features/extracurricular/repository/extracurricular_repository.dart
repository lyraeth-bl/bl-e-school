import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/model/extracurricular/extracurricular.dart';
import '../data/model/extracurricular_response/extracurricular_response.dart';

abstract class ExtracurricularRepository {
  Future<Result<ExtracurricularResponse>> fetchExtracurricular();

  List<Extracurricular>? getStoredExtracurricular();

  Future<Unit> saveExtracurricular(List<Extracurricular> listExtracurricular);
}
