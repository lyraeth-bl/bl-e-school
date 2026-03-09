import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class DisciplineRepository {
  Future<Result<MeritResponse>> fetchMerit(DisciplineParams params);

  Future<Result<DemeritResponse>> fetchDemerit(DisciplineParams params);

  List<Merit>? getStoredMerit();

  Future<Unit> storeMerit(List<Merit> listMerit);

  List<Demerit>? getStoredDemerit();

  Future<Unit> storeDemerit(List<Demerit> listDemerit);
}
