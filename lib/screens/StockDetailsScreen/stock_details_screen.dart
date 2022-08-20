import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/screens/StockAddScreen/stock_add_screen.dart';
import 'package:stock/screens/StockDetailsScreen/cubit/stock_details_screen_cubit.dart';

import '../../constants/extensions.dart';
import '../../screens/StockAddScreen/widgets/item_list_tile.dart';
import '../../screens/StockDetailsScreen/widgets/history_dialog.dart';

import '../../model/stock_model.dart';
import '../../utils/utils.dart';

import '../../constants/style.dart';

class StockDetailsScreen extends StatelessWidget {
  const StockDetailsScreen({
    Key? key,
    required this.data,
    required this.category,
  }) : super(key: key);

  final StockModel data;
  final String category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StockDetailsScreenCubit(data: data),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Stock Details"),
          ),
          body: BlocConsumer<StockDetailsScreenCubit, StockDetailsScreenState>(
            listener: (context, state) {
              if (state.status == StockDetailsScreenStatus.loading) {
                showMyDialog(
                    context,
                    AlertDialog(
                      content: Row(children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Loading...")
                      ]),
                    ),
                    false);
              } else {
                pop(context);
              }
            },
            listenWhen: (prev, next) {
              return next.status == StockDetailsScreenStatus.loading ||
                  next.status == StockDetailsScreenStatus.stopLoading;
            },
            buildWhen: (prev, next) {
              return next.status == StockDetailsScreenStatus.loaded;
            },
            builder: (context, state) {
              return WillPopScope(
                onWillPop: (() async {
                  pop<StockModel>(context, result: state.data);
                  return false;
                }),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Name : ${state.data.itemName}",
                        style: TextStyles.mediumText.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Category: $category",
                            style: TextStyles.mediumText.bold,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              showMyDialog(
                                  context,
                                  HistoryDialog(data: state.data.history),
                                  true);
                            },
                            child: const Text("History"))
                      ],
                    ),
                    Text(
                      "Total Qty : ${StockModel.getTotalItems(state.data.itemData).toString()}",
                      style: TextStyles.mediumText.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: MyColors.primaryColor,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Size", style: TextStyles.mediumText.white),
                          Text("Quantity", style: TextStyles.mediumText.white)
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.data.itemData.length,
                          itemBuilder: ((context, index) {
                            return ItemListTile(
                                isEditing: false,
                                size: state.data.itemData[index].size,
                                qty: state.data.itemData[index].quantity,
                                index: index);
                          })),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ButtonStyles
                              .elevatedButtonHolo.withBorder.withPadding
                              .copyWith(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(double.infinity, 0))),
                          onPressed: () async {
                            push<StockModel>(
                                context: context,
                                child: StockAddScreen(
                                  category: category,
                                  data: state.data,
                                )).then((value) {
                              if (value != null) {
                                context
                                    .read<StockDetailsScreenCubit>()
                                    .onUpdate(value);
                              }
                            });
                            // await showMyBottomSheet<List<ItemData>>(
                            //         context, StockEditScreen(data: data))
                            //     .then((value) {
                            //   if (value != null) {
                            //     context
                            //         .read<StockDetailsScreenCubit>()
                            //         .onUpdate(data.copyWith(itemData: value));
                            //   }
                            // });
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
