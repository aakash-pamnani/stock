import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      print(transition);
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print(error);
    }
    super.onError(bloc, error, stackTrace);
  }

  // @override
  // void onChange(BlocBase bloc, Change change) {
  //   if (kDebugMode) {
  //     print(change);
  //   }
  //   super.onChange(bloc, change);
  // }

  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      print("Event : $event Bloc : $bloc");
    }
    super.onEvent(bloc, event);
  }

  @override
  void onClose(BlocBase bloc) {
    if (kDebugMode) {
      print("Closed $bloc");
    }
    super.onClose(bloc);
  }
}
