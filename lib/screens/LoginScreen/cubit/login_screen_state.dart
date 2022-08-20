part of 'login_screen_cubit.dart';

enum LoginScreenStatus { initial, loading, sucess, error }

class LoginScreenState extends Equatable {
  const LoginScreenState({this.msg, this.status = LoginScreenStatus.initial});

  final String? msg;
  final LoginScreenStatus status;
  
  @override
  List<Object?> get props => [msg,status];

  LoginScreenState copyWith({
    String? msg,
    LoginScreenStatus? status,
  }) {
    return LoginScreenState(
      msg: msg ?? this.msg,
      status: status ?? this.status,
    );
  }
}

