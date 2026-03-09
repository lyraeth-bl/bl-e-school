import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class ExtracurricularRepository {
  Future<Result<ExtracurricularResponse>> fetchExtracurricular();

  List<Extracurricular>? getStoredExtracurricular();

  Future<Unit> saveExtracurricular(List<Extracurricular> listExtracurricular);

  // async {
  //   try {
  //     final response = await ApiClient.getList(
  //       url: "${ApiEndpoints.extracurricular}/$nis",
  //     );
  //
  //     final data = response
  //         .map((item) => Extracurricular.fromJson(item))
  //         .toList();
  //
  //     return data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
