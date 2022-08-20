import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/style.dart';
import '../bloc/StockAddScreenBloc/stock_add_screen_bloc.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile(
      {Key? key,
      required this.size,
      required this.qty,
      required this.index,
      this.isEditing = true})
      : super(key: key);

  final String size;
  final int qty;
  final int index;
  final bool isEditing;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          flex: 1,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              child: Text(
                size,
                textAlign: TextAlign.center,
              )),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isEditing)
                IconButton(
                    onPressed: () {
                      context.read<StockAddScreenBloc>().add(StockAddScreenDecrement(index: index));
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                  child: Text(
                    qty.toString(),
                    textAlign: TextAlign.center,
                  )),
              if (isEditing)
                IconButton(
                    onPressed: () {
                      context.read<StockAddScreenBloc>().add(StockAddScreenIncrement(index: index));

                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    )),
            ],
          ),
        ),
        if (isEditing)
          IconButton(
              onPressed: () {
                      context.read<StockAddScreenBloc>().add(StockAddScreenRemoveItem(index: index));

              },
              icon: Icon(
                Icons.delete,
                color: MyColors.red,
              ))
      ]),
    );
  }
}
