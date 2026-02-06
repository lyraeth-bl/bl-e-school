import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

class DisciplineRepository {
  Future<MeritResponse> fetchMerit(DisciplineParams params) async {
    final response = await ApiClient.get(
      url: ApiEndpoints.merit,
      queryParameters: {
        "NIS": params.nis,
        if ((params.schoolSession ?? '').isNotEmpty)
          "Tajaran": params.schoolSession,
        if ((params.semester ?? '').isNotEmpty) "Semester": params.semester,
      },
      useAuthToken: true,
    );

    final list = (response['data'] as List)
        .map((e) => Merit.fromJson(e))
        .toList();

    return MeritResponse(
      status: response['status'],
      type: DisciplineType.merit,
      total: response['total'] ?? list.length,
      disciplineList: list,
    );
  }

  Future<DemeritResponse> fetchDemerit(DisciplineParams params) async {
    final response = await ApiClient.get(
      url: ApiEndpoints.demerit,
      queryParameters: {
        "NIS": params.nis,
        if ((params.schoolSession ?? '').isNotEmpty)
          "Tajaran": params.schoolSession,
        if ((params.semester ?? '').isNotEmpty) "Semester": params.semester,
      },
      useAuthToken: true,
    );

    final list = (response['data'] as List)
        .map((e) => Demerit.fromJson(e))
        .toList();

    return DemeritResponse(
      status: response['status'],
      type: DisciplineType.demerit,
      total: response['total'] ?? list.length,
      disciplineList: list,
    );
  }
}
