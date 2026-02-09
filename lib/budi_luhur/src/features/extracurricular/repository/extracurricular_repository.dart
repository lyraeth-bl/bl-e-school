import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

class ExtracurricularRepository {
  Future<List<Extracurricular>> fetchExtracurricular({
    required String nis,
  }) async {
    try {
      final response = await ApiClient.getList(
        url: "${ApiEndpoints.extracurricular}/$nis",
        useAuthToken: true,
      );

      final data = response
          .map((item) => Extracurricular.fromJson(item))
          .toList();

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
