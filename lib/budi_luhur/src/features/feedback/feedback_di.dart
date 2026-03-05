import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

Future<void> initFeedbackDI() async {
  sI.registerLazySingleton<FeedbackRepository>(
    () => FeedbackRepositoryImpl(
      sI<FeedbackRemoteDataSource>(),
      sI<FeedbackLocalDataSource>(),
    ),
  );

  sI.registerLazySingleton<FeedbackLocalDataSource>(
    () => FeedbackLocalDataSourceImpl(),
  );
  sI.registerLazySingleton<FeedbackRemoteDataSource>(
    () => FeedbackRemoteDataSourceImpl(),
  );

  sI.registerFactory<FeedbackBloc>(
    () => FeedbackBloc(sI<FeedbackRepository>()),
  );
}
