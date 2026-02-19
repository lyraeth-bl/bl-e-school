import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

class AcademicResultRepository {
  Future<AcademicResultResponse> getResult() async {
    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.result,
        useAuthToken: true,
      );

      return AcademicResultResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
