import '../../core/dependencies_injection/get_it_instance.dart';
import 'data/datasources/feedback_local_data_source.dart';
import 'data/datasources/feedback_remote_data_source.dart';
import 'presentation/bloc/feedback_bloc.dart';
import 'repository/feedback_repository.dart';
import 'repository/feedback_repository_impl.dart';

void initFeedbackDI() {
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
