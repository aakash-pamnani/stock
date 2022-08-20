import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/extensions.dart';
import '../../../screens/StockAddScreen/bloc/AddItemBloc/add_item_bloc.dart';
import '../../../utils/utils.dart';

import '../../../constants/style.dart';
import '../bloc/StockAddScreenBloc/stock_add_screen_bloc.dart';

class AddNewItemDailog extends StatelessWidget {
  const AddNewItemDailog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController size = TextEditingController();
    TextEditingController qty = TextEditingController();

    return BlocProvider<AddItemBloc>(
      create: (context) => AddItemBloc(),
      child: BlocConsumer<AddItemBloc, AddItemState>(
        listener: (context, state) {
          context.read<StockAddScreenBloc>().add(StockAddScreenAddNewItem(
              size: size.text, qty: int.parse(qty.text)));
          pop(context);
        },
        listenWhen: (prev, next) {
          return next.status == AddItemStatus.close;
        },
        builder: (context, state) {
          return AlertDialog(
            title: const Text("Add New Item"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                    controller: size,
                    textInputAction: TextInputAction.next,
                    decoration: TextFieldDecoration
                        .roundedDecoration.withPadding
                        .copyWith(
                            label: const Text("Size"),
                            errorText: state.status == AddItemStatus.sizeError
                                ? state.msg
                                : null)),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    autofocus: false,
                    controller: qty,
                    textInputAction: TextInputAction.next,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: TextFieldDecoration
                        .roundedDecoration.withPadding
                        .copyWith(
                            label: const Text("Qty"),
                            counterText: "",
                            errorText: state.status == AddItemStatus.qtyError
                                ? state.msg
                                : null)),
                ElevatedButton(
                    onPressed: () {
                      context.read<AddItemBloc>().add(AddItemSubmit(
                          size: size.text,
                          qty: int.parse(qty.text.isEmpty ? "0" : qty.text)));
                    },
                    child:const Text("Add"))
              ],
            ),
          );
        },
      ),
    );
  }
}
