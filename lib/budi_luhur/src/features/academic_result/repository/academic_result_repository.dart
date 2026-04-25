import '../../../utils/shared/types/types.dart';
import '../data/academic_result_response/academic_result_response.dart';

abstract class AcademicResultRepository {
  Future<Result<AcademicResultResponse>> getResult();
}
