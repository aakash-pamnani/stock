import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repositories/database_repository.dart';

part 'login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  final DatabaseRepository _database;
  LoginScreenCubit({required DatabaseRepository database})
      : _database = database,
        super(const LoginScreenState());

  Future<bool> onSumbit(String value) async {
    if (value.length < 4) {
      emit(state.copyWith(
          status: LoginScreenStatus.error, msg: "Pin must be of length 4"));
      return false;
    }
    emit(state.copyWith(
      status: LoginScreenStatus.loading,
    ));

    String pin = await _database.getPin();
    if (pin == value) {
      emit(state.copyWith(status: LoginScreenStatus.sucess));
      return true;
    } else {
      emit(state.copyWith(
          status: LoginScreenStatus.error, msg: "Incorrect Pin"));
      return false;
    }
  }
}
