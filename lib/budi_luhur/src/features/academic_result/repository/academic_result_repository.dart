import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

abstract class AcademicResultRepository {
  Future<Result<AcademicResultResponse>> getResult();
}
