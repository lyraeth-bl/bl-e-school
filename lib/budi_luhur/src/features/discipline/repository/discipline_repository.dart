import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/model/demerit/demerit.dart';
import '../data/model/demerit_response/demerit_response.dart';
import '../data/model/merit/merit.dart';
import '../data/model/merit_response/merit_response.dart';
import '../data/model/params/discipline_params.dart';

abstract class DisciplineRepository {
  Future<Result<MeritResponse>> fetchMerit(DisciplineParams params);

  Future<Result<DemeritResponse>> fetchDemerit(DisciplineParams params);

  List<Merit>? getStoredMerit();

  Future<Unit> storeMerit(List<Merit> listMerit);

  List<Demerit>? getStoredDemerit();

  Future<Unit> storeDemerit(List<Demerit> listDemerit);
}
