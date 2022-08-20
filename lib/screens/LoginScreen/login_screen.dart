import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/constants/extensions.dart';

import '../../constants/style.dart';
import '../../repositories/database_repository.dart';
import '../../utils/utils.dart';
import 'cubit/login_screen_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController pinController = TextEditingController();

    return BlocProvider<LoginScreenCubit>(
      create: (context) =>
          LoginScreenCubit(database: context.read<DatabaseRepository>()),
      child: BlocBuilder<LoginScreenCubit, LoginScreenState>(
        builder: (context, state) {
          return AlertDialog(
            title: const Text("Enter Pin"),
            content: TextFormField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: TextFieldDecoration.roundedDecoration.withPadding
                  .copyWith(
                      errorText: state.status == LoginScreenStatus.error
                          ? state.msg
                          : null),
              style: TextStyles.mediumText.copyWith(
                letterSpacing: 35.0,
                wordSpacing: 0,
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    context
                        .read<LoginScreenCubit>()
                        .onSumbit(pinController.text)
                        .then((value) {
                      if (value) pop<bool>(context, result: true);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: state.status == LoginScreenStatus.loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Submit"),
                  ))
            ],
          );
        },
      ),
    );
  }
}
