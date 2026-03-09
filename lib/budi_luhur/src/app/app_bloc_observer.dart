import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint("BlocObserver : ${bloc.runtimeType} $change");
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    debugPrint("BlocEvent : ${bloc.runtimeType} $event");
    super.onEvent(bloc, event);
  }
}
