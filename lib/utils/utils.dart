import 'package:flutter/material.dart';
import '../constants/style.dart';

 Future<T?> showMyDialog<T extends Object?>(BuildContext context, Widget child, bool isDismissible) {
  return showDialog<T>(
      context: context,
      builder: (context) => child,
      useRootNavigator: false,
      barrierDismissible: isDismissible);
}

Future<T?> showMyBottomSheet<T extends Object?>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => child,
  );
}

void showScaffoldError(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: MyColors.red,
  ));
}

void showScaffoldSucess(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: MyColors.green,
  ));
}

Future<T?> push<T extends Object?>(
    {required BuildContext context,
    required Widget child}) async {
  var data = await Navigator.of(context)
      .push<T>(MaterialPageRoute(builder: ((context) => child)));
  return data;
}

void pop<T  extends Object?>(BuildContext context,{T? result}) {
  Navigator.of(context).pop<T>(result);
}

void popTillLast(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
